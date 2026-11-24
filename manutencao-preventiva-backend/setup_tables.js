const mysql = require('./node_modules/mysql2/promise');

async function setup() {
  const conn = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
  });

  console.log('Connected to MySQL');

  // Create database if not exists
  await conn.query(`CREATE DATABASE IF NOT EXISTS \`manutencao_db\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`);
  await conn.query(`CREATE DATABASE IF NOT EXISTS \`manutencao\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`);

  for (const dbName of ['manutencao_db', 'manutencao']) {
    console.log(`Setting up database: ${dbName}...`);
    await conn.query(`USE \`${dbName}\`;`);

    // 1. usuarios
    await conn.query(`
      CREATE TABLE IF NOT EXISTS \`usuarios\` (
        \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
        \`nome\` varchar(150) NOT NULL,
        \`email\` varchar(180) NOT NULL,
        \`senha\` varchar(255) NOT NULL,
        \`perfil\` enum('ADMIN', 'GESTOR', 'OPERADOR', 'MANUTENCAO') NOT NULL DEFAULT 'OPERADOR',
        \`ativo\` tinyint(1) NOT NULL DEFAULT 1,
        \`gestor\` tinyint(1) NOT NULL DEFAULT 0,
        \`telefone\` varchar(255) DEFAULT NULL,
        \`criado_em\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        UNIQUE KEY \`uniq_email\` (\`email\`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);

    // Make sure usuarios.id is bigint unsigned as in ERD diagram
    try {
      await conn.query(`ALTER TABLE \`usuarios\` MODIFY \`id\` bigint unsigned NOT NULL AUTO_INCREMENT;`);
    } catch (_) {}

    // Check if columns exist in usuarios, add if missing
    const [cols] = await conn.query(`DESCRIBE \`usuarios\`;`);
    const colNames = cols.map((c) => c.Field);
    if (!colNames.includes('perfil')) {
      await conn.query(`ALTER TABLE \`usuarios\` ADD COLUMN \`perfil\` enum('ADMIN', 'GESTOR', 'OPERADOR', 'MANUTENCAO') NOT NULL DEFAULT 'OPERADOR' AFTER \`senha\`;`);
    }
    if (!colNames.includes('ativo')) {
      await conn.query(`ALTER TABLE \`usuarios\` ADD COLUMN \`ativo\` tinyint(1) NOT NULL DEFAULT 1 AFTER \`perfil\`;`);
    }
    if (!colNames.includes('criado_em')) {
      await conn.query(`ALTER TABLE \`usuarios\` ADD COLUMN \`criado_em\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP;`);
    }

    // Update gestores perfil
    await conn.query(`UPDATE \`usuarios\` SET \`perfil\` = 'GESTOR' WHERE \`gestor\` = 1 OR \`email\` LIKE '%gestor%' OR \`nome\` LIKE '%gestor%';`);

    // 2. maquinas
    await conn.query(`
      CREATE TABLE IF NOT EXISTS \`maquinas\` (
        \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
        \`nome\` varchar(150) NOT NULL,
        \`codigo\` varchar(80) NOT NULL,
        \`tipo\` varchar(100) NOT NULL,
        \`fabricante\` varchar(120) NOT NULL,
        \`modelo\` varchar(120) NOT NULL,
        \`horimetro_atual\` decimal(10,2) NOT NULL DEFAULT 0.00,
        \`status\` enum('ATIVA', 'EM_MANUTENCAO', 'INATIVA') NOT NULL DEFAULT 'ATIVA',
        \`criada_em\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        UNIQUE KEY \`uniq_codigo\` (\`codigo\`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);

    // 3. horas
    await conn.query(`
      CREATE TABLE IF NOT EXISTS \`horas\` (
        \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
        \`maquina_id\` bigint unsigned NOT NULL,
        \`usuario_id\` bigint unsigned NOT NULL,
        \`data_operacao\` date NOT NULL,
        \`horas_trabalhadas\` decimal(8,2) NOT NULL,
        \`horimetro_inicio\` decimal(10,2) NOT NULL,
        \`horimetro_fim\` decimal(10,2) NOT NULL,
        \`observacoes\` text DEFAULT NULL,
        \`criado_em\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        KEY \`fk_horas_maquina\` (\`maquina_id\`),
        KEY \`fk_horas_usuario\` (\`usuario_id\`),
        CONSTRAINT \`fk_horas_maquina_${dbName}\` FOREIGN KEY (\`maquina_id\`) REFERENCES \`maquinas\` (\`id\`) ON DELETE CASCADE,
        CONSTRAINT \`fk_horas_usuario_${dbName}\` FOREIGN KEY (\`usuario_id\`) REFERENCES \`usuarios\` (\`id\`) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);

    // 4. notificacoes
    await conn.query(`
      CREATE TABLE IF NOT EXISTS \`notificacoes\` (
        \`id\` bigint unsigned NOT NULL AUTO_INCREMENT,
        \`usuario_id\` bigint unsigned NOT NULL,
        \`maquina_id\` bigint unsigned DEFAULT NULL,
        \`tipo\` enum('MANUTENCAO', 'HORAS', 'SISTEMA', 'AVISO') NOT NULL DEFAULT 'AVISO',
        \`titulo\` varchar(200) NOT NULL,
        \`mensagem\` text NOT NULL,
        \`lida\` tinyint(1) NOT NULL DEFAULT 0,
        \`criada_em\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        KEY \`fk_notificacoes_usuario\` (\`usuario_id\`),
        KEY \`fk_notificacoes_maquina\` (\`maquina_id\`),
        CONSTRAINT \`fk_notificacoes_usuario_${dbName}\` FOREIGN KEY (\`usuario_id\`) REFERENCES \`usuarios\` (\`id\`) ON DELETE CASCADE,
        CONSTRAINT \`fk_notificacoes_maquina_${dbName}\` FOREIGN KEY (\`maquina_id\`) REFERENCES \`maquinas\` (\`id\`) ON DELETE SET NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);

    // Ensure at least sample users exist if table is empty
    const [uCount] = await conn.query(`SELECT COUNT(*) as total FROM \`usuarios\`;`);
    if (uCount[0].total === 0) {
      await conn.query(`
        INSERT INTO \`usuarios\` (\`nome\`, \`email\`, \`senha\`, \`perfil\`, \`ativo\`, \`gestor\`, \`telefone\`) VALUES
        ('Carlos Eduardo Silva', 'gestor@industria.com', '$2b$10$rvIxr5Ks/cFCEeXza7ZUmur2gN9ZjPapfkIxRfqcv8O7cbKFs9iUG', 'GESTOR', 1, 1, '(11) 98765-4321'),
        ('Lucas Mendonça', 'lucas@industria.com', '$2b$10$rvIxr5Ks/cFCEeXza7ZUmur2gN9ZjPapfkIxRfqcv8O7cbKFs9iUG', 'OPERADOR', 1, 0, '(11) 91234-5678'),
        ('Mariana Souza', 'mariana@industria.com', '$2b$10$rvIxr5Ks/cFCEeXza7ZUmur2gN9ZjPapfkIxRfqcv8O7cbKFs9iUG', 'OPERADOR', 1, 0, '(11) 99887-7665');
      `);
    }

    // Inserir dados reais de máquinas se estiver vazio
    const [maqCount] = await conn.query(`SELECT COUNT(*) as total FROM \`maquinas\`;`);
    if (maqCount[0].total === 0) {
      console.log(`Seeding machines into ${dbName}...`);
      await conn.query(`
        INSERT INTO \`maquinas\` (\`nome\`, \`codigo\`, \`tipo\`, \`fabricante\`, \`modelo\`, \`horimetro_atual\`, \`status\`) VALUES
        ('Torno Mecânico ROMI', 'TOR-01', 'Torno Mecânico', 'ROMI', 'Centur 30D', 1420.50, 'ATIVA'),
        ('Torno Mecânico NARDINI', 'TOR-02', 'Torno Mecânico', 'NARDINI', 'Masicote MS-220', 890.20, 'EM_MANUTENCAO'),
        ('Fresadora Universal KONI KFU-1', 'FRS-01', 'Fresadora', 'KONI', 'KFU-1 Universal', 645.00, 'ATIVA'),
        ('Fresadora KONI KFU-2', 'FRS-02', 'Fresadora', 'KONI', 'KFU-2 Vertical', 1150.80, 'ATIVA'),
        ('Retífica Plana Ferdimat', 'RET-01', 'Retífica', 'Ferdimat', 'TA-60', 312.40, 'INATIVA');
      `);
    }

    // Obter um usuário para vincular apontamentos
    const [users] = await conn.query(`SELECT id FROM \`usuarios\` LIMIT 2;`);
    const userId1 = users[0] ? users[0].id : 1;
    const userId2 = users[1] ? users[1].id : userId1;

    // Obter IDs de máquinas
    const [maqs] = await conn.query(`SELECT id FROM \`maquinas\` LIMIT 4;`);

    // Inserir dados de horas se estiver vazio
    const [horasCount] = await conn.query(`SELECT COUNT(*) as total FROM \`horas\`;`);
    if (horasCount[0].total === 0 && maqs.length > 0) {
      console.log(`Seeding horas into ${dbName}...`);
      await conn.query(`
        INSERT INTO \`horas\` (\`maquina_id\`, \`usuario_id\`, \`data_operacao\`, \`horas_trabalhadas\`, \`horimetro_inicio\`, \`horimetro_fim\`, \`observacoes\`) VALUES
        (${maqs[0].id}, ${userId1}, CURDATE() - INTERVAL 2 DAY, 4.00, 1412.50, 1416.50, 'Operação do 1º turno - usinagem de eixos'),
        (${maqs[0].id}, ${userId1}, CURDATE() - INTERVAL 1 DAY, 4.00, 1416.50, 1420.50, 'Usinagem de peças de alumínio, lubrificação checada'),
        (${maqs[1].id}, ${userId2}, CURDATE() - INTERVAL 1 DAY, 2.50, 887.70, 890.20, 'Alerta de vibração no cabeçote móvel, enviado para revisão'),
        (${maqs[2].id}, ${userId1}, CURDATE(), 3.50, 641.50, 645.00, 'Fresa de faceamento operando perfeitamente');
      `);
    }

    // Inserir notificações se estiver vazio
    const [notifCount] = await conn.query(`SELECT COUNT(*) as total FROM \`notificacoes\`;`);
    if (notifCount[0].total === 0 && maqs.length > 0) {
      console.log(`Seeding notificacoes into ${dbName}...`);
      await conn.query(`
        INSERT INTO \`notificacoes\` (\`usuario_id\`, \`maquina_id\`, \`tipo\`, \`titulo\`, \`mensagem\`, \`lida\`) VALUES
        (${userId1}, ${maqs[1].id}, 'MANUTENCAO', 'Manutenção Preventiva Necessária', 'Torno Mecânico NARDINI atingiu intervalo de troca de óleo e ajuste de correia.', 0),
        (${userId1}, ${maqs[0].id}, 'HORAS', 'Registro de Horímetro Concluído', '4 horas trabalhadas adicionadas ao Torno ROMI hoje.', 1),
        (${userId2}, ${maqs[2].id}, 'AVISO', 'Inspeção NR-12 Conforme', 'Checklist matinal concluído com 100% de conformidade.', 0),
        (${userId1}, NULL, 'SISTEMA', 'Atualização da Norma NR-12', 'Novo protocolo de segurança cadastrado para o parque fabril.', 1);
      `);
    }

    console.log(`Database ${dbName} initialized successfully.`);
  }

  await conn.end();
  console.log('All done!');
}

setup().catch((err) => {
  console.error('Setup error:', err);
  process.exit(1);
});
