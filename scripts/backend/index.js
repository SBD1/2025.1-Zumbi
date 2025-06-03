const express = require('express');
const cors = require('cors');
const app = express();
const pool = require('./db');

app.use(cors());
app.use(express.json());

app.get('/', async (req, res) => {
    try {
        const resultado = await pool.query('SELECT * FROM conta');
        console.log(resultado.rows);
        res.json(resultado.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Erro no servidor');
    }
});

app.post('/login', async (req, res) => {
    try {
        const { email, senha } = req.body;

        if (!email || !senha) {
            return res.status(400).json({ error: 'Email e senha são obrigatórios' });
        }

        const resultado = await pool.query(
            'SELECT * FROM conta WHERE email = $1 AND senha = $2',
            [email, senha]
        );

        if (resultado.rows.length === 0) {
            return res.status(401).json({ error: 'Email ou senha incorretos' });
        }
        res.json({ message: 'Login realizado com sucesso!', conta: resultado.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro no servidor' });
    }
});
app.get('/personagens/:idconta', async (req, res) => {
    const { idconta } = req.params;

    try {
        const resultado = await pool.query(
            'SELECT * FROM personagem WHERE idconta = $1',
            [idconta]
        );
        res.json(resultado.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Erro no servidor');
    }
});

app.get('/personagens/local/:idpersonagem', async (req, res) => {
    const { idpersonagem } = req.params;
    try {
        const resultado = await pool.query(
            'SELECT p.nome, l.nome AS local_nome FROM personagem p JOIN locais l ON l.coordenada_x = p.coordenada_x AND l.coordenada_y = p.coordenada_y Where p.idpersonagem = $1',
            [idpersonagem]
        )
        res.json(resultado.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Erro no servidor');
    }
})

app.get('/personagem/locaispossiveis/:idpersonagem', async (req, res) => {
    const { idpersonagem } = req.params;

    try {
        const resultado = await pool.query(
            `SELECT 'Norte' AS direcao, L.nome 
             FROM personagem P 
             JOIN locais L ON P.coordenada_x = L.coordenada_x 
                          AND P.coordenada_y + 1 = L.coordenada_y
             WHERE P.idpersonagem = $1
             
             UNION ALL
             
             SELECT 'Sul' AS direcao, L.nome 
             FROM personagem P 
             JOIN locais L ON P.coordenada_x = L.coordenada_x 
                          AND P.coordenada_y - 1 = L.coordenada_y
             WHERE P.idpersonagem = $1
             
             UNION ALL
             
             SELECT 'Leste' AS direcao, L.nome 
             FROM personagem P 
             JOIN locais L ON P.coordenada_x + 1 = L.coordenada_x 
                          AND P.coordenada_y = L.coordenada_y
             WHERE P.idpersonagem = $1
             
             UNION ALL
             
             SELECT 'Oeste' AS direcao, L.nome 
             FROM personagem P 
             JOIN locais L ON P.coordenada_x - 1 = L.coordenada_x 
                          AND P.coordenada_y = L.coordenada_y
             WHERE P.idpersonagem = $1`,
            [idpersonagem]
        );

        res.status(200).json(resultado.rows);
    } catch (err) {
        console.error('Erro ao buscar locais possíveis:', err);
        res.status(500).json({ erro: 'Erro interno do servidor' });
    }
});


app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
});
