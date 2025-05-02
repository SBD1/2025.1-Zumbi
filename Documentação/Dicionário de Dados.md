# DICIONÁRIO DE DADOS


## Entidade: Contas
**Descrição**: Armazena as informações das contas de usuários.

**Observações**: Esta tabela é a base para autenticação e permissões.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_conta         | integer    |         | Identificador único da conta           | PK / Identity                |
| nome_usuario     | varchar    | 50      | Nome de usuário                        | Unique / Not Null            |
| senha_hash       | varchar    | 255     | Hash da senha                          | Not Null                     |
| email            | varchar    | 100     | E-mail do usuário                      | Unique / Not Null            |
| data_criacao     | timestamp  |         | Data de criação da conta               | Not Null                     |
| ultimo_login     | timestamp  |         | Último login                           |                              |
| eh_admin         | boolean    |         | Indica se é administrador              | Default: False               |
| esta_banido      | boolean    |         | Indica se está banido                  | Default: False               |
| motivo_banimento | text       |         | Motivo do banimento (se houver)        |                              |


## Tabela: Personagens
Descrição: Armazena os dados dos personagens dos jogadores.
Observações: Possui uma chave estrangeira da tabela contas.

| Campo                      | Tipo       | Tamanho | Descrição                              | Restrições                   |
|----------------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem              | integer    |         | Identificador único do personagem      | PK / Identity                |
| id_conta                   | integer    |         | Chave estrangeira da tabela contas     | FK / Not Null                |
| nome                       | varchar    | 50      | Nome do personagem                     | Not Null                     |
| nivel                      | integer    |         | Nível do personagem                    | Default: 1                   |
| experiencia                | integer    |         | Pontos de experiência                  | Default: 0                   |
| vida                       | integer    |         | Vida atual                             | Not Null                     |
| vida_maxima                | integer    |         | Vida máxima                            | Not Null                     |
| energia                    | integer    |         | Energia atual                          | Not Null                     |
| energia_maxima             | integer    |         | Energia máxima                         | Not Null                     |
| fome                       | integer    |         | Nível de fome                          | Default: 100                 |
| sede                       | integer    |         | Nível de sede                          | Default: 100                 |
| nivel_infeccao             | integer    |         | Nível de infecção                      | Default: 0                   |
| forca                      | integer    |         | Força do personagem                    | Default: 5                   |
| agilidade                  | integer    |         | Agilidade do personagem                | Default: 5                   |
| resistencia                | integer    |         | Resistência do personagem              | Default: 5                   |
| inteligencia               | integer    |         | Inteligência do personagem             | Default: 5                   |
| carisma                    | integer    |         | Carisma do personagem                  | Default: 5                   |
| data_criacao               | timestamp  |         | Data de criação do personagem          | Not Null                     |
| ultimo_jogado              | timestamp  |         | Última vez que foi jogado              |                              |
| esta_vivo                  | boolean    |         | Indica se está vivo                    | Default: True                |
| contador_mortes            | integer    |         | Número de mortes                       | Default: 0                   |
| contador_mortes_infligidas | integer    |         | Número de mortes causadas              | Default: 0                   |


## Tabela: gatilhos_dialogo
Descrição: Define condições para disparar diálogos.
Observações: Gatilhos podem ser por local, item, etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_gatilho       | integer    |         | Identificador único do gatilho         | PK / Identity                |
| id_dialogo       | integer    |         | Chave estrangeira de dialogos          | FK / Not Null                |
| tipo_gatilho     | enum       |         | Tipo (local, evento, item, etc.)      | Not Null                     |
| valor_gatilho    | varchar    | 100     | Valor específico do gatilho            | Not Null                     |

========================================
LEGENDA:
- PK: Primary Key (Chave Primária)
- FK: Foreign Key (Chave Estrangeira)
- Identity: Campo autoincrementável
- Enum: Valores pré-definidos (ex: enum('combate', 'sobrevivencia'))

## Tabela: contas
Descrição: Armazena as informações das contas de usuários.
Observações: Essa tabela é a base para autenticação e permissões.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_conta         | integer    |         | Identificador único da conta           | PK / Identity                |
| nome_usuario     | varchar    | 50      | Nome de usuário                        | Unique / Not Null            |
| senha_hash       | varchar    | 255     | Hash da senha                          | Not Null                     |
| email            | varchar    | 100     | E-mail do usuário                      | Unique / Not Null            |
| data_criacao     | timestamp  |         | Data de criação da conta               | Not Null                     |
| ultimo_login     | timestamp  |         | Último login                           |                              |
| eh_admin         | boolean    |         | Indica se é administrador              | Default: False               |
| esta_banido      | boolean    |         | Indica se está banido                  | Default: False               |
| motivo_banimento | text       |         | Motivo do banimento (se houver)        |                              |


## Tabela: personagens
Descrição: Armazena os dados dos personagens dos jogadores.
Observações: Possui uma chave estrangeira da tabela contas.

| Campo                      | Tipo       | Tamanho | Descrição                              | Restrições                   |
|----------------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem              | integer    |         | Identificador único do personagem      | PK / Identity                |
| id_conta                   | integer    |         | Chave estrangeira da tabela contas     | FK / Not Null                |
| nome                       | varchar    | 50      | Nome do personagem                     | Not Null                     |
| nivel                      | integer    |         | Nível do personagem                    | Default: 1                   |
| experiencia                | integer    |         | Pontos de experiência                  | Default: 0                   |
| vida                       | integer    |         | Vida atual                             | Not Null                     |
| vida_maxima                | integer    |         | Vida máxima                            | Not Null                     |
| energia                    | integer    |         | Energia atual                          | Not Null                     |
| energia_maxima             | integer    |         | Energia máxima                         | Not Null                     |
| fome                       | integer    |         | Nível de fome                          | Default: 100                 |
| sede                       | integer    |         | Nível de sede                          | Default: 100                 |
| nivel_infeccao             | integer    |         | Nível de infecção                      | Default: 0                   |
| forca                      | integer    |         | Força do personagem                    | Default: 5                   |
| agilidade                  | integer    |         | Agilidade do personagem                | Default: 5                   |
| resistencia                | integer    |         | Resistência do personagem              | Default: 5                   |
| inteligencia               | integer    |         | Inteligência do personagem             | Default: 5                   |
| carisma                    | integer    |         | Carisma do personagem                  | Default: 5                   |
| data_criacao               | timestamp  |         | Data de criação do personagem          | Not Null                     |
| ultimo_jogado              | timestamp  |         | Última vez que foi jogado              |                              |
| esta_vivo                  | boolean    |         | Indica se está vivo                    | Default: True                |
| contador_mortes            | integer    |         | Número de mortes                       | Default: 0                   |
| contador_mortes_infligidas | integer    |         | Número de mortes causadas              | Default: 0                   |


## Tabela: habilidades
Descrição: Armazena as habilidades disponíveis no jogo.
Observações: Define tipos e requisitos para uso.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_habilidade    | integer    |         | Identificador único da habilidade      | PK / Identity                |
| nome             | varchar    | 50      | Nome da habilidade                     | Not Null                     |
| descricao        | text       |         | Descrição detalhada                    |                              |
| tipo             | enum       |         | Tipo (combate, sobrevivência, etc.)    | Not Null                     |
| custo_energia    | integer    |         | Energia consumida ao usar              | Default: 0                   |
| nivel_requerido  | integer    |         | Nível mínimo para desbloquear          | Default: 1                   |


## Tabela: habilidades_personagem
Descrição: Relaciona personagens às habilidades que possuem.
Observações: Chaves estrangeiras das tabelas personagens e habilidades.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem    | integer    |         | Chave estrangeira de personagens       | FK / Not Null (PK composta)  |
| id_habilidade    | integer    |         | Chave estrangeira de habilidades       | FK / Not Null (PK composta)  |
| nivel_habilidade | integer    |         | Nível de proficiência na habilidade    | Default: 1                   |


## Tabela: classes_itens
Descrição: Define categorias e atributos base para itens do jogo.
Observações: Enumera tipos como "arma", "comida", etc.

| Campo              | Tipo        | Tamanho | Descrição                              | Restrições                   |
|--------------------|-------------|---------|----------------------------------------|------------------------------|
| id_classe_item     | integer     |         | Identificador único da classe          | PK / Identity                |
| nome               | varchar     | 50      | Nome do item                           | Not Null                     |
| descricao          | text        |         | Descrição detalhada                    |                              |
| tipo               | enum        |         | Tipo (arma, comida, etc.)              | Not Null                     |
| peso_base          | decimal(5,2)|         | Peso padrão do item                    | Default: 0.00                |
| valor_base         | integer     |         | Valor monetário base                   | Default: 0                   |
| durabilidade_base  | integer     |         | Durabilidade inicial                   | Default: 100                 |
| efeito_base        | text        |         | Efeito ao usar (se aplicável)          |                              |
| stack_maximo       | integer     |         | Quantidade máxima em um slot           | Default: 1                   |


## Tabela: instancias_itens
Descrição: Registra itens específicos no mundo do jogo.
Observações: Relaciona-se com classes_itens e locais.

| Campo               | Tipo       | Tamanho | Descrição                              | Restrições                   |
|---------------------|------------|---------|----------------------------------------|------------------------------|
| id_instancia_item   | integer    |         | Identificador único do item            | PK / Identity                |
| id_classe_item      | integer    |         | Chave estrangeira de classes_itens     | FK / Not Null                |
| durabilidade_atual  | integer    |         | Durabilidade restante                  | Default: 100                 |
| id_local_spawn      | integer    |         | Local onde o item aparece              | FK                           |


## Tabela: inventario
Descrição: Gerencia itens pertencentes a personagens.
Observações: Chaves estrangeiras de personagens e instancias_itens.

| Campo               | Tipo       | Tamanho | Descrição                              | Restrições                   |
|---------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem       | integer    |         | Chave estrangeira de personagens       | FK / Not Null (PK composta)  |
| id_instancia_item   | integer    |         | Chave estrangeira de instancias_itens  | FK / Not Null (PK composta)  |
| quantidade          | integer    |         | Quantidade do item                     | Default: 1                   |
| equipado            | boolean    |         | Indica se está equipado                | Default: False               |


## Tabela: locais
Descrição: Descreve áreas do mapa do jogo.
Observações: Tipos incluem "cidade", "floresta", etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_local         | integer    |         | Identificador único do local           | PK / Identity                |
| nome             | varchar    | 50      | Nome do local                          | Not Null                     |
| descricao        | text       |         | Descrição detalhada                    |                              |
| tipo             | enum       |         | Tipo (cidade, hospital, etc.)          | Not Null                     |
| seguranca        | integer    |         | Nível de segurança (0-100)             | Default: 50                  |
| recursos         | integer    |         | Nível de recursos disponíveis (0-100)  | Default: 50                  |


## Tabela: posicoes
Descrição: Armazena a localização atual dos personagens no mapa.
Observações: Relaciona-se com personagens e locais.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem    | integer    |         | Chave estrangeira de personagens       | FK / Not Null (PK composta)  |
| id_local         | integer    |         | Chave estrangeira de locais            | FK / Not Null (PK composta)  |
| coordenada_x     | integer    |         | Posição no eixo X                      | Default: 0                   |
| coordenada_y     | integer    |         | Posição no eixo Y                      | Default: 0                   |


## Tabela: zumbis
Descrição: Registra zumbis no jogo e seus atributos.
Observações: Tipos incluem "comum", "tanque", etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_zumbi         | integer    |         | Identificador único do zumbi           | PK / Identity                |
| id_local         | integer    |         | Chave estrangeira de locais            | FK / Not Null                |
| tipo             | enum       |         | Tipo (comum, corredor, etc.)           | Not Null                     |
| vida             | integer    |         | Vida atual                             | Not Null                     |
| forca            | integer    |         | Dano causado                           | Default: 10                  |
| velocidade       | integer    |         | Velocidade de movimento                | Default: 5                   |
| coordenada_x     | integer    |         | Posição no eixo X                      | Default: 0                   |
| coordenada_y     | integer    |         | Posição no eixo Y                      | Default: 0                   |


## Tabela: missoes
Descrição: Define missões disponíveis no jogo.
Observações: Possui recompensas e requisitos.

| Campo                   | Tipo       | Tamanho | Descrição                              | Restrições                   |
|-------------------------|------------|---------|----------------------------------------|------------------------------|
| id_missao              | integer    |         | Identificador único da missão          | PK / Identity                |
| nome                   | varchar    | 100     | Nome da missão                         | Not Null                     |
| descricao              | text       |         | Descrição detalhada                    |                              |
| id_local_origem        | integer    |         | Local onde a missão inicia (FK)        | FK                           |
| experiencia_recompensa | integer    |         | Experiência concedida ao completar     | Default: 100                 |
| nivel_requerido        | integer    |         | Nível mínimo para aceitar              | Default: 1                   |


## Tabela: missoes_personagem
Descrição: Rastreia o progresso de missões por personagem.
Observações: Estados incluem "em_andamento", "completa", etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem    | integer    |         | Chave estrangeira de personagens       | FK / Not Null (PK composta)  |
| id_missao        | integer    |         | Chave estrangeira de missoes           | FK / Not Null (PK composta)  |
| estado           | enum       |         | Estado (disponivel, em_andamento, etc.)| Not Null                     |
| progresso        | integer    |         | Progresso atual (0-100)                | Default: 0                   |


## Tabela: dialogos
Descrição: Armazena diálogos do jogo (NPCs, tutoriais, etc.).
Observações: Categorias incluem "história", "evento", etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_dialogo       | integer    |         | Identificador único do diálogo         | PK / Identity                |
| titulo           | varchar    | 100     | Título do diálogo                      | Not Null                     |
| categoria        | enum       |         | Categoria (tutorial, npc, etc.)        | Not Null                     |
| prioridade       | integer    |         | Ordem de exibição                      | Default: 1                   |


## Tabela: mensagens_dialogo
Descrição: Mensagens individuais dentro de um diálogo.
Observações: Pode requerer ações do jogador.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_mensagem      | integer    |         | Identificador único da mensagem        | PK / Identity                |
| id_dialogo       | integer    |         | Chave estrangeira de dialogos          | FK / Not Null                |
| ordem            | integer    |         | Ordem de exibição no diálogo           | Not Null                     |
| texto            | text       |         | Conteúdo da mensagem                   | Not Null                     |
| acao_requerida   | enum       |         | Ação necessária (nenhuma, escolha, etc.)| Default: 'nenhuma'          |


## Tabela: opcoes_resposta
Descrição: Opções de resposta para mensagens de diálogo.
Observações: Define ações e redirecionamentos.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_opcao         | integer    |         | Identificador único da opção           | PK / Identity                |
| id_mensagem      | integer    |         | Chave estrangeira de mensagens_dialogo | FK / Not Null                |
| texto_opcao      | varchar    | 255     | Texto da opção                         | Not Null                     |
| acao             | varchar    | 50      | Ação executada ao selecionar           |                              |
| proxima_mensagem | integer    |         | Próxima mensagem no fluxo (FK opcional)| FK                           |


## Tabela: dialogos_personagem
Descrição: Rastreia diálogos vistos/completos por personagem.
Observações: Estados incluem "nao_visto", "completo".

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_personagem    | integer    |         | Chave estrangeira de personagens       | FK / Not Null (PK composta)  |
| id_dialogo       | integer    |         | Chave estrangeira de dialogos          | FK / Not Null (PK composta)  |
| estado           | enum       |         | Estado (nao_visto, iniciado, etc.)     | Not Null                     |
| ultima_mensagem  | integer    |         | Última mensagem visualizada (FK)       | FK                           |
| data_visualizacao| timestamp  |         | Data/hora da última visualização       |                              |


## Tabela: gatilhos_dialogo
Descrição: Define condições para disparar diálogos.
Observações: Gatilhos podem ser por local, item, etc.

| Campo            | Tipo       | Tamanho | Descrição                              | Restrições                   |
|------------------|------------|---------|----------------------------------------|------------------------------|
| id_gatilho       | integer    |         | Identificador único do gatilho         | PK / Identity                |
| id_dialogo       | integer    |         | Chave estrangeira de dialogos          | FK / Not Null                |
| tipo_gatilho     | enum       |         | Tipo (local, evento, item, etc.)       | Not Null                     |
| valor_gatilho    | varchar    | 100     | Valor específico do gatilho            | Not Null                     |


LEGENDA:
- PK: Primary Key (Chave Primária)
- FK: Foreign Key (Chave Estrangeira)
- Identity: Campo autoincrementável
- Enum: Valores pré-definidos (ex: enum('combate', 'sobrevivencia'))

