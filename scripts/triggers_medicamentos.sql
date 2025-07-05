

-- Trigger para garantir que a vida do personagem seja atualizada corretamente
CREATE OR REPLACE FUNCTION atualizar_vida_personagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Garante que a vida não ultrapasse 100
    IF NEW.VidaAtual > 100 THEN
        NEW.VidaAtual := 100;
    END IF;
    
    -- Garante que a vida não seja negativa
    IF NEW.VidaAtual < 0 THEN
        NEW.VidaAtual := 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Remove trigger se já existir
DROP TRIGGER IF EXISTS trigger_atualizar_vida_personagem ON Personagem;

CREATE TRIGGER trigger_atualizar_vida_personagem
    BEFORE UPDATE ON Personagem
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_vida_personagem();

-- Trigger para registrar uso de medicamentos
CREATE OR REPLACE FUNCTION registrar_uso_medicamento()
RETURNS TRIGGER AS $$
DECLARE
    ganho_vida INTEGER;
    vida_atual INTEGER;
    nova_vida INTEGER;
BEGIN
    -- Se um item de medicamento foi deletado (usado)
    IF TG_OP = 'DELETE' THEN
        -- Busca o ganho de vida do medicamento
        SELECT m.Ganho_vida INTO ganho_vida
        FROM Medicamentos m
        WHERE m.IDClasseltens = OLD.IDClasseltens;
        
        -- Se é um medicamento
        IF ganho_vida IS NOT NULL THEN
            -- Busca a vida atual do personagem
            SELECT p.VidaAtual INTO vida_atual
            FROM Personagem p
            WHERE p.IDPersonagem = OLD.IDPersonagem;
            
            -- Calcula nova vida
            nova_vida := LEAST(100, vida_atual + ganho_vida);
            
            -- Atualiza a vida do personagem
            UPDATE Personagem 
            SET VidaAtual = nova_vida 
            WHERE IDPersonagem = OLD.IDPersonagem;
            
            -- Log da ação (opcional)
            RAISE NOTICE 'Medicamento usado: Personagem % curou % pontos de vida. Nova vida: %', 
                        OLD.IDPersonagem, ganho_vida, nova_vida;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Remove trigger se já existir
DROP TRIGGER IF EXISTS trigger_registrar_uso_medicamento ON Instancias_Itens;

CREATE TRIGGER trigger_registrar_uso_medicamento
    AFTER DELETE ON Instancias_Itens
    FOR EACH ROW
    EXECUTE FUNCTION registrar_uso_medicamento();

-- Verificar se os triggers foram criados
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE trigger_name IN ('trigger_atualizar_vida_personagem', 'trigger_registrar_uso_medicamento')
ORDER BY trigger_name; 