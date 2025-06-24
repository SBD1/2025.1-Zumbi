-- Conta
INSERT INTO Conta (Email, Senha, Status) VALUES
('sobrevivente1@email.com', 'senha123', 1),
('lider_resistencia@email.com', 'resistencia456', 1),
('medico_solitario@email.com', 'curaZumbi!', 1),
('explorador_oculto@email.com', 'segredo123', 1),
('medica_campanha@email.com', 'curaZumbi789', 1),
('ex_militar@email.com', 'estrategia321', 1),
('caçador_zumbis@email.com', 'headshot123', 1),
('engenheira_survival@email.com', 'construcao456', 1),
('farmacêutica@email.com', 'remedio789', 1),
('lider_comunidade@email.com', 'uniao123', 1);

-- Local
INSERT INTO Local (IDLocal, Nome, Precisa_Chave, Norte, Sul, Leste, Oeste) VALUES
(1, 'Rua Principal', FALSE, 2, 5, 3, NULL),
(2, 'Hospital Abandonado', TRUE, NULL, 1, 4, NULL),
(3, 'Delegacia', TRUE, 4, 6, NULL, 1),
(4, 'Base Militar', TRUE, NULL, 3, 7, 2),
(5, 'Supermercado', FALSE, 1, 9, 6, NULL),
(6, 'Farmácia', TRUE, 3, 10, NULL, 5),
(7, 'Estação de Rádio', TRUE, NULL, 8, NULL, 4),
(8, 'Depósito de Construção', TRUE, 7, NULL, 9, NULL),
(9, 'Escola', FALSE, 5, NULL, 10, 8),
(10, 'Centro Comercial', TRUE, 6, NULL, NULL, 9);



-- Missao
INSERT INTO Missao (IDMissao, Nome, Descricao, Recompensa, Status) VALUES
(1, 'Encontre suprimentos', 'Encontre comida e água na Rua Principal.', 'Comida e água', 'Ativa'),
(2, 'Limpe o hospital', 'Elimine os zumbis no Hospital Abandonado.', 'Kit médico avançado', 'Pendente'),
(3, 'Recupere a chave', 'Recupere a chave da delegacia.', 'Acesso a armas', 'Pendente'),
(4, 'Cure o infectado', 'Ajude o médico a preparar um antídoto.', 'Antídoto', 'Pendente'),
(5, 'Explore a delegacia', 'Descubra o que restou na delegacia abandonada.', 'Arma rara', 'Pendente'),
(6, 'Salvar civis', 'Resgate civis presos na delegacia.', 'Pontuação de moral', 'Pendente'),
(7, 'Desativar alarme', 'Desative o alarme da base militar para evitar atenção dos zumbis.', 'Acesso ao bunker', 'Pendente'),
(8, 'Estabelecer comunicação', 'Recupere equipamentos de rádio na Estação de Rádio.', 'Rádio comunicador', 'Pendente'),
(9, 'Construir barricadas', 'Ajude a construir defesas usando materiais do depósito.', 'Ferramentas de reparo', 'Pendente'),
(10, 'Buscar medicamentos', 'Recupere antibióticos na farmácia.', 'Kit médico completo', 'Pendente');

-- Dialogos
INSERT INTO Dialogos (IDDialogo, Titulo) VALUES
(1, 'Primeiro encontro com Ricardo'),
(2, 'Instruções da missão: Encontre suprimentos'),
(3, 'Pedido de ajuda do médico'),
(4, 'Descobertas na delegacia'),
(5, 'Laura pede ajuda para tratar feridos'),
(6, 'Carlos entrega plano para desativar alarme'),
(7, 'Lucas oferece treinamento de tiro'),
(8, 'Ana propõe construção de defesas'),
(9, 'Dra. Maria pede ajuda com pesquisa'),
(10, 'Pedro convoca reunião da comunidade');

-- TipoZumbi
INSERT INTO TipoZumbi (IDTipoZumbi, DanoBase, Nome) VALUES
(1, 15, 'Infeccioso'),
(2, 20, 'Brutamonte'),
(3, 10, 'Comum');

-- Zumbi_Comum
INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES
(3, 10);

-- Zumbi_Infeccioso
INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES
(1, 5, 15);

-- Zumbi_Brutamonte
INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES
(2, TRUE, 20);

-- Classeltens
INSERT INTO Classeltens (IDClasseltens, tipos_itens) VALUES
(1, 'ArmaDeFogo'),
(2, 'ArmaBranca'),  
(3, 'Medicamentos'),
(4, 'Chave'),
(5, 'ArmaDeFogo'),
(6,'ArmaDeFogo'), 
(7, 'ArmaBranca'), 
(8, 'ArmaBranca'), 
(9, 'Medicamentos');

-- Chaves (como subclasse de Classeltens)
INSERT INTO Chaves (IDClasseltens, Nome_Chave) VALUES
(4, 'Chave do Hospital');

-- ArmaDeFogo (como subclasse de Classeltens)
INSERT INTO ArmaDeFogo (IDClasseltens, Nome, Munição, Dano_maximo) VALUES
(1, 'Pistola 9mm', 15, 30),
(5, 'Escopeta', 5, 50),
(6, 'Rifle de Precisão', 10, 80);

-- ArmaBranca (como subclasse de Classeltens)
INSERT INTO ArmaBranca (IDClasseltens, Nome, Dano_maximo) VALUES
(2, 'Faca', 15),
(7, 'Machado', 25),
(8, 'Taco de Beisebol', 20);

-- Medicamentos (como subclasse de Classeltens)
INSERT INTO Medicamentos (IDClasseltens, Nome, Ganho_vida) VALUES
(3, 'Curativo', 20),
(9, 'Kit de Primeiros Socorros', 50);

-- Personagem
INSERT INTO Personagem (Nome, VidaAtual, IDConta, IDLocal) VALUES
('Ricardo', 100, 1, 1),
('Sofia', 120, 2, 2),
('Dr. Helena', 90, 3, 2),
('Marco', 110, 4, 3),
('Laura', 110, 5, 5),
('Carlos', 130, 6, 4),
('Lucas', 140, 7, 7),
('Ana', 100, 8, 8),
('Dra. Maria', 95, 9, 6),
('Pedro', 125, 10, 9);

-- Itens que estão com personagens (Localizacao = 'Personagem', IDPersonagem preenchido)
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDPersonagem) VALUES
(1, 1, 'Personagem', 1),  -- Pistola 9mm para Ricardo
(2, 2, 'Personagem', 1),  -- Faca para Ricardo
(3, 3, 'Personagem', 2),  -- Curativo para Sofia
(4, 1, 'Personagem', 2),  -- Pistola 9mm para Sofia
(5, 3, 'Personagem', 3),  -- Curativo para Dr. Helena
(6, 2, 'Personagem', 4),  -- Faca para Marco
(7, 3, 'Personagem', 5),  -- Curativo para Laura
(8, 5, 'Personagem', 6),  -- Escopeta para Carlos
(9, 4, 'Personagem', 7),  -- Chave para Lucas
(10, 3, 'Personagem', 8), -- Curativo para Ana
(11, 7, 'Personagem', 9), -- Machado para Dra. Maria
(12, 6, 'Personagem', 10), -- Rifle de Precisão para Pedro
(13, 8, 'Personagem', 3),  -- Taco de Beisebol para Dr. Helena
(14, 9, 'Personagem', 5);  -- Kit de Primeiros Socorros para Laura


-- Itens que estão em Locais (no chão)
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDLocal) VALUES
(15, 1, 'Local', 1),  -- Pistola 9mm na Rua Principal
(16, 4, 'Local', 2),  -- Chave no Hospital Abandonado
(17, 7, 'Local', 3),  -- Machado na Delegacia
(18, 9, 'Local', 6),  -- Kit de Primeiros Socorros na Farmácia
(19, 5, 'Local', 4),  -- Escopeta na Base Militar
(20, 8, 'Local', 8),  -- Taco de Beisebol no Depósito de Construção
(21, 2, 'Local', 5),  -- Faca no Supermercado
(22, 3, 'Local', 9);  -- Curativo na Escola


-- Instancia_Zumbi
INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal, IDTipoZumbi) VALUES
(1, 30, 1, 1),  -- Infeccioso na Rua Principal
(2, 50, 2, 2),  -- Brutamonte no Hospital
(3, 80, 2, 3),  -- Comum no Hospital
(4, 60, 3, 1),  -- Infeccioso na Delegacia
(5, 90, 3, 3),  -- Comum na Delegacia
(6, 20, 4, 1),  -- Infeccioso na Base Militar
(7, 40, 5, 1),  -- Infeccioso no Supermercado
(8, 70, 6, 2),  -- Brutamonte na Farmácia
(9, 100, 7, 3), -- Comum na Estação de Rádio
(10, 45, 8, 1); -- Infeccioso no Depósito

-- Personagem_Missao
INSERT INTO Personagem_Missao (IDPersonagem, IDMissao) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10);



-- Local_Instancia_Zumbi
INSERT INTO Local_Instancia_Zumbi (IDLocal, IDInstanciaZumbi) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10);

-- Dialogos_Missao
INSERT INTO Dialogos_Missao (IDDialogo, IDMissao) VALUES
(2, 1),
(3, 4),
(6, 7),
(7, 8),
(8, 9),
(9, 10);

-- Local_Chaves
INSERT INTO Local_Chaves (IDLocal, IDChave) VALUES
(2, 4);  -- Chave do Hospital no Hospital

-- Personagem_Dialogos
INSERT INTO Personagem_Dialogos (IDPersonagem, IDDialogo) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- MensagensDialogos
INSERT INTO MensagensDialogos (IDMensagemDialogo, Texto, Ordem_de_Exibicao, IDDialogo) VALUES
(1, 'Olá! Sou Ricardo. Preciso de ajuda para sobreviver.', 1, 1),
(2, 'Sofia: Precisamos de suprimentos. Vá para a Rua Principal e encontre comida e água.', 1, 2),
(3, 'Dr. Helena: Estou tentando sintetizar uma cura, mas preciso de ingredientes específicos.', 1, 3),
(4, 'Marco: Encontrei documentos importantes na delegacia. Isso pode mudar tudo.', 1, 4),
(5, 'Laura: Os civis precisam de primeiros socorros. Ajude-me a levá-los para um local seguro.', 1, 5),
(6, 'Carlos: Se não desligarmos aquele alarme, todos os zumbis da cidade virão até aqui.', 1, 6),
(7, 'Lucas: Posso te ensinar a atirar com precisão. Isso pode salvar sua vida.', 1, 7),
(8, 'Ana: Precisamos construir barricadas. O depósito tem os materiais que precisamos.', 1, 8),
(9, 'Dra. Maria: Estou perto de uma descoberta importante. Preciso de mais amostras.', 1, 9),
(10, 'Pedro: A comunidade precisa se unir. Vamos nos reunir para discutir estratégias.', 1, 10);