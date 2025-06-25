CREATE OR REPLACE FUNCTION coletar_itens(
    p_id_personagem INT,
    p_ids_itens INT[]
) RETURNS TEXT AS $$
DECLARE
    v_mensagem TEXT := '';
    v_item_id INT;
    v_item_nome TEXT;
    v_tipo_item TEXT;
BEGIN
    -- Verificar se o personagem existe
    IF NOT EXISTS (SELECT 1 FROM Personagem WHERE IDPersonagem = p_id_personagem) THEN
        RETURN 'Erro: Personagem não encontrado.';
    END IF;
    
    -- Processar cada item
    FOREACH v_item_id IN ARRAY p_ids_itens
    LOOP
        -- Verificar se o item existe e está no local do personagem
        SELECT 
            c.tipos_itens,
            CASE
                WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
                WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
                WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
                WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
                ELSE 'Item Desconhecido'
            END
        INTO v_tipo_item, v_item_nome
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
        LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
        LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Chave'
        WHERE ii.IDInstanciaItem = v_item_id
        AND ii.IDPersonagem IS NULL
        AND ii.Localizacao = 'Local'
        AND ii.IDLocal = (SELECT IDLocal FROM Personagem WHERE IDPersonagem = p_id_personagem);
        
        IF v_tipo_item IS NULL THEN
            v_mensagem := v_mensagem || 'Item ID ' || v_item_id || ' não encontrado ou não pode ser coletado. ';
        ELSE
            -- Atualizar o item para pertencer ao personagem
            UPDATE Instancias_Itens 
            SET IDPersonagem = p_id_personagem, 
                IDLocal = NULL 
            WHERE IDInstanciaItem = v_item_id;
            
            v_mensagem := v_mensagem || 'Coletado: ' || v_item_nome || ' (' || v_tipo_item || '). ';
        END IF;
    END LOOP;
    
    RETURN v_mensagem;
END;
$$ LANGUAGE plpgsql;