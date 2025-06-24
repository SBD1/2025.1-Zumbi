CREATE OR REPLACE FUNCTION coletar_itens(
    p_id_personagem INT,
    p_itens_ids INT[]
) RETURNS TEXT AS $$
DECLARE
    item_id INT;
    item_nome TEXT;
    itens_coletados TEXT := '';
    qtd_coletada INT := 0;
    v_id_local INT;
BEGIN
    -- Recupera o local atual do personagem
    SELECT IDLocal INTO v_id_local
    FROM Personagem
    WHERE IDPersonagem = p_id_personagem;

    IF v_id_local IS NULL THEN
        RETURN 'Personagem não encontrado ou sem local definido.';
    END IF;

    -- Loop pelos IDs dos itens
    FOREACH item_id IN ARRAY p_itens_ids LOOP
        -- Verifica se o item está no mesmo local e ainda não foi coletado
        SELECT c.tipos_itens INTO item_nome
        FROM Instancias_Itens i
        JOIN Classeltens c ON c.IDClasseltens = i.IDClasseltens
        WHERE i.IDInstanciaItem = item_id
          AND i.IDLocal = v_id_local
          AND i.IDPersonagem IS NULL
        FOR UPDATE;

        -- Se não encontrar, pula para o próximo
        IF NOT FOUND THEN
            RAISE NOTICE 'Item ID % não encontrado no local ou já coletado', item_id;
            CONTINUE;
        END IF;

        -- Atualiza o dono do item
        UPDATE Instancias_Itens
        SET IDPersonagem = p_id_personagem,
            IDLocal = NULL,
            Localizacao = 'Personagem'
        WHERE IDInstanciaItem = item_id;

        -- Adiciona à lista de coletados
        itens_coletados := itens_coletados || item_nome || ', ';
        qtd_coletada := qtd_coletada + 1;
    END LOOP;

    -- Retorna os resultados
    IF qtd_coletada > 0 THEN
        -- Remove a última vírgula e espaço
        itens_coletados := RTRIM(itens_coletados, ', ');
        RETURN 'Itens coletados com sucesso: ' || itens_coletados;
    ELSE
        RETURN 'Nenhum item válido foi coletado.';
    END IF;

EXCEPTION WHEN OTHERS THEN
    RETURN 'Erro ao coletar itens: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;
