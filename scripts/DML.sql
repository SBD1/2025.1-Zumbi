-- Inserindo dados na tabela Conta
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

-- Inserindo dados na tabela Personagem
INSERT INTO Personagem (IDPersonagem, Nome, VidaAtual, IDConta) VALUES
(1, 'Ricardo', 100, 1),
(2, 'Sofia', 120, 2),
(3, 'Dr. Helena', 90, 3),
(4, 'Marco', 110, 4),
(5, 'Laura', 110, 5),
(6, 'Carlos', 130, 6),
(7, 'Lucas', 140, 7),
(8, 'Ana', 100, 8),
(9, 'Dra. Maria', 95, 9),
(10, 'Pedro', 125, 10);

-- Inserindo dados na tabela Inventario
INSERT INTO Inventario (IDInventario, CapacidadeMaxima, IDPersonagem) VALUES
(1, 20, 1),
(2, 25, 2),
(3, 30, 3),
(4, 15, 4),
(5, 30, 5),
(6, 35, 6),
(7, 40, 7),
(8, 25, 8),
(9, 35, 9),
(10, 30, 10);

-- Inserindo dados na tabela Classeltens
INSERT INTO Classeltens (IDClasseltens, Nome) VALUES
(1, 'Faca enferrujada'),
(2, 'Kit de primeiros socorros'),
(3, 'Pistola 9mm'),
(4, 'Munição 9mm'),
(5, 'Rifle de precisão'),
(6, 'Munição .308'),
(7, 'Bandagem'),
(8, 'Antibióticos'),
(9, 'Ração militar'),
(10, 'Água potável'),
(11, 'Rádio comunicador'),
(12, 'Binóculos'),
(13, 'Ferramentas de reparo'),
(14, 'Lanterna'),
(15, 'Baterias');

-- Inserindo dados na tabela Instancias_Itens
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, IDInventario) VALUES
(1, 1, 1), -- Ricardo possui uma faca enferrujada
(2, 2, 1), -- Ricardo possui um kit de primeiros socorros
(3, 3, 2), -- Sofia possui uma pistola 9mm
(4, 4, 2),  -- Sofia possui munição 9mm
(5, 4, 2),  -- Sofia possui mais munição 9mm
(6, 2, 3), -- Dr. Helena possui um kit de primeiros socorros
(7, 3, 4), -- Marco possui uma pistola 9mm
(8, 4, 4), -- Marco possui munição 9mm
(9, 1, 6), -- Carlos possui uma faca enferrujada
(10, 5, 7), -- Lucas possui um rifle de precisão
(11, 6, 7), -- Lucas possui munição .308
(12, 7, 8), -- Ana possui bandagens
(13, 8, 9), -- Dra. Maria possui antibióticos
(14, 9, 10), -- Pedro possui ração militar
(15, 10, 10); -- Pedro possui água potável

-- Inserindo dados na tabela Local
INSERT INTO Local (IDLocal, Nome, Precisa_Chave) VALUES
(1, 'Rua Principal', FALSE),
(2, 'Hospital Abandonado', TRUE),
(3, 'Delegacia', TRUE),
(4, 'Base Militar', TRUE),
(5, 'Supermercado', FALSE),
(6, 'Farmácia', TRUE),
(7, 'Estação de Rádio', TRUE),
(8, 'Depósito de Construção', TRUE),
(9, 'Escola', FALSE),
(10, 'Centro Comercial', TRUE);

-- Inserindo dados na tabela Missao
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

-- Inserindo dados na tabela Dialogos
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

-- Inserindo dados na tabela MensagensDialogos
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

-- Inserindo dados na tabela Instancia_Zumbi
INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal) VALUES
(1, 30, 1), -- Zumbi comum na Rua Principal
(2, 50, 2), -- Zumbi infeccioso no Hospital Abandonado
(3, 80, 2), -- Zumbi brutamonte no Hospital Abandonado
(4, 60, 3), -- Zumbi comum na Delegacia
(5, 90, 3), -- Zumbi brutamonte na Delegacia
(6, 20, 4), -- Zumbi comum na base militar
(7, 40, 5), -- Zumbi comum no Supermercado
(8, 70, 6), -- Zumbi infeccioso na Farmácia
(9, 100, 7), -- Zumbi brutamonte na Estação de Rádio
(10, 45, 8); -- Zumbi comum no Depósito de Construção

-- Inserindo dados na tabela TipoZumbi
INSERT INTO TipoZumbi (IDTipoZumbi, DanoBase) VALUES
(1, 10), -- Comum
(2, 15), -- Infeccioso
(3, 20); -- Brutamonte

-- Inserindo dados na tabela Zumbi_Comum
INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES
(1, 10),
(2, 12),
(3, 8);

-- Inserindo dados na tabela Zumbi_Infeccioso
INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES
(2, 5, 15),
(4, 7, 18),
(5, 4, 12);

-- Inserindo dados na tabela Zumbi_Brutamonte
INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES
(3, TRUE, 20),
(6, TRUE, 25),
(7, FALSE, 18);

-- Inserindo dados na tabela Chaves
INSERT INTO Chaves (IDChave, Nome_Chave) VALUES
(1, 'Chave do Hospital'),
(2, 'Chave da Delegacia'),
(3, 'Chave da Base Militar'),
(4, 'Chave da Farmácia'),
(5, 'Chave da Estação de Rádio'),
(6, 'Chave do Depósito de Construção'),
(7, 'Chave do Centro Comercial');

-- Inserindo dados na tabela ArmaDeFogo
INSERT INTO ArmaDeFogo (IDArmaDeFogo, Munição, Dano_maximo) VALUES
(1, 15, 30),
(2, 30, 45),
(3, 10, 25);

-- Inserindo dados na tabela ArmaBranca
INSERT INTO ArmaBranca (IDArmaBranca, Dano_maximo) VALUES
(1, 15),
(2, 20),
(3, 10);

-- Inserindo dados na tabela Medicamentos
INSERT INTO Medicamentos (IDMedicamentos, Ganho_vida) VALUES
(1, 20),
(2, 30),
(3, 15);

-- Inserindo dados nas tabelas de relacionamento N:N
INSERT INTO Personagem_Missao (IDPersonagem, IDMissao) VALUES
(1, 1), -- Ricardo tem a missão de encontrar suprimentos
(2, 2), -- Sofia tem a missão de limpar o hospital
(2, 3), -- Sofia tem a missão de recuperar a chave
(3, 4), -- Dr. Helena tem a missão de curar o infectado
(4, 5), -- Marco tem a missão de explorar a delegacia
(5, 6), -- Laura tem a missão de salvar civis
(6, 7), -- Carlos tem a missão de desativar alarme
(7, 8), -- Lucas tem a missão de estabelecer comunicação
(8, 9), -- Ana tem a missão de construir barricadas
(9, 10); -- Dra. Maria tem a missão de buscar medicamentos

INSERT INTO Local_Instancias_Itens (IDLocal, IDInstanciaItem) VALUES
(1, 1), -- Faca enferrujada pode ser encontrada na Rua Principal
(1, 2), -- Kit de primeiros socorros pode ser encontrado na Rua Principal
(3, 7), -- Pistola pode ser encontrada na Delegacia
(3, 8), -- Munição também
(5, 9), -- Ração militar no Supermercado
(5, 10), -- Água potável no Supermercado
(6, 8), -- Antibióticos na Farmácia
(7, 11), -- Rádio comunicador na Estação de Rádio
(8, 13), -- Ferramentas de reparo no Depósito
(9, 12); -- Binóculos na Escola

INSERT INTO Local_Instancia_Zumbi (IDLocal, IDInstanciaZumbi) VALUES
(1, 1), -- Zumbi comum na Rua Principal
(2, 2), -- Zumbi infeccioso no Hospital Abandonado
(2, 3), -- Zumbi brutamonte no Hospital Abandonado
(4, 6), -- Zumbi comum na base militar
(5, 7), -- Zumbi comum no Supermercado
(6, 8), -- Zumbi infeccioso na Farmácia
(7, 9), -- Zumbi brutamonte na Estação de Rádio
(8, 10); -- Zumbi comum no Depósito de Construção

INSERT INTO Dialogos_Missao (IDDialogo, IDMissao) VALUES
(2, 1), -- Diálogo de Sofia está relacionado à missão de encontrar suprimentos
(3, 4), -- Diálogo do Dr. Helena está relacionado à missão de curar o infectado
(6, 7), -- Diálogo de Carlos está relacionado à missão de desativar alarme
(7, 8), -- Diálogo de Lucas está relacionado à missão de estabelecer comunicação
(8, 9), -- Diálogo de Ana está relacionado à missão de construir barricadas
(9, 10); -- Diálogo da Dra. Maria está relacionado à missão de buscar medicamentos

-- Inserindo dados na tabela Local_Chaves
INSERT INTO Local_Chaves (IDLocal, IDChave) VALUES
(2, 1), -- Hospital Abandonado precisa da Chave do Hospital
(3, 2), -- Delegacia precisa da Chave da Delegacia
(4, 3), -- Base militar precisa da Chave da Base MIlitar
(6, 4), -- Farmácia precisa da Chave da Farmácia
(7, 5), -- Estação de Rádio precisa da Chave da Estação de Rádio
(8, 6), -- Depósito de Construção precisa da Chave do Depósito
(10, 7); -- Centro Comercial precisa da Chave do Centro Comercial