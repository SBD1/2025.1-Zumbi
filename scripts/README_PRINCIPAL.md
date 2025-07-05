# 🎮 Jogo de Sobrevivência - Hospital Zumbi

## 📁 Estrutura de Arquivos

### **🏗️ Arquivos Principais (Obrigatórios)**
- **`DDL2.sql`** - Estrutura do banco de dados + triggers
- **`DML2.sql`** - Dados iniciais (locais, zumbis, itens, drops)
- **`jogo.py`** - Código principal do jogo

### **🔄 Scripts para Bancos Existentes**
- **`sistema_drops_corrigido.sql`** - Sistema completo de drops + medicamentos
- **`adicionar_itens_locais.sql`** - Adiciona 26 itens espalhados pelo mapa
- **`triggers_medicamentos.sql`** - Apenas triggers de medicamentos

### **🔍 Arquivos de Diagnóstico (Opcionais)**
- **`teste_triggers.sql`** - Verifica se triggers estão funcionando
- **`verificar_itens.sql`** - Diagnostica itens faltantes

### **📚 Documentação**
- **`README_medicamentos.md`** - Sistema de cura com triggers
- **`README_drops.md`** - Sistema de drops de zumbis
- **`README_itens_locais.md`** - Mapa completo de itens

## 🚀 Como Usar

### **Banco Novo (Recomendado):**
```sql
\i DDL2.sql
\i DML2.sql
python jogo.py
```

### **Banco Existente:**
```sql
\i sistema_drops_corrigido.sql
\i adicionar_itens_locais.sql
\i teste_triggers.sql
python jogo.py
```

### **Se Algo Não Funcionar:**
```sql
\i verificar_itens.sql  -- Diagnostica problemas
```

## 🎯 Funcionalidades Implementadas

### ✅ **Sistema Completo**
- [x] Login e criação de contas
- [x] Criação e seleção de personagens
- [x] Mapa com 10 locais conectados
- [x] Sistema de chaves (escada trancada)
- [x] 3 tipos de zumbis com comportamentos diferentes
- [x] Combate estilo Pokémon com menu de ações
- [x] Sistema de inventário com diferentes tipos de itens
- [x] **Triggers automáticos de cura** (medicamentos)
- [x] **Sistema de drops de zumbis** com probabilidades
- [x] **26 itens espalhados** pelo mapa
- [x] Missões automáticas
- [x] Reinício do jogo ao vencer/morrer

### 🎁 **Itens Disponíveis**
- **Armas**: Faca (15), Machado (25), Pistola (30)
- **Medicamentos**: Curativo (20), Bandagem (15), Kit Médico (50), Poção de Cura (100)
- **Chaves**: Chave do 2º Andar

### 🧟‍♂️ **Zumbis e Drops**
- **Comum**: Drops básicos (30% curativo, 20% bandagem, 10% faca)
- **Brutamonte**: Drops melhores (25% kit médico, 15% machado, 8% pistola)
- **Infeccioso**: Drops de cura (40% curativo, 30% bandagem, 5% poção de cura)

## 🎮 Como Jogar

1. **Crie uma conta** ou faça login
2. **Crie um personagem** (recebe faca inicial)
3. **Explore o mapa** coletando itens
4. **Encontre a chave** na farmácia
5. **Suba para o 2º andar** e salve sua filha!

## 🔧 Configuração do Banco

### **PostgreSQL:**
```sql
CREATE DATABASE Zumbi;
\c Zumbi
\i DDL2.sql
\i DML2.sql
```

### **Python:**
```python
# Ajuste a conexão em jogo.py se necessário
conn = psycopg2.connect(
    dbname="Zumbi",
    user="postgres",
    password="sua_senha",
    host="localhost",
    port="5432"
)
```

## 📊 Estatísticas do Jogo

- **10 locais** para explorar
- **26 itens** espalhados pelo mapa
- **3 tipos de zumbis** com drops únicos
- **4 tipos de medicamentos** com cura variada
- **3 tipos de armas** com dano progressivo
- **Sistema de probabilidades** para drops
- **Triggers automáticos** para cura e drops

Agora você tem um jogo completo e funcional! 🎯 