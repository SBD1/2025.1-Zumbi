/*
Script de teste para verificar se os triggers estão funcionando
Execute este script após aplicar os triggers
*/

-- 1. Verificar se os triggers foram criados
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table
FROM information_schema.triggers 
WHERE trigger_name IN ('trigger_atualizar_vida_personagem', 'trigger_registrar_uso_medicamento')
ORDER BY trigger_name;

-- 2. Verificar se os medicamentos existem
SELECT 
    m.IDClasseltens,
    m.Nome,
    m.Ganho_vida
FROM Medicamentos m
ORDER BY m.Ganho_vida;

-- 3. Verificar itens disponíveis no mapa
SELECT 
    ii.IDInstanciaItem,
    m.Nome as Medicamento,
    m.Ganho_vida,
    l.Nome as Local
FROM Instancias_Itens ii
JOIN Medicamentos m ON m.IDClasseltens = ii.IDClasseltens
JOIN Local l ON l.IDLocal = ii.IDLocal
WHERE ii.Localizacao = 'Local' AND ii.IDPersonagem IS NULL
ORDER BY ii.IDInstanciaItem;

-- 4. Teste manual (substitua X pelo ID de um personagem existente)
-- UPDATE Personagem SET VidaAtual = 50 WHERE IDPersonagem = X;
-- SELECT IDPersonagem, Nome, VidaAtual FROM Personagem WHERE IDPersonagem = X; 