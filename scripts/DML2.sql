-- 🌍 LOCAIS DO HOSPITAL
INSERT INTO Local VALUES (1,  'Recepção', 'Recepção do hospital', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (2,  'Sala de Espera', 'Sala de espera dos pacientes', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (3,  'Farmácia', 'Farmácia do hospital', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (4,  'Consultório Médico', 'Consultório para atendimento', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (5,  'Sala de Exames', 'Sala de exames médicos', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (6,  'Corredor Leste', 'Corredor do lado leste', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (7,  'Almoxarifado', 'Depósito de materiais', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (8,  'Corredor Sul', 'Corredor do lado sul', false, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (12, 'Escada 2º Andar', 'Escada para o segundo andar', true, NULL, NULL, NULL, NULL);
INSERT INTO Local VALUES (13, 'Quarto da Filha', 'Quarto onde está a filha', false, NULL, NULL, NULL, NULL);

UPDATE Local SET Norte=2, Sul=8, Leste=6, Oeste=5 WHERE IDLocal=1;
UPDATE Local SET Sul=1, Leste=3, Oeste=4 WHERE IDLocal=2;
UPDATE Local SET Sul=6, Oeste=2 WHERE IDLocal=3;
UPDATE Local SET Sul=5, Leste=2 WHERE IDLocal=4;
UPDATE Local SET Norte=4, Sul=7, Leste=1 WHERE IDLocal=5;
UPDATE Local SET Norte=3, Oeste=1 WHERE IDLocal=6;
UPDATE Local SET Norte=5 WHERE IDLocal=7;
UPDATE Local SET Norte=1, Sul=12 WHERE IDLocal=8;
UPDATE Local SET Norte=8, Sul=13 WHERE IDLocal=12;
UPDATE Local SET Norte=12 WHERE IDLocal=13;

-- ⚔️ ITENS E CHAVES
INSERT INTO Classeltens (IDClasseltens, tipos_itens) VALUES
(2, 'ArmaBranca'),
(3, 'Medicamentos'),
(4, 'Medicamentos'),
(5, 'Medicamentos'),
(6, 'ArmaDeFogo'),
(7, 'ArmaBranca'),
(8, 'Medicamentos'),
(10, 'Chave');

INSERT INTO ArmaBranca (IDClasseltens, Nome, Dano_maximo) VALUES
(2, 'Faca', 15),
(7, 'Machado', 25);

INSERT INTO ArmaDeFogo (IDClasseltens, Nome, Dano_maximo) VALUES
(6, 'Pistola', 30);

INSERT INTO Medicamentos (IDClasseltens, Nome, Ganho_vida) VALUES
(3, 'Curativo', 20),
(4, 'Kit Médico', 50),
(5, 'Poção de Cura', 100),
(8, 'Bandagem', 15);

INSERT INTO Chaves (IDClasseltens, Nome_Chave) VALUES
(10, 'Chave do 2º Andar');

-- 🎒 ITENS NO MAPA
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDLocal, IDPersonagem, Municao) VALUES
-- Recepção (Local 1)
(1, 2, 'Local', 1, NULL, NULL),   -- Faca na recepção
(8, 3, 'Local', 1, NULL, NULL),   -- Curativo na recepção

-- Sala de Espera (Local 2)
(9, 8, 'Local', 2, NULL, NULL),   -- Bandagem na sala de espera
(10, 3, 'Local', 2, NULL, NULL),  -- Curativo na sala de espera

-- Farmácia (Local 3)
(3, 10, 'Local', 3, NULL, NULL),  -- Chave do 2º andar na farmácia
(4, 4, 'Local', 3, NULL, NULL),   -- Kit Médico na farmácia
(11, 8, 'Local', 3, NULL, NULL),  -- Bandagem na farmácia
(12, 5, 'Local', 3, NULL, NULL),  -- Poção de Cura na farmácia (rara!)

-- Consultório Médico (Local 4)
(6, 3, 'Local', 4, NULL, NULL),   -- Curativo no consultório médico
(13, 4, 'Local', 4, NULL, NULL),  -- Kit Médico no consultório médico
(14, 8, 'Local', 4, NULL, NULL),  -- Bandagem no consultório médico

-- Sala de Exames (Local 5)
(2, 3, 'Local', 5, NULL, NULL),   -- Curativo na sala de exames
(15, 7, 'Local', 5, NULL, NULL),  -- Machado na sala de exames
(16, 8, 'Local', 5, NULL, NULL),  -- Bandagem na sala de exames

-- Corredor Leste (Local 6)
(7, 4, 'Local', 6, NULL, NULL),   -- Kit Médico no corredor leste
(17, 6, 'Local', 6, NULL, NULL),  -- Pistola no corredor leste (rara!)
(18, 3, 'Local', 6, NULL, NULL),  -- Curativo no corredor leste

-- Almoxarifado (Local 7)
(5, 5, 'Local', 7, NULL, NULL),   -- Poção de Cura no almoxarifado
(19, 7, 'Local', 7, NULL, NULL),  -- Machado no almoxarifado
(20, 4, 'Local', 7, NULL, NULL),  -- Kit Médico no almoxarifado
(21, 8, 'Local', 7, NULL, NULL),  -- Bandagem no almoxarifado

-- Corredor Sul (Local 8)
(22, 3, 'Local', 8, NULL, NULL),  -- Curativo no corredor sul
(23, 8, 'Local', 8, NULL, NULL),  -- Bandagem no corredor sul

-- Escada 2º Andar (Local 12)
(24, 6, 'Local', 12, NULL, NULL), -- Pistola na escada (muito rara!)
(25, 5, 'Local', 12, NULL, NULL), -- Poção de Cura na escada (muito rara!)
(26, 4, 'Local', 12, NULL, NULL); -- Kit Médico na escada

-- 🗝️ LOCAL X CHAVE
INSERT INTO Local_Chaves (IDLocal, IDChave) VALUES (12, 10);

-- 🧟‍♂️ ZUMBIS
INSERT INTO TipoZumbi (IDTipoZumbi, Nome) VALUES
(1, 'Comum'), (2, 'Brutamonte'), (3, 'Infeccioso');

INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES (1, 10);
INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES (2, true, 20);
INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES (3, 10, 15);

INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal, IDTipoZumbi) VALUES
(1, 50, 2, 1),   -- Comum na sala de espera
(2, 80, 8, 2),   -- Brutamonte no corredor sul
(3, 60, 3, 3),   -- Infeccioso na farmácia
(4, 40, 1, 1),   -- Comum na recepção
(5, 70, 5, 2),   -- Brutamonte na sala de exames
(6, 55, 4, 3),   -- Infeccioso no consultório médico
(7, 45, 6, 1),   -- Comum no corredor leste
(8, 60, 7, 3),   -- Infeccioso no almoxarifado
(9, 50, 12, 2);  -- Brutamonte na escada do 2º andar

-- 🎁 DROPS DOS ZUMBIS
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

-- 📜 MISSÕES
INSERT INTO Missao (IDMissao, Nome, Descricao, Recompensa, Status, Tipo, Parametros, TipoRecompensa) VALUES
(1, 'Pegue a chave do 2º andar', 'Encontre a chave na farmácia para acessar o segundo andar.', 'Acesso ao 2º andar', 'Ativa', 'COLETA', '{"tipo_item": "Chave", "quantidade": 1}', 'CHAVE'),
(2, 'Derrote o brutamonte', 'Derrote o brutamonte no corredor sul para garantir passagem segura.', 'Confiança e segurança', 'Ativa', 'ELIMINAR_ZUMBIS', '{"quantidade": 1}', NULL),
(3, 'Salve sua filha', 'Chegue ao quarto da filha no segundo andar.', 'Vitória', 'Ativa', 'ALCANCAR_LOCAL', '{"id_local": 13}', NULL);