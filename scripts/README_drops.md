# Sistema de Drops de Zumbis

## 🎁 Funcionalidade Implementada

Agora quando você derrota um zumbi, ele tem chance de dropar itens úteis! O sistema usa **probabilidades** e **triggers automáticos** no banco de dados.

## 🧟‍♂️ Tipos de Zumbis e Seus Drops

### **Zumbi Comum** (drops básicos)
- **Curativo** (30% chance) - 1 item
- **Bandagem** (20% chance) - 1-2 itens  
- **Faca** (10% chance) - 1 item

### **Zumbi Brutamonte** (drops melhores)
- **Kit Médico** (25% chance) - 1 item
- **Machado** (15% chance) - 1 item
- **Pistola** (8% chance) - 1 item ⭐ **RARO!**

### **Zumbi Infeccioso** (drops de cura)
- **Curativo** (40% chance) - 1-2 itens
- **Bandagem** (30% chance) - 1-3 itens
- **Kit Médico** (20% chance) - 1 item
- **Poção de Cura** (5% chance) - 1 item ⭐⭐ **MUITO RARO!**

## ⚙️ Como Funciona

### **Trigger Automático**
```sql
-- Quando um zumbi morre (vida = 0):
1. Trigger detecta a morte
2. Verifica tipo do zumbi
3. Calcula probabilidades para cada drop
4. Gera itens automaticamente no local
5. Mostra mensagem no jogo
```

### **Novos Itens Adicionados**
- **Pistola** (Dano: 30, Munição: 10)
- **Machado** (Dano: 25)
- **Bandagem** (Cura: 15)

## 🚀 Como Aplicar

### **Banco Novo:**
```sql
\i DDL2.sql    # Inclui triggers de drops
\i DML2.sql    # Inclui drops configurados
```

### **Banco Existente:**
```sql
-- Opção 1: Script corrigido (recomendado)
\i sistema_drops_corrigido.sql

-- Opção 2: Verificar primeiro, depois aplicar
\i verificar_itens.sql
\i sistema_drops.sql
```

## 🎯 Estratégia de Jogo

### **Farming de Itens:**
- **Zumbis Comuns**: Para itens básicos
- **Zumbis Brutamontes**: Para armas melhores
- **Zumbis Infecciosos**: Para cura em quantidade

### **Dicas:**
- Zumbis mais fortes = drops melhores
- Pistola é muito rara (8%) - guarde munição!
- Poção de Cura é extremamente rara (5%)
- Bandagens são boas para cura rápida

## 🔧 Configuração de Drops

### **Estrutura da Tabela:**
```sql
Zumbi_Drops (
    IDTipoZumbi,      -- Tipo do zumbi
    IDClasseltens,    -- Item que pode dropar
    Probabilidade,    -- Chance (0-100%)
    Quantidade_Min,   -- Mínimo de itens
    Quantidade_Max    -- Máximo de itens
)
```

### **Exemplo de Configuração:**
```sql
-- Zumbi Comum tem 30% chance de dropar 1 curativo
INSERT INTO Zumbi_Drops VALUES (1, 3, 30.0, 1, 1);
```

## 🎮 Experiência no Jogo

### **Ao Derrotar um Zumbi:**
```
Zumbi Comum derrotado!

🎁 O zumbi dropou:
  💊 Curativo
  💊 Bandagem

Missão de eliminar zumbi atualizada!
```

### **Se Não Dropar Nada:**
```
Zumbi Comum derrotado!

💀 O zumbi não dropou nada...

Missão de eliminar zumbi atualizada!
```

## 📊 Estatísticas dos Drops

| Tipo Zumbi | Item Mais Comum | Chance | Item Mais Raro | Chance |
|------------|----------------|--------|----------------|--------|
| Comum | Curativo | 30% | Faca | 10% |
| Brutamonte | Kit Médico | 25% | Pistola | 8% |
| Infeccioso | Curativo | 40% | Poção de Cura | 5% |

Agora cada combate é uma oportunidade de conseguir itens valiosos! 🎯 