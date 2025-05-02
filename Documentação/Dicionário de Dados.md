# DICIONÁRIO DE DADOS

## Visão geral das tabelas
Clique em uma tabela e seja diretamente direcionado para ela.

| [Conta](#entidade-conta) | [Personagem](#entidade-personagem) | [ClasseItens](#entidade-classeitens) |
|:----------------------------:|:------------------------------------:|:---------------------------------------------:|
| **[ArmaBranca](#entidade-armabranca)** | **[InstanciaItens](#entidade-instanciaitens)** | **[Arma_de_Fogo](#entidade-arma_de_fogo)**|
|**[Inventario](#entidade-inventario)** |**[Locais](#entidade-locais)** | **[AparecemEm (Itens)](#entidade-aparecemem-itens)** |
| **[Zumbi](#entidade-zumbi)** | **[AparecemEm (Zumbi)](#entidade-aparecemem-zumbis)** | **[Missões](#entidade-missões)** |
|**[Dialogos](#entidade-dialogos)** | **[Contem (Dialogo-Mensagem)](#entidade-contem-diálogo-mensagem)** | **[InterageCom](#entidade-interagecom)** |
|**[GatilhoDialogo](#entidade-gatilhodialogo)** | **[ÉAtivadoPor](#entidade-éativadopor)** |


## Entidade: Conta
**Descrição**: Armazena as informações das contas de usuários.

**Observações**: Esta tabela é a base para autenticação e permissões.

| Campo   | Tipo    | Tamanho | Descrição                       | Restrições        |
| ------- | ------- | ------- | ------------------------------- | ----------------- |
| IDConta | integer |         | Identificador único da conta    | PK / Identity     |
| Email   | varchar |         | E-mail do usuário               | Unique / Not Null |
| Senha   | varchar |         | Senha do usuário                | Not Null          |
| Status  | integer |         | Status da conta (ativo/inativo) | Not Null          |



## Entidade: Personagem
**Descrição**: Armazena os dados dos personagens dos jogadores.

**Observações**: Associado à Conta e à Inventário.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições    |
| ------------ | ------- | ------- | --------------------------------- | ------------- |
| IDPersonagem | integer |         | Identificador único do personagem | PK / Identity |
| Nome         | varchar |         | Nome do personagem                | Not Null      |
| Nivel        | integer |         | Nível do personagem               | Not Null      |
| VidaMaxima   | integer |         | Vida máxima do personagem         | Not Null      |
| VidaAtual    | integer |         | Vida atual do personagem          | Not Null      |
| IDConta      | integer |         | Chave estrangeira para Conta      | FK            |
| IDInventario | integer |         | Chave estrangeira para Inventário | FK            |



## Entidade: ClasseItens
**Descrição**: Define categorias e atributos base para itens do jogo.

**Observações**: É a generalização Total e Conjuntiva de Arma_de_Fogo e ArmaBranca. Por isso, na prática, ela não existe em nível mais baixo.

| Campo         | Tipo    | Tamanho | Descrição                             | Restrições    |
| ------------- | ------- | ------- | ------------------------------------- | ------------- |
| IDClasseItens | integer |         | Identificador único da classe de item | PK / Identity |
| Nome          | varchar |         | Nome do item                          | Not Null      |



## Entidade: Arma_de_Fogo
**Descrição**: Define atributos específicos de armas de fogo.

**Observações**: Especialização de ClasseItens.

| Campo         | Tipo    | Tamanho | Descrição                          | Restrições |
| ------------- | ------- | ------- | ---------------------------------- | ---------- |
| IDClasseItens | integer |         | Chave estrangeira para ClasseItens | PK / FK    |
| Nome          | varchar |         | Nome da arma de fogo               | Not Null   |
| Munição       | integer |         | Quantidade de munição              | Not Null   |



## Entidade: ArmaBranca
**Descrição**: Define atributos específicos de armas brancas.

**Observações**: Especialização de ClasseItens.

| Campo         | Tipo    | Tamanho | Descrição                          | Restrições |
| ------------- | ------- | ------- | ---------------------------------- | ---------- |
| IDClasseItens | integer |         | Chave estrangeira para ClasseItens | PK / FK    |
| Nome          | varchar |         | Nome da arma branca                | Not Null   |
| DanoCorte     | integer |         | Dano de corte em porcentagem       | Not Null   |



## Entidade: InstanciaItens
**Descrição**: Registra itens específicos no mundo do jogo.

**Observações**: Relaciona-se com classes_itens e inventário.

| Campo            | Tipo    | Tamanho | Descrição                                             | Restrições    |
| ---------------- | ------- | ------- | ----------------------------------------------------- | ------------- |
| IDInstanciaItens | integer |         | Identificador único da instância de item              | PK / Identity |
| Quantidade       | integer |         | Quantidade de itens                                   | Not Null      |
| IDInventario     | integer |         | Chave estrangeira para Inventário                     | FK            |
| IDClasseItens    | integer |         | Chave estrangeira para Classe de Itens                | FK            |
| IDArmaBranca     | integer |         | Chave estrangeira para Arma Branca (quando aplicável) | FK            |



## Entidade: Inventario
**Descrição**: Gerencia itens pertencentes a personagens.

**Observações**: Cada personagem possui um inventário.

| Campo            | Tipo    | Tamanho | Descrição                         | Restrições    |
| ---------------- | ------- | ------- | --------------------------------- | ------------- |
| IDInventario     | integer |         | Identificador único do inventário | PK / Identity |
| CapacidadeMaxima | integer |         | Capacidade máxima de itens        | Not Null      |



## Entidade: Locais
**Descrição**: Descreve áreas do mapa do jogo.

**Observações**: Relacionado a personagens, zumbis e itens.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições    |
| ------------ | ------- | ------- | --------------------------------- | ------------- |
| IDLocal      | integer |         | Identificador único do local      | PK / Identity |
| Nome         | varchar |         | Nome do local                     | Not Null      |
| Coordenadas  | varchar |         | Coordenadas do local              | Not Null      |
| IDPersonagem | integer |         | Chave estrangeira para Personagem | FK            |



## Entidade: AparecemEm (Itens)
**Descrição**: Relaciona itens instanciados com locais.

**Observações**: Relacionamento entre InstanciasItens e Locais

| Campo            | Tipo    | Tamanho | Descrição                             | Restrições |
| ---------------- | ------- | ------- | ------------------------------------- | ---------- |
| IDInstanciaItens | integer |         | Chave estrangeira para InstanciaItens | PK / FK    |
| IDLocal          | integer |         | Chave estrangeira para Local          | PK / FK    |



## Entidade: Zumbi
**Descrição**: Registra zumbis no jogo e seus atributos.

**Observações**: Relacionado a Locais.

| Campo    | Tipo    | Tamanho | Descrição                    | Restrições    |
| -------- | ------- | ------- | ---------------------------- | ------------- |
| IDZumbi  | integer |         | Identificador único do zumbi | PK / Identity |
| Nivel    | integer |         | Nível do zumbi               | Not Null      |
| DanoBase | integer |         | Dano base do zumbi           | Not Null      |



## Entidade: AparecemEm (Zumbis)
**Descrição**: Relaciona zumbis com locais.

**Observações**: Ligação entre Zumbi e Locais.

| Campo   | Tipo    | Tamanho | Descrição                    | Restrições |
| ------- | ------- | ------- | ---------------------------- | ---------- |
| IDZumbi | integer |         | Chave estrangeira para Zumbi | PK / FK    |
| IDLocal | integer |         | Chave estrangeira para Local | PK / FK    |



## Entidade: Missões
**Descrição**: Define missões disponíveis no jogo.

**Observações**: Relacionada a Personagem e Locais.

| Campo        | Tipo    | Tamanho | Descrição                          | Restrições    |
| ------------ | ------- | ------- | ---------------------------------- | ------------- |
| IDMissao     | integer |         | Identificador único da missão      | PK / Identity |
| Nome         | varchar |         | Nome da missão                     | Not Null      |
| Descricao    | varchar |         | Descrição da missão                | Not Null      |
| Recompensa   | varchar |         | Recompensa da missão               | Not Null      |
| Status       | integer |         | Status da missão (ativa/concluída) | Not Null      |
| IDPersonagem | integer |         | Chave estrangeira para Personagem  | FK            |
| IDLocal      | integer |         | Chave estrangeira para Local       | FK            |



## Entidade: Dialogos
**Descrição**: Armazena diálogos do jogo (NPCs, tutoriais, etc.).

**Observações**: Relacionado a interações e mensagens.

| Campo     | Tipo    | Tamanho | Descrição                      | Restrições    |
| --------- | ------- | ------- | ------------------------------ | ------------- |
| IDDialogo | integer |         | Identificador único do diálogo | PK / Identity |
| Titulo    | varchar |         | Título do diálogo              | Not Null      |



## Entidade: Contem (Diálogo-Mensagem)
**Descrição**: Relaciona diálogos com suas mensagens.

**Observações**: Associação N:N.

| Campo             | Tipo    | Tamanho | Descrição                       | Restrições |
| ----------------- | ------- | ------- | ------------------------------- | ---------- |
| IDDialogo         | integer |         | Chave estrangeira para Diálogo  | PK / FK    |
| IDMensagemDialogo | integer |         | Chave estrangeira para Mensagem | PK / FK    |



## Entidade: InterageCom
**Descrição**: Relaciona personagens com diálogos.

**Observações**: Associação de interações.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições |
| ------------ | ------- | ------- | --------------------------------- | ---------- |
| IDPersonagem | integer |         | Chave estrangeira para Personagem | PK / FK    |
| IDDialogo    | integer |         | Chave estrangeira para Diálogo    | PK / FK    |



## Entidade: GatilhoDialogo
**Descrição**: Define condições para disparar diálogos.

**Observações**:Associado a Dialogos.

| Campo     | Tipo    | Tamanho | Descrição                      | Restrições    |
| --------- | ------- | ------- | ------------------------------ | ------------- |
| IDGatilho | integer |         | Identificador único do gatilho | PK / Identity |
| Descricao | varchar |         | Descrição do gatilho           | Not Null      |



## Entidade: ÉAtivadoPor
**Descrição**: Relaciona diálogos com os gatilhos que os ativam.

**Observações**:Associação de ativação.

| Campo     | Tipo    | Tamanho | Descrição                      | Restrições |
| --------- | ------- | ------- | ------------------------------ | ---------- |
| IDDialogo | integer |         | Chave estrangeira para Diálogo | PK / FK    |
| IDGatilho | integer |         | Chave estrangeira para Gatilho | PK / FK    |


