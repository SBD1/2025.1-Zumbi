/*
Script para adicionar mais itens nos locais do hospital
Execute este script se você já tem um banco de dados existente
*/

-- Adicionar novos itens nos locais
INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDLocal, IDPersonagem, Municao) VALUES
-- Recepção (Local 1) - Adicionar curativo
(8, 3, 'Local', 1, NULL, NULL),   -- Curativo na recepção

-- Sala de Espera (Local 2) - Novos itens
(9, 8, 'Local', 2, NULL, NULL),   -- Bandagem na sala de espera
(10, 3, 'Local', 2, NULL, NULL),  -- Curativo na sala de espera

-- Farmácia (Local 3) - Adicionar mais itens
(11, 8, 'Local', 3, NULL, NULL),  -- Bandagem na farmácia
(12, 5, 'Local', 3, NULL, NULL),  -- Poção de Cura na farmácia (rara!)

-- Consultório Médico (Local 4) - Adicionar mais itens
(13, 4, 'Local', 4, NULL, NULL),  -- Kit Médico no consultório médico
(14, 8, 'Local', 4, NULL, NULL),  -- Bandagem no consultório médico

-- Sala de Exames (Local 5) - Adicionar mais itens
(15, 7, 'Local', 5, NULL, NULL),  -- Machado na sala de exames
(16, 8, 'Local', 5, NULL, NULL),  -- Bandagem na sala de exames

-- Corredor Leste (Local 6) - Adicionar mais itens
(17, 6, 'Local', 6, NULL, NULL),  -- Pistola no corredor leste (rara!)
(18, 3, 'Local', 6, NULL, NULL),  -- Curativo no corredor leste

-- Almoxarifado (Local 7) - Adicionar mais itens
(19, 7, 'Local', 7, NULL, NULL),  -- Machado no almoxarifado
(20, 4, 'Local', 7, NULL, NULL),  -- Kit Médico no almoxarifado
(21, 8, 'Local', 7, NULL, NULL),  -- Bandagem no almoxarifado

-- Corredor Sul (Local 8) - Novos itens
(22, 3, 'Local', 8, NULL, NULL),  -- Curativo no corredor sul
(23, 8, 'Local', 8, NULL, NULL),  -- Bandagem no corredor sul

-- Escada 2º Andar (Local 12) - Novos itens (muito raros!)
(24, 6, 'Local', 12, NULL, NULL), -- Pistola na escada (muito rara!)
(25, 5, 'Local', 12, NULL, NULL), -- Poção de Cura na escada (muito rara!)
(26, 4, 'Local', 12, NULL, NULL)  -- Kit Médico na escada
ON CONFLICT (IDInstanciaItem) DO NOTHING;

-- Verificar itens adicionados
SELECT 'Itens adicionados nos locais:' as Status;
SELECT 
    ii.IDInstanciaItem,
    l.Nome as Local,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
        WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
        ELSE 'Desconhecido'
    END as Item,
    c.tipos_itens as Tipo
FROM Instancias_Itens ii
JOIN Local l ON l.IDLocal = ii.IDLocal
JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Chave'
WHERE ii.Localizacao = 'Local' AND ii.IDPersonagem IS NULL
ORDER BY l.Nome, ii.IDInstanciaItem;

-- Resumo por local
SELECT 'Resumo por local:' as Status;
SELECT 
    l.Nome as Local,
    COUNT(*) as Total_Itens,
    STRING_AGG(
        CASE
            WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
            WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
            WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
            WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
            ELSE 'Desconhecido'
        END, 
        ', ' ORDER BY ii.IDInstanciaItem
    ) as Itens
FROM Instancias_Itens ii
JOIN Local l ON l.IDLocal = ii.IDLocal
JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Chave'
WHERE ii.Localizacao = 'Local' AND ii.IDPersonagem IS NULL
GROUP BY l.IDLocal, l.Nome
ORDER BY l.Nome; 