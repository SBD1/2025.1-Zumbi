-- Tabela Conta
CREATE TABLE Conta (
    IDConta SERIAL PRIMARY KEY,
    Email VARCHAR(255),
    Senha VARCHAR(255),
    Status INT 
);

-- Tabela Local
CREATE TABLE Local (
    IDLocal INT PRIMARY KEY,
    Nome VARCHAR(255),
    Precisa_Chave BOOLEAN,
    Norte INT, FOREIGN KEY(Norte) REFERENCES Local(IDLocal), 
    Sul INT, FOREIGN KEY(Sul) REFERENCES Local(IDLocal), 
    Leste INT, FOREIGN KEY(Leste) REFERENCES Local(IDLocal), 
    Oeste INT, FOREIGN KEY(Oeste) REFERENCES Local(IDLocal)
);

-- Tabela TipoZumbi
CREATE TABLE TipoZumbi (
    IDTipoZumbi INT PRIMARY KEY,
    DanoBase INT, 
    Nome VARCHAR(255)
);

-- Tabela Personagem
CREATE TABLE Personagem (
    IDPersonagem SERIAL PRIMARY KEY,
    Nome VARCHAR(255),
    VidaAtual INT,
    IDConta INT,
    IDLocal INT,
    FOREIGN KEY (IDConta) REFERENCES Conta(IDConta),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal)
);



-- Tabela Missao
CREATE TABLE Missao (
    IDMissao INT PRIMARY KEY,
    Nome VARCHAR(255),
    Descricao TEXT,
    Recompensa TEXT,
    Status VARCHAR(50)
);

-- Tabela Dialogos
CREATE TABLE Dialogos (
    IDDialogo INT PRIMARY KEY,
    Titulo VARCHAR(255)
);
CREATE TYPE tipos_itens AS ENUM ('ArmaBranca', 'ArmaDeFogo', 'Medicamentos', 'Chave'); 


-- Tabela Classeltens
CREATE TABLE Classeltens (
    IDClasseltens INT PRIMARY KEY,
    tipos_itens tipos_itens, 
);

-- Tabela Chaves
CREATE TABLE Chaves (
    IDClasseltens INT PRIMARY KEY,
    Nome_Chave VARCHAR(255),
     FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- Tabela ArmaDeFogo
CREATE TABLE ArmaDeFogo (
    IDClasseltens INT PRIMARY KEY,
    Nome VARCHAR(255),
    Munição INT,
    Dano_maximo INT,
    FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- Tabela ArmaBranca
CREATE TABLE ArmaBranca (
    IDClasseltens INT PRIMARY KEY,
    Nome VARCHAR(255),
    Dano_maximo INT,
     FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- Tabela Medicamentos
CREATE TABLE Medicamentos (
    IDClasseltens INT PRIMARY KEY,
    Nome VARCHAR(255),
    Ganho_vida INT,
    FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- Tabela MensagensDialogos
CREATE TABLE MensagensDialogos (
    IDMensagemDialogo INT PRIMARY KEY,
    Texto TEXT,
    Ordem_de_Exibicao INT,
    IDDialogo INT,
    FOREIGN KEY (IDDialogo) REFERENCES Dialogos(IDDialogo)
);

-- Tabela Instancias_Itens 
CREATE TYPE origem_item AS ENUM ('Personagem', 'Local');

CREATE TABLE Instancias_Itens (
    IDInstanciaItem INT PRIMARY KEY,
    IDClasseltens INT NOT NULL,
    Localizacao origem_item NOT NULL,
    IDLocal INT,
    IDPersonagem INT,
    CHECK (
        (Localizacao = 'Local' AND IDLocal IS NOT NULL AND IDPersonagem IS NULL)
        OR
        (Localizacao = 'Personagem' AND IDPersonagem IS NOT NULL AND IDLocal IS NULL)
    ),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal),
    FOREIGN KEY (IDPersonagem) REFERENCES Personagem(IDPersonagem)
);
-- Tabela Instancia_Zumbi
CREATE TABLE Instancia_Zumbi (
    IDInstanciaZumbi INT PRIMARY KEY,
    VidaAtual INT,
    IDLocal INT,
    IDTipoZumbi INT,
    FOREIGN KEY (IDTipoZumbi) REFERENCES TipoZumbi(IDTipoZumbi),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal)
);

-- Tabela Zumbi_Comum
CREATE TABLE Zumbi_Comum (
    IDZumbiComum INT PRIMARY KEY,
    DanoBase INT,
    FOREIGN KEY (IDZumbiComum) REFERENCES TipoZumbi(IDTipoZumbi)
);

-- Tabela Zumbi_Infeccioso
CREATE TABLE Zumbi_Infeccioso (
    IDZumbiInfeccioso INT PRIMARY KEY,
    Taxa_Infeccao INT,
    DanoBase INT,
    FOREIGN KEY (IDZumbiInfeccioso) REFERENCES TipoZumbi(IDTipoZumbi)
);

-- Tabela Zumbi_Brutamonte
CREATE TABLE Zumbi_Brutamonte (
    IDZumbiBrutamonte INT PRIMARY KEY,
    Resistencia_a_bala BOOLEAN,
    DanoBase INT,
    FOREIGN KEY (IDZumbiBrutamonte) REFERENCES TipoZumbi(IDTipoZumbi)
);

-- Tabelas de relacionamento N:N
CREATE TABLE Personagem_Missao (
    IDPersonagem INT,
    IDMissao INT,
    PRIMARY KEY (IDPersonagem, IDMissao),
    FOREIGN KEY (IDPersonagem) REFERENCES Personagem(IDPersonagem),
    FOREIGN KEY (IDMissao) REFERENCES Missao(IDMissao)
);


CREATE TABLE Local_Instancia_Zumbi (
    IDLocal INT,
    IDInstanciaZumbi INT,
    PRIMARY KEY (IDLocal, IDInstanciaZumbi),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal),
    FOREIGN KEY (IDInstanciaZumbi) REFERENCES Instancia_Zumbi(IDInstanciaZumbi)
);

CREATE TABLE Dialogos_Missao (
    IDDialogo INT,
    IDMissao INT,
    PRIMARY KEY (IDDialogo, IDMissao),
    FOREIGN KEY (IDDialogo) REFERENCES Dialogos(IDDialogo),
    FOREIGN KEY (IDMissao) REFERENCES Missao(IDMissao)
);

CREATE TABLE Local_Chaves (
    IDLocal INT,
    IDChave INT,
    PRIMARY KEY (IDLocal, IDChave),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal),
    FOREIGN KEY (IDChave) REFERENCES Chaves(IDClasseltens)
);

CREATE TABLE Personagem_Dialogos (
    IDPersonagem INT,
    IDDialogo INT,
    PRIMARY KEY (IDPersonagem, IDDialogo),
    FOREIGN KEY (IDPersonagem) REFERENCES Personagem(IDPersonagem),
    FOREIGN KEY (IDDialogo) REFERENCES Dialogos(IDDialogo)
);
