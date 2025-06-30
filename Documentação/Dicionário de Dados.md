# DICIONÁRIO DE DADOS

## Visão geral das tabelas
Clique em uma tabela e seja diretamente direcionado para ela.

| [Conta](#entidade-conta) | [Personagem](#entidade-personagem) | [Classeltens](#entidade-classeltens) |
|:----------------------------:|:------------------------------------:|:---------------------------------------------:|
| **[ArmaBranca](#entidade-armabranca)** | **[Instancias_Itens](#entidade-instancias_itens)** | **[ArmaDeFogo](#entidade-armadefogo)**|
|**[Inventario](#entidade-inventario)** |**[Local](#entidade-local)** | **[Local_Instancias_Itens](#entidade-local_instancias_itens)** |
| **[Instancia_Zumbi](#entidade-instancia_zumbi)** | **[Local_Instancia_Zumbi](#entidade-local_instancia_zumbi)** | **[Missao](#entidade-missao)** |
|**[Dialogos](#entidade-dialogos)** | **[MensagensDialogos](#entidade-mensagensdialogos)** |**[Personagem_Missao](#entidade-personagem_missao)** |
|**[TipoZumbi](#entidade-tipozumbi)** | **[Zumbi_Comum](#entidade-zumbi_comum)** | **[Zumbi_Infeccioso](#entidade-zumbi_infeccioso)** |
|**[Zumbi_Brutamonte](#entidade-zumbi_brutamonte)** | **[Chaves](#entidade-chaves)** | **[Local_Chaves](#entidade-local_chaves)** |
|**[Medicamentos](#entidade-medicamentos)** | **[Dialogos_Missao](#entidade-dialogos_missao)** |


## Entidade: Conta
**Descrição**: Armazena as informações das contas de usuários.

**Observações**: Esta tabela é a base para autenticação e permissões.

| Campo   | Tipo    | Tamanho | Descrição                       | Restrições        |
| ------- | ------- | ------- | ------------------------------- | ----------------- |
| IDConta | serial |         | Identificador único da conta    | PK / Identity     |
| Email   | varchar | 255     | E-mail do usuário               | Unique / Not Null |
| Senha   | varchar | 255     | Senha do usuário                | Not Null          |
| Status  | int |         | Status da conta (ativo/inativo) | Not Null          |



## Entidade: Personagem
**Descrição**: Armazena os dados dos personagens dos jogadores.

**Observações**: Associado à Conta.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições    |
| ------------ | ------- | ------- | --------------------------------- | ------------- |
| IDPersonagem | serial |         | Identificador único do personagem | PK / Identity |
| Nome         | varchar | 255      | Nome do personagem                | Not Null      |
| VidaAtual    | integer |         | Vida atual do personagem          | Not Null      |
| IDConta      | integer |         | Chave estrangeira para Conta      | FK            |
| IDLocal      | integer |         | Chave estrangeira para Local      | FK      |



## Entidade: Classeltens
**Descrição**: Define categorias e atributos base para itens do jogo.

**Observações**: Define as classes de itens disponíveis no jogo.

| Campo         | Tipo    | Tamanho | Descrição                             | Restrições    |
| ------------- | ------- | ------- | ------------------------------------- | ------------- |
| IDClasseltens | integer |         | Identificador único da classe de item | PK / Identity |
| tipo_itens    | tipo_itens |      | Tipo ENUM para itens                  | Not Null      |

**tipo_itens**: tipo ENUM (enumeração) de itens, os quais são: arma branca, arma de fogo, medicamentos e chave.


## Entidade: ArmaDeFogo
**Descrição**: Define atributos específicos de armas de fogo.

**Observações**: Especialização de Classeltens.

| Campo         | Tipo    | Tamanho | Descrição                          | Restrições |
| ------------- | ------- | ------- | ---------------------------------- | ---------- |
| IDClasseItens | integer |         | Identificador único da arma        | PK / FK    |
| Nome          | varchar | 255     |                                    | Not Null   |
| Dano_maximo   | integer |         | Dano máximo da arma                | Not Null   |



## Entidade: ArmaBranca
**Descrição**: Define atributos específicos de armas brancas.

**Observações**: Especialização de Classeltens.

| Campo         | Tipo    | Tamanho | Descrição                          | Restrições |
| ------------- | ------- | ------- | ---------------------------------- | ---------- |
| IDClasseItens | integer |         | Identificador único da arma        | PK / FK    |
| Nome          | varchar | 255     |                                    | Not Null   |
| Dano_maximo   | integer |         | Dano máximo da arma                | Not Null   |



## Entidade: Instancias_Itens
**Descrição**: Registra itens específicos no mundo do jogo.

**Observações**: Relaciona-se com Classeltens e Inventario.

| Campo            | Tipo    | Tamanho | Descrição                                             | Restrições    |
| ---------------- | ------- | ------- | ----------------------------------------------------- | ------------- |
| IDInstanciaItem  | integer |         | Identificador único da instância de item              | PK / Identity |
| IDClasseltens    | integer |         | Chave estrangeira para Classe de Itens                | FK            |
| Localizacao      |origem_item |         |                                                    | Not Nul       |
| IDLocal          | integer |         |                                                       | FK            |
| IDPersonagem     | integer |         |                                                       |               |
| Municao          | integer |         |                                                       |               |



## Entidade: Inventario
**Descrição**: Gerencia itens pertencentes a personagens.

**Observações**: Cada personagem possui um inventário.

| Campo            | Tipo    | Tamanho | Descrição                         | Restrições    |
| ---------------- | ------- | ------- | --------------------------------- | ------------- |
| IDInventario     | integer |         | Identificador único do inventário | PK / Identity |
| CapacidadeMaxima | integer |         | Capacidade máxima de itens        | Not Null      |
| IDPersonagem     | integer |         | Chave estrangeira para Personagem | FK            |



## Entidade: Local
**Descrição**: Descreve áreas do mapa do jogo.

**Observações**: Relacionado a zumbis e itens.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições    |
| ------------ | ------- | ------- | --------------------------------- | ------------- |
| IDLocal      | integer |         | Identificador único do local      | PK / Identity |
| Nome         | varchar | 255      | Nome do local                     | Not Null      |
| Descricao    | text    |         | Características do local          |               |
| Precisa_Chave| boolean |         | Indica se o local requer chave    | Not Null      |



## Entidade: Local_Instancias_Itens
**Descrição**: Relaciona itens instanciados com locais.

**Observações**: Relacionamento entre Instancias_Itens e Local.

| Campo            | Tipo    | Tamanho | Descrição                             | Restrições |
| ---------------- | ------- | ------- | ------------------------------------- | ---------- |
| IDInstanciaItem  | integer |         | Chave estrangeira para Instancia_Itens| PK / FK    |
| IDLocal          | integer |         | Chave estrangeira para Local          | PK / FK    |



## Entidade: Instancia_Zumbi
**Descrição**: Registra zumbis no jogo e seus atributos.

**Observações**: Relacionado a Local.

| Campo            | Tipo    | Tamanho | Descrição                    | Restrições    |
| ---------------- | ------- | ------- | ---------------------------- | ------------- |
| IDInstanciaZumbi | integer |         | Identificador único do zumbi | PK / Identity |
| VidaAtual        | integer |         | Vida atual do zumbi          | Not Null      |
| IDLocal          | integer |         | Chave estrangeira para Local | FK            |



## Entidade: Local_Instancia_Zumbi
**Descrição**: Relaciona zumbis com locais.

**Observações**: Ligação entre Instancia_Zumbi e Local.

| Campo            | Tipo    | Tamanho | Descrição                    | Restrições |
| ---------------- | ------- | ------- | ---------------------------- | ---------- |
| IDInstanciaZumbi | integer |         | Chave estrangeira para Zumbi | PK / FK    |
| IDLocal          | integer |         | Chave estrangeira para Local | PK / FK    |



## Entidade: Missao
**Descrição**: Define missões disponíveis no jogo.

**Observações**: Relacionada a Personagem e Dialogos.

| Campo        | Tipo    | Tamanho | Descrição                          | Restrições    |
| ------------ | ------- | ------- | ---------------------------------- | ------------- |
| IDMissao     | integer |         | Identificador único da missão      | PK / Identity |
| Nome         | varchar | 50      | Nome da missão                     | Not Null      |
| Descricao    | varchar | 200     | Descrição da missão                | Not Null      |
| Recompensa   | varchar | 100     | Recompensa da missão               | Not Null      |
| Status       | varchar | 20      | Status da missão                   | Not Null      |



## Entidade: Dialogos
**Descrição**: Armazena diálogos do jogo (NPCs, tutoriais, etc.).

**Observações**: Relacionado a missões e mensagens.

| Campo     | Tipo    | Tamanho | Descrição                      | Restrições    |
| --------- | ------- | ------- | ------------------------------ | ------------- |
| IDDialogo | integer |         | Identificador único do diálogo | PK / Identity |
| Titulo    | varchar | 255     | Título do diálogo              | Not Null      |



## Entidade: MensagensDialogos
**Descrição**: Contém as mensagens que ocorrem em um diálogo.

**Observações**: Relaciona-se com Dialogos.

| Campo             | Tipo    | Tamanho | Descrição                      | Restrições    |
| ----------------- | ------- | ------- | ------------------------------ | ------------- |
| IDMensagemDialogo | integer |         | Identificador único da mensagem| PK / Identity |
| Texto             | text    |         | Texto da mensagem              | Not Null      |
| Ordem_de_Exibicao | integer |         | Ordem de exibição da mensagem  | Not Null      |
| IDDialogo         | integer |         | Chave estrangeira para Diálogo | FK            |



## Entidade: Personagem_Missao
**Descrição**: Relaciona personagens com missões.

**Observações**: Associação N:N.

| Campo        | Tipo    | Tamanho | Descrição                         | Restrições |
| ------------ | ------- | ------- | --------------------------------- | ---------- |
| IDPersonagem | integer |         | Chave estrangeira para Personagem | PK / FK    |
| IDMissao     | integer |         | Chave estrangeira para Missão     | PK / FK    |



## Entidade: TipoZumbi
**Descrição**: Define os tipos base de zumbis.

**Observações**: Classe base para tipos específicos de zumbis.

| Campo        | Tipo    | Tamanho | Descrição                    | Restrições    |
| ------------ | ------- | ------- | ---------------------------- | ------------- |
| IDTipoZumbi  | integer |         | Identificador único do tipo  | PK / Identity |
| Nome     | varchar |  255       | Nome do tipo de zumbi            | Not Null      |



## Entidade: Zumbi_Comum
**Descrição**: Define características dos zumbis comuns.

**Observações**: Especialização de TipoZumbi.

| Campo         | Tipo    | Tamanho | Descrição                    | Restrições |
| ------------- | ------- | ------- | ---------------------------- | ---------- |
| IDZumbiComum  | integer |         | Identificador único          | PK / Identity |
| DanoBase      | integer |         | Dano base do zumbi           | Not Null   |



## Entidade: Zumbi_Infeccioso
**Descrição**: Define características dos zumbis infecciosos.

**Observações**: Especialização de TipoZumbi.

| Campo             | Tipo    | Tamanho | Descrição                    | Restrições |
| ----------------- | ------- | ------- | ---------------------------- | ---------- |
| IDZumbiInfeccioso | integer |         | Identificador único          | PK / Identity |
| Taxa_Infeccao     | integer |         | Taxa de infecção             | Not Null   |
| DanoBase          | integer |         | Dano base do zumbi           | Not Null   |



## Entidade: Zumbi_Brutamonte
**Descrição**: Define características dos zumbis brutamontes.

**Observações**: Especialização de TipoZumbi.

| Campo              | Tipo    | Tamanho | Descrição                    | Restrições |
| ------------------ | ------- | ------- | ---------------------------- | ---------- |
| IDZumbiBrutamonte  | integer |         | Identificador único          | PK / Identity |
| Resistencia_a_bala | boolean |         | Resistência a balas          | Not Null   |
| DanoBase           | integer |         | Dano base do zumbi           | Not Null   |



## Entidade: Chaves
**Descrição**: Define as chaves do jogo.

**Observações**: Usadas para acessar locais restritos.

| Campo      | Tipo    | Tamanho | Descrição                    | Restrições    |
| ---------- | ------- | ------- | ---------------------------- | ------------- |
| IDClasseItens  | integer |     | Identificador único da chave | PK / FK       |
| Nome_Chave | varchar | 255      | Nome da chave               | Not Null      |



## Entidade: Local_Chaves
**Descrição**: Relaciona locais com suas chaves necessárias.

**Observações**: Associação N:N.

| Campo    | Tipo    | Tamanho | Descrição                    | Restrições |
| -------- | ------- | ------- | ---------------------------- | ---------- |
| IDLocal  | integer |         | Chave estrangeira para Local | PK / FK    |
| IDChave  | integer |         | Chave estrangeira para Chave | PK / FK    |



## Entidade: Medicamentos
**Descrição**: Define características dos medicamentos.

**Observações**: Usados para recuperação de vida.

| Campo          | Tipo    | Tamanho | Descrição                    | Restrições    |
| -------------- | ------- | ------- | ---------------------------- | ------------- |
| IDClasseItens  | integer |         | Identificador único          | PK / FK       |
| Nome           | varchar | 255     |                              | Not Null      |
| Ganho_vida     | integer |         | Quantidade de vida recuperada| Not Null      |



## Entidade: Dialogos_Missao
**Descrição**: Relaciona diálogos com missões.

**Observações**: Associação N:N.

| Campo     | Tipo    | Tamanho | Descrição                    | Restrições |
| --------- | ------- | ------- | ---------------------------- | ---------- |
| IDDialogo | integer |         | Chave estrangeira para Diálogo| PK / FK    |
| IDMissao  | integer |         | Chave estrangeira para Missão | PK / FK    |


