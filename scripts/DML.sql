-- Conta
INSERT INTO Conta (IDConta, Email, Senha, Status) VALUES
(1, 'sobrevivente1@email.com', 'senha123', 1),
(2, 'lider_resistencia@email.com', 'resistencia456', 1),
(3, 'medico_solitario@email.com', 'curaZumbi!', 1),
(4, 'explorador_oculto@email.com', 'segredo123', 1),
(5, 'medica_campanha@email.com', 'curaZumbi789', 1),
(6, 'ex_militar@email.com', 'estrategia321', 1),
(7, 'caçador_zumbis@email.com', 'headshot123', 1),
(8, 'engenheira_survival@email.com', 'construcao456', 1),
(9, 'farmacêutica@email.com', 'remedio789', 1),
(10, 'lider_comunidade@email.com', 'uniao123', 1);

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

-- Classeltens
INSERT INTO Classeltens (IDClasseltens, Nome) VALUES
(1, 'Arma de fogo'),
(2, 'Arma Branca'),  
(3, 'Medicamentos'),
(4, 'Chave'); 

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
INSERT INTO TipoZumbi (IDTipoZumbi, DanoBase, nome) VALUES
(1, 10, 'Infeccioso'),
(2, 15, 'Brutamonte'),
(3, 20, 'Comum');

-- Zumbi_Comum
INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES
(3, 10);


-- Zumbi_Infeccioso
INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES
(1, 5, 15);


-- Zumbi_Brutamonte
INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES
(2, TRUE, 20);


-- Chaves
INSERT INTO Chaves (IDChave, Nome_Chave) VALUES
(1, 'Chave do Hospital'),
(2, 'Chave da Delegacia'),
(3, 'Chave da Base Militar'),
(4, 'Chave da Farmácia'),
(5, 'Chave da Estação de Rádio'),
(6, 'Chave do Depósito de Construção'),
(7, 'Chave do Centro Comercial');

-- ArmaDeFogo
INSERT INTO ArmaDeFogo (IDArmaDeFogo,Nome, Munição, Dano_maximo) VALUES
(1,'Pistola 9mm' ,15, 30),
(2, 'Fuzil',30, 45),
(3, 'Bazuca', 10, 25);

-- ArmaBranca
INSERT INTO ArmaBranca (IDArmaBranca,Nome,  Dano_maximo) VALUES
(1,'Faca', 15),
(2,'Machado', 20),
(3,'Adaga' ,10);

-- Medicamentos
INSERT INTO Medicamentos (IDMedicamentos, Ganho_vida) VALUES
(1, 20),
(2, 30),
(3, 15);


-- Personagem
INSERT INTO Personagem (IDPersonagem, Nome, VidaAtual, IDConta, IDLocal) VALUES
(1, 'Ricardo', 100, 1, 1),
(2, 'Sofia', 120, 2, 2),
(3, 'Dr. Helena', 90, 3, 2),
(4, 'Marco', 110, 4, 3),
(5, 'Laura', 110, 5, 5),
(6, 'Carlos', 130, 6, 4),
(7, 'Lucas', 140, 7, 7),
(8, 'Ana', 100, 8, 8),
(9, 'Dra. Maria', 95, 9, 6),
(10, 'Pedro', 125, 10, 9);


-- Instancias_Itens
-- Instancias_Itens (adaptado para usar IDPersonagem ao invés de IDInventario)
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, IDPersonagem) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 1, 2),
(5, 3, 2),
(6, 2, 3),
(7, 3, 4),
(8, 1, 4),
(9, 1, 6),
(10, 4, 7),
(11, 3, 7),
(12, 2, 8),
(13, 1, 9),
(14, 3, 10),
(15, 1, 10);


-- Instancia_Zumbi
INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal, IDTipoZumbi) VALUES
(1, 30, 1, 1),  
(2, 50, 2, 2),
(3, 80, 2, 3),
(4, 60, 3, 1),
(5, 90, 3, 3),
(6, 20, 4, 1),
(7, 40, 5, 1),
(8, 70, 6, 2),
(9, 100, 7, 3),
(10, 45, 8, 1);


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

-- Local_Instancias_Itens
INSERT INTO Local_Instancias_Itens (IDLocal, IDInstanciaItem) VALUES
(1, 1),
(1, 2),
(3, 7),
(3, 8),
(5, 14),
(5, 15),
(6, 13),
(7, 11),
(8, 13),
(9, 12);

-- Local_Instancia_Zumbi
INSERT INTO Local_Instancia_Zumbi (IDLocal, IDInstanciaZumbi) VALUES
(1, 1),
(2, 2),
(2, 3),
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
(2, 1),
(3, 2),
(4, 3),
(6, 4),
(7, 5),
(8, 6),
(10, 7);

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
