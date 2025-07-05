/*
Script para verificar se todos os itens necessários existem
Execute este script antes de aplicar o sistema de drops
*/

-- Verificar itens na tabela Classeltens
SELECT 'Verificando Classeltens:' as Status;
SELECT IDClasseltens, tipos_itens 
FROM Classeltens 
WHERE IDClasseltens IN (2,3,4,5,6,7,8,10)
ORDER BY IDClasseltens;

-- Verificar medicamentos
SELECT 'Verificando Medicamentos:' as Status;
SELECT m.IDClasseltens, m.Nome, m.Ganho_vida
FROM Medicamentos m
WHERE m.IDClasseltens IN (3,4,5,8)
ORDER BY m.IDClasseltens;

-- Verificar armas brancas
SELECT 'Verificando Armas Brancas:' as Status;
SELECT ab.IDClasseltens, ab.Nome, ab.Dano_maximo
FROM ArmaBranca ab
WHERE ab.IDClasseltens IN (2,7)
ORDER BY ab.IDClasseltens;

-- Verificar armas de fogo
SELECT 'Verificando Armas de Fogo:' as Status;
SELECT af.IDClasseltens, af.Nome, af.Dano_maximo
FROM ArmaDeFogo af
WHERE af.IDClasseltens IN (6)
ORDER BY af.IDClasseltens;

-- Verificar chaves
SELECT 'Verificando Chaves:' as Status;
SELECT ch.IDClasseltens, ch.Nome_Chave
FROM Chaves ch
WHERE ch.IDClasseltens IN (10)
ORDER BY ch.IDClasseltens;

-- Verificar tipos de zumbis
SELECT 'Verificando Tipos de Zumbis:' as Status;
SELECT IDTipoZumbi, Nome
FROM TipoZumbi
ORDER BY IDTipoZumbi; 