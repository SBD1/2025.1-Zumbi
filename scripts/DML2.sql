-- 🌐 CONTA (primeiro, pois é referenciada por Personagem)
INSERT INTO Conta (Email, Senha, Status) VALUES
('sobrevivente@email.com', 'senhaApocalipse', 1);

-- 🌍 LOCAIS (antes de Personagem e outros que referenciam Local)
INSERT INTO Local (IDLocal, Nome, Precisa_Chave, Norte, Sul, Leste, Oeste) VALUES
(1, 'Rua Principal', FALSE, 2, NULL, 3, NULL),
(2, 'Hospital', TRUE, NULL, 1, 4, NULL),
(3, 'Farmácia', TRUE, NULL, NULL, 5, 1),
(4, 'Escola Abandonada', FALSE, NULL, NULL, NULL, 2),
(5, 'Posto de Gasolina', TRUE, NULL, NULL, 6, 3),
(6, 'Loja de Armas', TRUE, NULL, NULL, NULL, 5);

-- 👤 PERSONAGEM (depois de Conta e Local existirem)
INSERT INTO Personagem (Nome, VidaAtual, IDConta, IDLocal) VALUES
('Elena', 100, 1, 1);

-- 🔥 TIPO ZUMBI (antes de Instancia_Zumbi)
INSERT INTO TipoZumbi (IDTipoZumbi, Nome) VALUES
(1, 'Infeccioso'),
(2, 'Brutamonte'),
(3, 'Comum');

-- ⚔️ CLASSIFICAÇÃO DE ITENS (antes dos itens específicos)
INSERT INTO Classeltens (IDClasseltens, tipos_itens) VALUES
(1, 'ArmaDeFogo'),
(2, 'ArmaBranca'),
(3, 'Medicamentos'),
(4, 'Chave'),
(5, 'ArmaDeFogo'),
(6, 'ArmaBranca'),
(7, 'Medicamentos'),
(8, 'Chave'),
(9, 'ArmaDeFogo'),
(10, 'ArmaDeFogo'),
(11, 'ArmaBranca'),
(12, 'ArmaBranca'),
(13, 'Medicamentos'),
(14, 'Medicamentos'),
(15, 'Chave'),
(16, 'Chave');

-- 🔫 ARMAS DE FOGO
INSERT INTO ArmaDeFogo (IDClasseltens, Nome, Dano_maximo) VALUES
(1, 'Pistola 9mm', 30),
(5, 'Espingarda de Cano Curto', 45),
(9, 'Revolver .38', 35),
(10, 'Rifle de Caça', 50);

-- 🪓 ARMAS BRANCAS
INSERT INTO ArmaBranca (IDClasseltens, Nome, Dano_maximo) VALUES
(2, 'Faca', 15),
(6, 'Chave Inglesa', 20),
(11, 'Machado', 25),
(12, 'Taco de Beisebol', 18);

-- 💊 MEDICAMENTOS
INSERT INTO Medicamentos (IDClasseltens, Nome, Ganho_vida) VALUES
(3, 'Curativo', 20),
(7, 'Antibiótico Forte', 35),
(13, 'Kit Médico', 50),
(14, 'Analgésico', 15);

-- 🔐 CHAVES
INSERT INTO Chaves (IDClasseltens, Nome_Chave) VALUES
(4, 'Chave do Hospital'),
(8, 'Chave da Loja de Armas'),
(15, 'Chave da Farmácia'),
(16, 'Chave do Posto');

-- 🧟‍♂️ INSTANCIA ZUMBI (depois de TipoZumbi e Local)
INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal, IDTipoZumbi) VALUES
(1, 60, 2, 1),
(2, 80, 3, 3),
(3, 90, 5, 2),
(4, 70, 6, 3);

-- 📍 LOCAL X ZUMBI (depois de Local e Instancia_Zumbi)
INSERT INTO Local_Instancia_Zumbi (IDLocal, IDInstanciaZumbi) VALUES
(2, 1), (3, 2), (5, 3), (6, 4);

-- 🗝️ LOCAL X CHAVE
INSERT INTO Local_Chaves (IDLocal, IDChave) VALUES
(2, 4), -- Hospital
(6, 8), -- Loja de Armas
(3, 15), -- Farmácia
(5, 16); -- Posto

-- 🎒 ITENS NO MAPA (depois de Classeltens e Local)
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDLocal, Municao) VALUES
-- Itens originais
(1, 1, 'Local', 1, 12), -- Pistola 9mm
(2, 2, 'Local', 4, NULL), -- Faca
(3, 3, 'Local', 3, NULL), -- Curativo
(4, 4, 'Local', 1, NULL), -- Chave do Hospital
(5, 5, 'Local', 5, 6), -- Espingarda
(6, 6, 'Local', 5, NULL), -- Chave inglesa
(7, 7, 'Local', 2, NULL), -- Antibiótico
(8, 8, 'Local', 4, NULL), -- Chave da Loja de Armas
-- Novos itens
(10, 11, 'Local', 1, NULL), -- Machado
(11, 14, 'Local', 1, NULL), -- Analgésico
(12, 13, 'Local', 2, NULL), -- Kit Médico
(13, 12, 'Local', 2, NULL), -- Taco de Beisebol
(14, 15, 'Local', 3, NULL), -- Chave da Farmácia
(15, 7, 'Local', 3, NULL), -- Antibiótico Forte
(16, 10, 'Local', 4, 8), -- Rifle de Caça
(17, 14, 'Local', 4, NULL), -- Analgésico
(18, 16, 'Local', 5, NULL), -- Chave do Posto
(19, 9, 'Local', 5, 6), -- Revolver .38
(20, 5, 'Local', 6, 12), -- Espingarda
(21, 1, 'Local', 6, 15); -- Pistola 9mm

-- 🗺️ INVENTÁRIO INICIAL (depois de Classeltens e Personagem)
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDPersonagem, Municao) VALUES
(9, 3, 'Personagem', 1, NULL); -- Curativo inicial

-- 🎯 MISSÕES
INSERT INTO Missao (IDMissao, Nome, Descricao, Recompensa, Status, Tipo, Parametros, TipoRecompensa) VALUES
(1, 'Chave da Sobrevivência', 'Recupere a chave do hospital para acessar medicamentos.', 'Acesso ao Hospital', 'Ativa', 'COLETA', '{"tipo_item": "Chave", "quantidade": 1}', 'CHAVE'),
(2, 'Ajuda Urgente', 'Derrote o zumbi no hospital e colete um antibiótico.', 'Ganho de vida e confiança', 'Ativa', 'ELIMINAR_ZUMBIS', '{"quantidade": 1}', 'MEDICAMENTO'),
(3, 'Exploração Tática', 'Explore a escola abandonada e recupere uma arma branca.', 'Chave inglesa encontrada', 'Ativa', 'ALCANCAR_LOCAL', '{"id_local": 4}', 'ARMA'),
(4, 'Combustível Vital', 'Derrote o brutamonte no posto e recupere suprimentos.', 'Espingarda e gasolina', 'Ativa', 'ELIMINAR_ZUMBIS', '{"quantidade": 1}', 'ARMA'),
(5, 'Última Defesa', 'Obtenha a chave da loja de armas e prepare-se para o confronto final.', 'Acesso à loja de armas', 'Ativa', 'COLETA', '{"tipo_item": "Chave", "quantidade": 1}', 'CHAVE');

-- 🤝 PERSONAGEM x MISSÕES (depois de Personagem e Missao)
INSERT INTO Personagem_Missao (IDPersonagem, IDMissao, Status) VALUES
(1, 1, 'ATIVA'),
(1, 2, 'ATIVA'),
(1, 3, 'ATIVA'),
(1, 4, 'ATIVA'),
(1, 5, 'ATIVA');

-- 💬 DIÁLOGOS
INSERT INTO Dialogos (IDDialogo, Titulo) VALUES
(1, 'Início da Jornada'),
(2, 'Acesso ao Hospital'),
(3, 'Ajuda Médica'),
(4, 'Exploração na Escola'),
(5, 'Missão no Posto'),
(6, 'Preparação Final');

-- 📜 MENSAGENS DE DIÁLOGO
INSERT INTO MensagensDialogos (IDMensagemDialogo, Texto, Ordem_de_Exibicao, IDDialogo) VALUES
(1, 'Elena acorda desorientada na Rua Principal. Tudo está destruído. Ela precisa agir.', 1, 1),
(2, 'Você encontrou uma chave! Talvez abra o hospital mais ao norte.', 1, 2),
(3, 'Zumbis no hospital... mas há um armário trancado com medicamentos.', 1, 3),
(4, 'A escola está vazia... exceto por uma faca no laboratório de química.', 1, 4),
(5, 'Um brutamonte protege os tanques no posto. Acabando com ele, poderá abastecer.', 1, 5),
(6, 'Tudo depende da loja de armas. Uma última chave... uma última chance.', 1, 6);

-- 🎭 DIÁLOGOS x MISSÕES
INSERT INTO Dialogos_Missao (IDDialogo, IDMissao) VALUES
(1, 1), (2, 1), (3, 2), (4, 3), (5, 4), (6, 5);

-- 🧍 PERSONAGEM x DIÁLOGOS
INSERT INTO Personagem_Dialogos (IDPersonagem, IDDialogo) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6);

-- 🧟 TIPOS ESPECÍFICOS DE ZUMBI
INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES
(3, 10);

INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES
(1, 5, 15);

INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES
(2, TRUE, 20);