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
(10, 'Chave');

INSERT INTO ArmaBranca (IDClasseltens, Nome, Dano_maximo) VALUES
(2, 'Faca', 15);

INSERT INTO Medicamentos (IDClasseltens, Nome, Ganho_vida) VALUES
(3, 'Curativo', 20);

INSERT INTO Chaves (IDClasseltens, Nome_Chave) VALUES
(10, 'Chave do 2º Andar');

-- 🎒 ITENS NO MAPA
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDLocal, IDPersonagem, Municao) VALUES
(1, 2, 'Local', 1, NULL, NULL),   -- Faca na recepção
(2, 3, 'Local', 5, NULL, NULL),   -- Curativo na sala de exames
(3, 10, 'Local', 3, NULL, NULL);  -- Chave do 2º andar na farmácia

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
(3, 60, 3, 3);   -- Infeccioso na farmácia

-- 📜 MISSÕES
INSERT INTO Missao (IDMissao, Nome, Descricao, Recompensa, Status, Tipo, Parametros, TipoRecompensa) VALUES
(1, 'Pegue a chave do 2º andar', 'Encontre a chave na farmácia para acessar o segundo andar.', 'Acesso ao 2º andar', 'Ativa', 'COLETA', '{"tipo_item": "Chave", "quantidade": 1}', 'CHAVE'),
(2, 'Derrote o brutamonte', 'Derrote o brutamonte no corredor sul para garantir passagem segura.', 'Confiança e segurança', 'Ativa', 'ELIMINAR_ZUMBIS', '{"quantidade": 1}', NULL),
(3, 'Salve sua filha', 'Chegue ao quarto da filha no segundo andar.', 'Vitória', 'Ativa', 'ALCANCAR_LOCAL', '{"id_local": 13}', NULL);