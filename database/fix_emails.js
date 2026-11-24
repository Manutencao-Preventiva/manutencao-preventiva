const mysql = require('mysql2/promise');

async function fixEmails() {
  const conn = await mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'manutencao_db',
  });

  console.log('Conectado ao MySQL');

  // 1. Ver usuarios com email vazio ou null
  const [rows] = await conn.execute(
    "SELECT id, nome, email FROM usuarios WHERE email = '' OR email IS NULL"
  );
  console.log('Usuarios com email vazio:', rows);

  // 2. Atualizar cada um com email unico placeholder
  for (const row of rows) {
    const novoEmail = `usuario_${row.id}@placeholder.com`;
    await conn.execute('UPDATE usuarios SET email = ? WHERE id = ?', [novoEmail, row.id]);
    console.log(`  Usuario id=${row.id} (${row.nome}) -> email: ${novoEmail}`);
  }

  // 3. Tentar dropar o indice problematico se existir
  try {
    await conn.execute('ALTER TABLE usuarios DROP INDEX IDX_446adfc18b35418aac32ae0b7b');
    console.log('Indice IDX_446adfc18b35418aac32ae0b7b removido');
  } catch (e) {
    console.log('Indice ja nao existe ou outro erro:', e.message);
  }

  // 4. Verificar resultado
  const [check] = await conn.execute('SELECT id, nome, email FROM usuarios');
  console.log('\nTodos os usuarios apos correcao:');
  for (const u of check) {
    console.log(`  id=${u.id} nome=${u.nome} email=${u.email}`);
  }

  await conn.end();
  console.log('\nCorrecao concluida!');
}

fixEmails().catch(err => {
  console.error('ERRO:', err.message);
  process.exit(1);
});
