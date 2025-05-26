--Autor: João Filipe
--Matricula: 231035141
--DDL
----------------------------
-- 1. Tabela Conta
----------------------------
CREATE TABLE Conta (
    IDConta SERIAL PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Senha VARCHAR(255) NOT NULL,
    Status INTEGER NOT NULL
);

----------------------------
-- 2. Tabela Inventario
----------------------------
CREATE TABLE Inventario (
    IDInventario SERIAL PRIMARY KEY,
    CapacidadeMaxima INTEGER NOT NULL
);

----------------------------
-- 3. Tabela Personagem
----------------------------
CREATE TABLE Personagem (
    IDPersonagem SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Nivel INTEGER NOT NULL,
    VidaMaxima INTEGER NOT NULL,
    VidaAtual INTEGER NOT NULL,
    IDConta INTEGER REFERENCES Conta(IDConta) ON DELETE CASCADE,
    IDInventario INTEGER REFERENCES Inventario(IDInventario) ON DELETE SET NULL
);

----------------------------
-- 4. Tabela ArmaBranca
----------------------------
CREATE TABLE ArmaBranca (
    IDArma SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    DanoCorte INTEGER NOT NULL
);

----------------------------
-- 5. Tabela Arma_de_Fogo
----------------------------
CREATE TABLE Arma_de_Fogo (
    IDArma SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Municao INTEGER NOT NULL
);

----------------------------
-- 6. Tabela InstanciaItens
----------------------------
CREATE TABLE InstanciaItens (
    IDInstanciaItens SERIAL PRIMARY KEY,
    Quantidade INTEGER NOT NULL,
    IDInventario INTEGER REFERENCES Inventario(IDInventario) ON DELETE CASCADE,
    TipoItem VARCHAR(20) NOT NULL CHECK (TipoItem IN ('ArmaBranca', 'Arma_de_Fogo')),
    IDItem INTEGER NOT NULL
);
----------------------------
-- 7. Tabela Locais
----------------------------
CREATE TABLE Locais (
    IDLocal SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Coordenada_X INTEGER NOT NULL,
    Coordenada_Y INTEGER NOT NULL,
    IDPersonagem INTEGER REFERENCES Personagem(IDPersonagem) ON DELETE SET NULL
);

----------------------------
-- 8. Relacionamento AparecemEm_Itens
----------------------------
CREATE TABLE AparecemEm_Itens (
    IDInstanciaItens INTEGER REFERENCES InstanciaItens(IDInstanciaItens) ON DELETE CASCADE,
    IDLocal INTEGER REFERENCES Locais(IDLocal) ON DELETE CASCADE,
    PRIMARY KEY (IDInstanciaItens, IDLocal)
);

----------------------------
-- 9. Tabela Zumbi
----------------------------
CREATE TABLE Zumbi (
    IDZumbi SERIAL PRIMARY KEY,
    Nivel INTEGER NOT NULL,
    DanoBase INTEGER NOT NULL
);

----------------------------
-- 10. Relacionamento AparecemEm_Zumbis
----------------------------
CREATE TABLE AparecemEm_Zumbis (
    IDZumbi INTEGER REFERENCES Zumbi(IDZumbi) ON DELETE CASCADE,
    IDLocal INTEGER REFERENCES Locais(IDLocal) ON DELETE CASCADE,
    PRIMARY KEY (IDZumbi, IDLocal)
);

----------------------------
-- 11. Tabela Missoes
----------------------------
CREATE TABLE Missoes (
    IDMissao SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Descricao VARCHAR(255) NOT NULL,
    Recompensa VARCHAR(255) NOT NULL,
    Status INTEGER NOT NULL,
    IDPersonagem INTEGER REFERENCES Personagem(IDPersonagem) ON DELETE SET NULL,
    IDLocal INTEGER REFERENCES Locais(IDLocal) ON DELETE SET NULL
);

----------------------------
-- 12. Tabela Dialogos
----------------------------
CREATE TABLE Dialogos (
    IDDialogo SERIAL PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL
);

----------------------------
-- 13. Tabela MensagemDialogo
----------------------------
CREATE TABLE MensagemDialogo (
    IDMensagemDialogo SERIAL PRIMARY KEY,
    Texto VARCHAR(255) NOT NULL,
    OrdemExibicao INTEGER NOT NULL
);

----------------------------
-- 14. Relacionamento Contem_Dialogo_Mensagem
----------------------------
CREATE TABLE Contem_Dialogo_Mensagem (
    IDDialogo INTEGER REFERENCES Dialogos(IDDialogo) ON DELETE CASCADE,
    IDMensagemDialogo INTEGER REFERENCES MensagemDialogo(IDMensagemDialogo) ON DELETE CASCADE,
    PRIMARY KEY (IDDialogo, IDMensagemDialogo)
);

----------------------------
-- 15. Relacionamento InterageCom
----------------------------
CREATE TABLE InterageCom (
    IDPersonagem INTEGER REFERENCES Personagem(IDPersonagem) ON DELETE CASCADE,
    IDDialogo INTEGER REFERENCES Dialogos(IDDialogo) ON DELETE CASCADE,
    PRIMARY KEY (IDPersonagem, IDDialogo)
);

----------------------------
-- 16. Tabela GatilhoDialogo
----------------------------
CREATE TABLE GatilhoDialogo (
    IDGatilho SERIAL PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL
);

----------------------------
-- 17. Relacionamento EAtivadoPor
----------------------------
CREATE TABLE EAtivadoPor (
    IDDialogo INTEGER REFERENCES Dialogos(IDDialogo) ON DELETE CASCADE,
    IDGatilho INTEGER REFERENCES GatilhoDialogo(IDGatilho) ON DELETE CASCADE,
    PRIMARY KEY (IDDialogo, IDGatilho)
);