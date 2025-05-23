const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'ZUmbi',
    password: '',
    port: 5432, // padrão do PostgreSQL
});

module.exports = pool;
