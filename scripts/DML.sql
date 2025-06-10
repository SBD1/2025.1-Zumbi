-- Inserindo dados na tabela Conta
INSERT INTO Conta (IDConta, Email, Senha, Status) VALUES
(1, 'sobrevivente1@email.com', 'senha123', 1),
(2, 'lider_resistencia@email.com', 'resistencia456', 1);

-- Inserindo dados na tabela Personagem
INSERT INTO Personagem (IDPersonagem, Nome, VidaAtual, IDConta) VALUES
(1, 'Ricardo', 100, 1),
(2, 'Sofia', 120, 2);

-- Inserindo dados na tabela Inventario
INSERT INTO Inventario (IDInventario, CapacidadeMaxima, IDPersonagem) VALUES
(1, 20, 1),
(2, 25, 2);

-- Inserindo dados na tabela Classeltens
INSERT INTO Classeltens (IDClasseltens, Nome) VALUES
(1, 'Faca enferrujada'),
(2, 'Kit de primeiros socorros'),
(3, 'Pistola 9mm'),
(4, 'Munição 9mm');

-- Inserindo dados na tabela Instancias_Itens
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, IDInventario) VALUES
(1, 1, 1), -- Ricardo possui uma faca enferrujada
(2, 2, 1), -- Ricardo possui um kit de primeiros socorros
(3, 3, 2), -- Sofia possui uma pistola 9mm
(4, 4, 2),  -- Sofia possui munição 9mm
(5, 4, 2);  -- Sofia possui mais munição 9mm

-- Inserindo dados na tabela Local
INSERT INTO Local (IDLocal, Nome, Precisa_Chave) VALUES
(1, 'Rua Principal', FALSE),
(2, 'Hospital Abandonado', TRUE),
(3, 'Delegacia', TRUE);

-- Inserindo dados na tabela Missao
INSERT INTO Missao (IDMissao, Nome, Descricao, Recompensa, Status) VALUES
(1, 'Encontre suprimentos', 'Encontre comida e água na Rua Principal.', 'Comida e água', 'Ativa'),
(2, 'Limpe o hospital', 'Elimine os zumbis no Hospital Abandonado.', 'Kit médico avançado', 'Pendente'),
(3, 'Recupere a chave', 'Recupere a chave da delegacia.', 'Acesso a armas', 'Pendente');

-- Inserindo dados na tabela Dialogos
INSERT INTO Dialogos (IDDialogo, Titulo) VALUES
(1, 'Primeiro encontro com Ricardo'),
(2, 'Instruções da missão: Encontre suprimentos');

-- Inserindo dados na tabela MensagensDialogos
INSERT INTO MensagensDialogos (IDMensagemDialogo, Texto, Ordem_de_Exibicao, IDDialogo) VALUES
(1, 'Olá! Sou Ricardo. Preciso de ajuda para sobreviver.', 1, 1),
(2, 'Sofia: Precisamos de suprimentos. Vá para a Rua Principal e encontre comida e água.', 1, 2);

-- Inserindo dados na tabela Instancia_Zumbi
INSERT INTO Instancia_Zumbi (IDInstanciaZumbi, VidaAtual, IDLocal) VALUES
(1, 30, 1), -- Zumbi comum na Rua Principal
(2, 50, 2), -- Zumbi infeccioso no Hospital Abandonado
(3, 80, 2); -- Zumbi brutamonte no Hospital Abandonado

-- Inserindo dados na tabela TipoZumbi
INSERT INTO TipoZumbi (IDTipoZumbi, DanoBase) VALUES
(1, 10), -- Comum
(2, 15), -- Infeccioso
(3, 20); -- Brutamonte

-- Inserindo dados na tabela Zumbi_Comum
INSERT INTO Zumbi_Comum (IDZumbiComum, DanoBase) VALUES
(1, 10);

-- Inserindo dados na tabela Zumbi_Infeccioso
INSERT INTO Zumbi_Infeccioso (IDZumbiInfeccioso, Taxa_Infeccao, DanoBase) VALUES
(2, 5, 15);

-- Inserindo dados na tabela Zumbi_Brutamonte
INSERT INTO Zumbi_Brutamonte (IDZumbiBrutamonte, Resistencia_a_bala, DanoBase) VALUES
(3, TRUE, 20);

-- Inserindo dados na tabela Chaves
INSERT INTO Chaves (IDChave, Nome_Chave) VALUES
(1, 'Chave do Hospital'),
(2, 'Chave da Delegacia');

-- Inserindo dados na tabela ArmaDeFogo
INSERT INTO ArmaDeFogo (IDArmaDeFogo, Munição, Dano_maximo) VALUES
(1, 15, 30);

-- Inserindo dados na tabela ArmaBranca
INSERT INTO ArmaBranca (IDArmaBranca, Dano_maximo) VALUES
(1, 15);

-- Inserindo dados na tabela Medicamentos
INSERT INTO Medicamentos (IDMedicamentos, Ganho_vida) VALUES
(1, 20);

-- Inserindo dados nas tabelas de relacionamento N:N
INSERT INTO Personagem_Missao (IDPersonagem, IDMissao) VALUES
(1, 1), -- Ricardo tem a missão de encontrar suprimentos
(2, 2), -- Sofia tem a missão de limpar o hospital
(2, 3); -- Sofia tem a missão de recuperar a chave

INSERT INTO Local_Instancias_Itens (IDLocal, IDInstanciaItem) VALUES
(1, 1), -- Faca enferrujada pode ser encontrada na Rua Principal
(1, 2); -- Kit de primeiros socorros pode ser encontrado na Rua Principal

INSERT INTO Local_Instancia_Zumbi (IDLocal, IDInstanciaZumbi) VALUES
(1, 1), -- Zumbi comum na Rua Principal
(2, 2), -- Zumbi infeccioso no Hospital Abandonado
(2, 3); -- Zumbi brutamonte no Hospital Abandonado

INSERT INTO Dialogos_Missao (IDDialogo, IDMissao) VALUES
(2, 1); -- Diálogo de Sofia está relacionado à missão de encontrar suprimentos

-- Inserindo dados na tabela Local_Chaves
INSERT INTO Local_Chaves (IDLocal, IDChave) VALUES
(2, 1), -- Hospital Abandonado precisa da Chave do Hospital
(3, 2); -- Delegacia precisa da Chave da Delegacia