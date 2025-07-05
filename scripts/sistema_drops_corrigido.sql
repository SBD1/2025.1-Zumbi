/*
Script corrigido para adicionar sistema de drops de zumbis
Execute este script se você já tem um banco de dados existente
*/

-- 1. Verificar se os itens necessários existem
DO $$
DECLARE
    item_count INTEGER;
BEGIN
    -- Verificar Classeltens
    SELECT COUNT(*) INTO item_count FROM Classeltens WHERE IDClasseltens IN (2,3,4,5,6,7,8,10);
    IF item_count < 8 THEN
        RAISE NOTICE 'Adicionando itens faltantes na tabela Classeltens...';
        
        INSERT INTO Classeltens (IDClasseltens, tipos_itens) VALUES
        (4, 'Medicamentos'),
        (5, 'Medicamentos'),
        (6, 'ArmaDeFogo'),
        (7, 'ArmaBranca'),
        (8, 'Medicamentos')
        ON CONFLICT (IDClasseltens) DO NOTHING;
    END IF;
    
    -- Verificar Medicamentos
    SELECT COUNT(*) INTO item_count FROM Medicamentos WHERE IDClasseltens IN (3,4,5,8);
    IF item_count < 4 THEN
        RAISE NOTICE 'Adicionando medicamentos faltantes...';
        
        INSERT INTO Medicamentos (IDClasseltens, Nome, Ganho_vida) VALUES
        (4, 'Kit Médico', 50),
        (5, 'Poção de Cura', 100),
        (8, 'Bandagem', 15)
        ON CONFLICT (IDClasseltens) DO NOTHING;
    END IF;
    
    -- Verificar Armas Brancas
    SELECT COUNT(*) INTO item_count FROM ArmaBranca WHERE IDClasseltens IN (2,7);
    IF item_count < 2 THEN
        RAISE NOTICE 'Adicionando armas brancas faltantes...';
        
        INSERT INTO ArmaBranca (IDClasseltens, Nome, Dano_maximo) VALUES
        (7, 'Machado', 25)
        ON CONFLICT (IDClasseltens) DO NOTHING;
    END IF;
    
    -- Verificar Armas de Fogo
    SELECT COUNT(*) INTO item_count FROM ArmaDeFogo WHERE IDClasseltens IN (6);
    IF item_count < 1 THEN
        RAISE NOTICE 'Adicionando armas de fogo faltantes...';
        
        INSERT INTO ArmaDeFogo (IDClasseltens, Nome, Dano_maximo) VALUES
        (6, 'Pistola', 30)
        ON CONFLICT (IDClasseltens) DO NOTHING;
    END IF;
END $$;

-- 2. Criar tabela de drops se não existir
CREATE TABLE IF NOT EXISTS Zumbi_Drops (
    IDZumbiDrop SERIAL PRIMARY KEY,
    IDTipoZumbi INT,
    IDClasseltens INT,
    Probabilidade DECIMAL(5,2) CHECK (Probabilidade >= 0 AND Probabilidade <= 100),
    Quantidade_Min INT DEFAULT 1,
    Quantidade_Max INT DEFAULT 1,
    FOREIGN KEY (IDTipoZumbi) REFERENCES TipoZumbi(IDTipoZumbi),
    FOREIGN KEY (IDClasseltens) REFERENCES Classeltens(IDClasseltens)
);

-- 3. Limpar drops existentes para evitar duplicatas
DELETE FROM Zumbi_Drops;

-- 4. Criar trigger de drops
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

-- 5. Remover trigger se já existir e criar novo
DROP TRIGGER IF EXISTS trigger_gerar_drop_zumbi ON Instancia_Zumbi;

CREATE TRIGGER trigger_gerar_drop_zumbi
    AFTER UPDATE ON Instancia_Zumbi
    FOR EACH ROW
    EXECUTE FUNCTION gerar_drop_zumbi();

-- 6. Adicionar drops dos zumbis
INSERT INTO Zumbi_Drops (IDTipoZumbi, IDClasseltens, Probabilidade, Quantidade_Min, Quantidade_Max) VALUES
-- Zumbi Comum (drops básicos)
(1, 3, 30.0, 1, 1),    -- 30% chance de curativo
(1, 8, 20.0, 1, 2),    -- 20% chance de bandagem (1-2)
(1, 2, 10.0, 1, 1),    -- 10% chance de faca

-- Zumbi Brutamonte (drops melhores)
(2, 4, 25.0, 1, 1),    -- 25% chance de kit médico
(2, 7, 15.0, 1, 1),    -- 15% chance de machado
(2, 6, 8.0, 1, 1),     -- 8% chance de pistola (raro!)

-- Zumbi Infeccioso (drops de cura)
(3, 3, 40.0, 1, 2),    -- 40% chance de curativo (1-2)
(3, 8, 30.0, 1, 3),    -- 30% chance de bandagem (1-3)
(3, 4, 20.0, 1, 1),    -- 20% chance de kit médico
(3, 5, 5.0, 1, 1);     -- 5% chance de poção de cura (muito raro!)

-- 7. Verificar se tudo foi criado
SELECT 'Sistema de Drops Configurado com Sucesso!' as Status;
SELECT 'Triggers criados:' as Status;
SELECT trigger_name, event_object_table 
FROM information_schema.triggers 
WHERE trigger_name = 'trigger_gerar_drop_zumbi';

SELECT 'Drops configurados:' as Status;
SELECT 
    tz.Nome as TipoZumbi,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
        ELSE 'Desconhecido'
    END as Item,
    zd.Probabilidade,
    zd.Quantidade_Min,
    zd.Quantidade_Max
FROM Zumbi_Drops zd
JOIN TipoZumbi tz ON tz.IDTipoZumbi = zd.IDTipoZumbi
JOIN Classeltens c ON c.IDClasseltens = zd.IDClasseltens
LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
ORDER BY tz.Nome, zd.Probabilidade DESC; 