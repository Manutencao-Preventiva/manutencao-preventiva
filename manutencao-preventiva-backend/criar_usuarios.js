const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');

async function criarUsuarios() {
  const conn = await mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'manutencao_db',
  });

  console.log('Conectado ao MySQL');

  // Senha hasheada para "gestor123"
  const senhaGestor = await bcrypt.hash('gestor123', 10);
  // Senha hasheada para "operador123"
  const senhaOperador = await bcrypt.hash('operador123', 10);

  // Verificar se ja existe usuario gestor com email correto
  const [existentes] = await conn.execute(
    "SELECT id, email, gestor FROM usuarios WHERE email NOT LIKE '%placeholder%'"
  );
  console.log('Usuarios com email real:', existentes);

  // Deletar os usuarios lixo (id 2-10, sem nome real)
  await conn.execute("DELETE FROM usuarios WHERE nome = '' OR nome IS NULL");
  console.log('Usuarios sem nome deletados');

  // Inserir gestor
  const gestorEmail = 'gestor@manutencao.com';
  const operadorEmail = 'operador@manutencao.com';

  // Verificar se ja existem
  const [jaTem] = await conn.execute(
    'SELECT id, email FROM usuarios WHERE email IN (?, ?)',
    [gestorEmail, operadorEmail]
  );

  const emailsExistentes = jaTem.map(r => r.email);

  if (!emailsExistentes.includes(gestorEmail)) {
    await conn.execute(
      'INSERT INTO usuarios (nome, email, senha, perfil, gestor, ativo) VALUES (?, ?, ?, ?, ?, ?)',
      ['Gestor Principal', gestorEmail, senhaGestor, 'GESTOR', 1, 1]
    );
    console.log('Gestor criado: gestor@manutencao.com / gestor123');
  } else {
    // Atualiza senha do gestor existente
    await conn.execute(
      'UPDATE usuarios SET senha = ?, nome = ?, gestor = 1 WHERE email = ?',
      [senhaGestor, 'Gestor Principal', gestorEmail]
    );
    console.log('Gestor atualizado com nova senha');
  }

  if (!emailsExistentes.includes(operadorEmail)) {
    await conn.execute(
      'INSERT INTO usuarios (nome, email, senha, perfil, gestor, ativo) VALUES (?, ?, ?, ?, ?, ?)',
      ['Carlos Operador', operadorEmail, senhaOperador, 'OPERADOR', 0, 1]
    );
    console.log('Operador criado: operador@manutencao.com / operador123');
  } else {
    await conn.execute(
      'UPDATE usuarios SET senha = ?, nome = ? WHERE email = ?',
      [senhaOperador, 'Carlos Operador', operadorEmail]
    );
    console.log('Operador atualizado com nova senha');
  }

  // Mostrar todos os usuarios finais
  const [todos] = await conn.execute('SELECT id, nome, email, gestor FROM usuarios');
  console.log('\nUsuarios finais no banco:');
  for (const u of todos) {
    console.log(`  id=${u.id} | ${u.nome} | ${u.email} | gestor=${u.gestor}`);
  }

  await conn.end();
  console.log('\nPronto!');
  console.log('\n=== CREDENCIAIS DE ACESSO ===');
  console.log('GESTOR:   gestor@manutencao.com   / gestor123');
  console.log('OPERADOR: operador@manutencao.com / operador123');
}

criarUsuarios().catch(err => {
  console.error('ERRO:', err.message);
  process.exit(1);
});
