import psycopg2
import random

# Conexão com o banco
conn = psycopg2.connect(
    dbname="Zumbi2",
    user="postgres",
    password="",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

# Variável global para guardar o personagem selecionado
personagem_selecionado = None


# Função de login
def login():
    print("Você possui conta? Y/N \n")
    opcao = input()
    if opcao == 'Y':
        email = input("Email: ")
        senha = input("Senha: ")

        cursor.execute(
            'SELECT * FROM Conta WHERE Email = %s AND Senha = %s',
            (email, senha))
        jogador = cursor.fetchone()

        if jogador:
            print(f"\nBem-vindo, {email}!\n")
            menu_jogo(jogador)
        else:
            print("Login inválido.")

    elif opcao == 'N':
        print("Vamos criar sua conta")
        email = input("Email:")
        senha = input("Senha:")

        try:
            cursor.execute(
                'INSERT INTO Conta (Email, Senha, Status) VALUES (%s, %s, %s)',
                (email, senha, 1))  # Status 1 para conta ativa
            conn.commit()
            print("Conta criada com sucesso!")
            # Loga automaticamente após a criação da conta
            cursor.execute(
                'SELECT * FROM Conta WHERE Email = %s AND Senha = %s',
                (email, senha))
            jogador = cursor.fetchone()
            menu_jogo(jogador)

        except psycopg2.Error as e:
            conn.rollback()
            print(f"Erro ao criar conta: {e}")


# 🎭 Selecionar Personagem
def SelecionarPersonagem(jogador):
    global personagem_selecionado

    cursor.execute(
        'SELECT IDPersonagem, Nome FROM Personagem WHERE IDConta = %s',
        (jogador[0],))

    personagens = cursor.fetchall()

    if not personagens:
        print("Nenhum personagem encontrado. Crie um personagem primeiro.")
        CriarPersonagem(jogador)  # Chama a função para criar personagem
        return

    print("\n👥 Seus Personagens:")
    for idx, (idpersonagem, nome) in enumerate(personagens, start=1):
        print(f"{idx}. {nome} (ID: {idpersonagem})")

    while True:
        try:
            opcao = int(input("\nDigite o número do personagem que deseja usar: "))
            if 1 <= opcao <= len(personagens):
                personagem_selecionado = personagens[opcao - 1][0]  # idpersonagem
                print(f"\nPersonagem '{personagens[opcao - 1][1]}' selecionado!\n")
                return
            else:
                print("Opção inválida. Tente novamente.")
        except ValueError:
            print("Digite um número válido.")


# Função para criar um novo personagem
def CriarPersonagem(jogador):
    nome_personagem = input("Digite o nome do seu novo personagem: ")

    try:
        # Local padrão para o personagem (IDLocal = 1)
        cursor.execute(
            'INSERT INTO Personagem (Nome, VidaAtual, IDConta, IDLocal) VALUES (%s, %s, %s, %s)',
            (nome_personagem, 100, jogador[0], 1))  # Vida inicial = 100
        conn.commit()
        print(f"Personagem '{nome_personagem}' criado com sucesso!")
        SelecionarPersonagem(jogador)  # Volta para a seleção de personagem
    except psycopg2.Error as e:
        conn.rollback()
        print(f"Erro ao criar personagem: {e}")


# Função de mapa
def Mapa():
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado. Selecione um personagem primeiro.")
        return

    while True:
        # Consulta o local atual do personagem
        cursor.execute(
            """
            SELECT p.Nome, l.Nome AS local_nome 
            FROM Personagem p 
            JOIN Local l 
            ON l.IDLocal = p.IDLocal 
            WHERE p.IDPersonagem = %s
            """,
            (personagem_selecionado,)
        )
        resultado = cursor.fetchone()

        if resultado:
            nome_personagem, local_nome = resultado
            print(f"\nLocal Atual: {local_nome}")
            print(f"Personagem: {nome_personagem}")

        else:
            print("Personagem não encontrado ou sem local definido.")

        # Menu do mapa
        print("\n--- Mapa ---")
        print("1. Movimentar")
        print("2. Sair do Mapa")

        opcao = input("Escolha: ")

        if opcao == "1":
            Movimentar()
        elif opcao == "2":
            print("↩Saindo do mapa...")
            break
        else:
            print("Opção inválida.")


# Função para Movimentar
def Movimentar():
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado. Selecione um personagem primeiro.")
        return

    # Consulta o IDLocal atual do personagem
    cursor.execute(
        "SELECT IDLocal FROM Personagem WHERE IDPersonagem = %s",
        (personagem_selecionado,)
    )
    local_atual = cursor.fetchone()

    if not local_atual:
        print("Erro: Local atual do personagem não encontrado.")
        return

    local_atual_id = local_atual[0]

    # Consulta locais adjacentes usando a estrutura Norte, Sul, Leste, Oeste
    cursor.execute(
        """
        SELECT 
            A.Nome AS Atual,
            N.Nome AS Norte,
            S.Nome AS Sul,
            O.Nome AS Oeste,
            L.Nome AS Leste,
            N.IDLocal AS NorteID,
            S.IDLocal AS SulID,
            O.IDLocal AS OesteID,
            L.IDLocal AS LesteID
        FROM Local A
        LEFT JOIN Local N ON N.IDLocal = A.Norte
        LEFT JOIN Local S ON S.IDLocal = A.Sul
        LEFT JOIN Local O ON O.IDLocal = A.Oeste
        LEFT JOIN Local L ON L.IDLocal = A.Leste
        WHERE A.IDLocal = %s
        """,
        (local_atual_id,)
    )

    locais_adjacentes = cursor.fetchone()

    if not locais_adjacentes:
        print("\nNenhum local adjacente disponível.")
        return

    print("\nLocais Adjacentes:")
    atual, norte, sul, oeste, leste, norte_id, sul_id, oeste_id, leste_id = locais_adjacentes

    # Imprime os locais adjacentes
    print(f"Norte: {norte if norte else 'N/A'}")
    print(f"Sul: {sul if sul else 'N/A'}")
    print(f"Leste: {leste if leste else 'N/A'}")
    print(f"Oeste: {oeste if oeste else 'N/A'}")

    # Menu de movimentação
    while True:
        try:
            escolha = input("\nEscolha a direção para mover (Norte, Sul, Leste, Oeste) ou '0' para cancelar: ").capitalize()

            novo_id_local = None
            if escolha == '0':
                print("Movimentação cancelada.")
                return
            elif escolha == 'Norte' and norte:
                novo_id_local = norte_id
            elif escolha == 'Sul' and sul:
                novo_id_local = sul_id
            elif escolha == 'Leste' and leste:
                novo_id_local = leste_id
            elif escolha == 'Oeste' and oeste:
                novo_id_local = oeste_id
            else:
                print("Direção inválida. Tente novamente.")

            if novo_id_local:
                # Atualiza posição do personagem
                cursor.execute(
                    "UPDATE Personagem SET IDLocal = %s WHERE IDPersonagem = %s",
                    (novo_id_local, personagem_selecionado))
                conn.commit()

                print(f"\nMovido com sucesso para {escolha}: {norte if escolha == 'Norte' else sul if escolha == 'Sul' else leste if escolha == 'Leste' else oeste}")
                return

        except ValueError:
            print("Por favor, digite uma direção válida.")


# Menu principal
def menu_jogo(jogador):
    while True:
        print("\n--- Menu ---")
        if personagem_selecionado is None:
            print("1. Selecionar Personagem")
        else:
            print("1. Mapa")

        print("2. Sair")

        opcao = input("Escolha: ")

        if opcao == "1" and personagem_selecionado is None:
            SelecionarPersonagem(jogador)
        elif opcao == "1" and personagem_selecionado:
            Mapa()
        elif opcao == "2":
            print("Saindo...")
            break
        else:
            print("Opção inválida.")


# 🚀 Executar login
login()

# 🔒 Fechar conexão
cursor.close()
conn.close()