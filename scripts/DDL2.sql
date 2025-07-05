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
    Descricao TEXT, 
    Precisa_Chave BOOLEAN,
    Norte INT, FOREIGN KEY(Norte) REFERENCES Local(IDLocal), 
    Sul INT, FOREIGN KEY(Sul) REFERENCES Local(IDLocal), 
    Leste INT, FOREIGN KEY(Leste) REFERENCES Local(IDLocal), 
    Oeste INT, FOREIGN KEY(Oeste) REFERENCES Local(IDLocal)
);

-- Tabela TipoZumbi
CREATE TABLE TipoZumbi (
    IDTipoZumbi INT PRIMARY KEY, 
    Nome VARCHAR(255)
);

-- Tabela Personagem
CREATE TABLE Personagem (
    IDPersonagem SERIAL PRIMARY KEY,
    Nome VARCHAR(255),
    VidaAtual INT NOT NULL CHECK (VidaAtual >= 0 AND VidaAtual <= 100),
    IDConta INT,
    IDLocal INT,
    FOREIGN KEY (IDConta) REFERENCES Conta(IDConta),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal)
);

-- Tipo ENUM para itens
CREATE TYPE tipos_itens AS ENUM ('ArmaBranca', 'ArmaDeFogo', 'Medicamentos', 'Chave');

-- Tabela Classeltens
CREATE TABLE Classeltens (
    IDClasseltens INT PRIMARY KEY,
    tipos_itens tipos_itens
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

-- Tabela Dialogos
CREATE TABLE Dialogos (
    IDDialogo INT PRIMARY KEY,
    Titulo VARCHAR(255)
);

-- Tabela MensagensDialogos
CREATE TABLE MensagensDialogos (
    IDMensagemDialogo INT PRIMARY KEY,
    Texto TEXT,
    Ordem_de_Exibicao INT,
    IDDialogo INT,
    FOREIGN KEY (IDDialogo) REFERENCES Dialogos(IDDialogo)
);

-- Tipo ENUM para origem de itens
CREATE TYPE origem_item AS ENUM ('Personagem', 'Local');

-- Tabela Instancias_Itens
CREATE TABLE Instancias_Itens (
    IDInstanciaItem INT PRIMARY KEY,
    IDClasseltens INT NOT NULL,
    Localizacao origem_item NOT NULL,
    IDLocal INT,
    IDPersonagem INT,
    Municao INT,  
    CHECK (
        (Localizacao = 'Local' AND IDLocal IS NOT NULL AND IDPersonagem IS NULL)
        OR
        (Localizacao = 'Personagem' AND IDPersonagem IS NOT NULL AND IDLocal IS NULL)
    ),
    FOREIGN KEY (IDLocal) REFERENCES Local(IDLocal),
    FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens), 
    FOREIGN KEY (IDPersonagem) REFERENCES Personagem(IDPersonagem)
);

-- Tabela Instancia_Zumbi
CREATE TABLE Instancia_Zumbi (
    IDInstanciaZumbi INT PRIMARY KEY,
    VidaAtual INT NOT NULL CHECK (VidaAtual >= 0 AND VidaAtual <= 100),
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

-- Tabela Missao (COM ALTERAÇÕES)
CREATE TABLE Missao (
    IDMissao INT PRIMARY KEY,
    Nome VARCHAR(255),
    Descricao TEXT,
    Recompensa TEXT,
    Status VARCHAR(50),
    Tipo VARCHAR(20) NOT NULL DEFAULT 'COLETA',
    Parametros JSONB,
    TipoRecompensa VARCHAR(20)
);

-- Tabelas de relacionamento N:N
CREATE TABLE Personagem_Missao (
    IDPersonagem INT,
    IDMissao INT,
    Status VARCHAR(20) DEFAULT 'ATIVA',
    PRIMARY KEY (IDPersonagem, IDMissao),
    FOREIGN KEY (IDPersonagem) REFERENCES Personagem(IDPersonagem),
    FOREIGN KEY (IDMissao) REFERENCES Missao(IDMissao)
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

-- Trigger para garantir que a vida do personagem seja atualizada corretamente
CREATE OR REPLACE FUNCTION atualizar_vida_personagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Garante que a vida não ultrapasse 100
    IF NEW.VidaAtual > 100 THEN
        NEW.VidaAtual := 100;
    END IF;
    
    -- Garante que a vida não seja negativa
    IF NEW.VidaAtual < 0 THEN
        NEW.VidaAtual := 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_vida_personagem
    BEFORE UPDATE ON Personagem
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_vida_personagem();

-- Trigger para registrar uso de medicamentos
CREATE OR REPLACE FUNCTION registrar_uso_medicamento()
RETURNS TRIGGER AS $$
DECLARE
    ganho_vida INTEGER;
    vida_atual INTEGER;
    nova_vida INTEGER;
BEGIN
    -- Se um item de medicamento foi deletado (usado)
    IF TG_OP = 'DELETE' THEN
        -- Busca o ganho de vida do medicamento
        SELECT m.Ganho_vida INTO ganho_vida
        FROM Medicamentos m
        WHERE m.IDClasseltens = OLD.IDClasseltens;
        
        -- Se é um medicamento
        IF ganho_vida IS NOT NULL THEN
            -- Busca a vida atual do personagem
            SELECT p.VidaAtual INTO vida_atual
            FROM Personagem p
            WHERE p.IDPersonagem = OLD.IDPersonagem;
            
            -- Calcula nova vida
            nova_vida := LEAST(100, vida_atual + ganho_vida);
            
            -- Atualiza a vida do personagem
            UPDATE Personagem 
            SET VidaAtual = nova_vida 
            WHERE IDPersonagem = OLD.IDPersonagem;
            
            -- Log da ação (opcional)
            RAISE NOTICE 'Medicamento usado: Personagem % curou % pontos de vida. Nova vida: %', 
                        OLD.IDPersonagem, ganho_vida, nova_vida;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_registrar_uso_medicamento
    AFTER DELETE ON Instancias_Itens
    FOR EACH ROW
    EXECUTE FUNCTION registrar_uso_medicamento();

-- Tabela para definir drops de zumbis
CREATE TABLE Zumbi_Drops (
    IDZumbiDrop SERIAL PRIMARY KEY,
    IDTipoZumbi INT,
    IDClasseltens INT,
    Probabilidade DECIMAL(5,2) CHECK (Probabilidade >= 0 AND Probabilidade <= 100),
    Quantidade_Min INT DEFAULT 1,
    Quantidade_Max INT DEFAULT 1,
    FOREIGN KEY (IDTipoZumbi) REFERENCES TipoZumbi(IDTipoZumbi),
    FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- Trigger para gerar drops quando zumbi morre
CREATE OR REPLACE FUNCTION gerar_drop_zumbi()
RETURNS TRIGGER AS $$
DECLARE
    drop_record RECORD;
    chance DECIMAL(5,2);
    quantidade INT;
    novo_id_item INT;
BEGIN
    -- Se o zumbi morreu (vida = 0)
    IF NEW.VidaAtual = 0 AND OLD.VidaAtual > 0 THEN
        -- Para cada possível drop deste tipo de zumbi
        FOR drop_record IN 
            SELECT zd.*, c.tipos_itens
            FROM Zumbi_Drops zd
            JOIN Classeltens c ON c.IDClasseltens = zd.IDClasseltens
            WHERE zd.IDTipoZumbi = NEW.IDTipoZumbi
        LOOP
            -- Gera número aleatório para verificar probabilidade
            chance := random() * 100;
            
            -- Se passou na verificação de probabilidade
            IF chance <= drop_record.Probabilidade THEN
                -- Determina quantidade a dropar
                quantidade := drop_record.Quantidade_Min + 
                             floor(random() * (drop_record.Quantidade_Max - drop_record.Quantidade_Min + 1));
                
                -- Para cada item a ser dropado
                FOR i IN 1..quantidade LOOP
                    -- Gera novo ID para o item
                    SELECT COALESCE(MAX(IDInstanciaItem), 0) + 1 INTO novo_id_item 
                    FROM Instancias_Itens;
                    
                    -- Insere o item no local onde o zumbi morreu
                    INSERT INTO Instancias_Itens (
                        IDInstanciaItem, 
                        IDClasseltens, 
                        Localizacao, 
                        IDLocal, 
                        IDPersonagem, 
                        Municao
                    ) VALUES (
                        novo_id_item,
                        drop_record.IDClasseltens,
                        'Local',
                        NEW.IDLocal,
                        NULL,
                        CASE 
                            WHEN drop_record.tipos_itens = 'ArmaDeFogo' THEN 10
                            ELSE NULL
                        END
                    );
                    
                    -- Log do drop
                    RAISE NOTICE 'Zumbi % dropou %x % no local %', 
                                NEW.IDInstanciaZumbi, quantidade, drop_record.IDClasseltens, NEW.IDLocal;
                END LOOP;
            END IF;
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gerar_drop_zumbi
    AFTER UPDATE ON Instancia_Zumbi
    FOR EACH ROW
    EXECUTE FUNCTION gerar_drop_zumbi();