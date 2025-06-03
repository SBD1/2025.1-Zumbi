import psycopg2
import random

# Conexão com o banco
conn = psycopg2.connect(
    dbname="ZUmbi",
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
    nome = input("Email: ")
    senha = input("Senha: ")

    cursor.execute(
        'SELECT * FROM conta WHERE email = %s AND senha = %s',
        (nome, senha))
    jogador = cursor.fetchone()

    if jogador:
        print(f"\nBem-vindo, {nome}!\n")
        menu_jogo(jogador)
    else:
        print("Login inválido.")


# 🎭 Selecionar Personagem
def SelecionarPersonagem(jogador):
    global personagem_selecionado

    cursor.execute(
        'SELECT idpersonagem, nome FROM personagem WHERE idconta = %s',
        (jogador[0],))
    
    personagens = cursor.fetchall()

    if not personagens:
        print("Nenhum personagem encontrado. Crie um personagem primeiro.")
        personagem_selecionado = None
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
            SELECT p.nome, l.nome AS local_nome 
            FROM personagem p 
            JOIN locais l 
            ON l.coordenada_x = p.coordenada_x AND l.coordenada_y = p.coordenada_y 
            WHERE p.idpersonagem = %s
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

    # Consulta locais adjacentes
    cursor.execute(
        """
        -- Local ao NORTE (y + 1)
        SELECT 'Norte' AS direcao, L.nome, L.coordenada_x, L.coordenada_y
        FROM personagem P 
        JOIN locais L ON P.coordenada_x = L.coordenada_x 
                     AND P.coordenada_y + 1 = L.coordenada_y
        WHERE P.idpersonagem = %s

        UNION ALL

        -- Local ao SUL (y - 1)
        SELECT 'Sul' AS direcao, L.nome, L.coordenada_x, L.coordenada_y
        FROM personagem P 
        JOIN locais L ON P.coordenada_x = L.coordenada_x 
                     AND P.coordenada_y - 1 = L.coordenada_y
        WHERE P.idpersonagem = %s

        UNION ALL

        -- Local ao LESTE (x + 1)
        SELECT 'Leste' AS direcao, L.nome, L.coordenada_x, L.coordenada_y
        FROM personagem P 
        JOIN locais L ON P.coordenada_x + 1 = L.coordenada_x 
                     AND P.coordenada_y = L.coordenada_y
        WHERE P.idpersonagem = %s

        UNION ALL

        -- Local ao OESTE (x - 1)
        SELECT 'Oeste' AS direcao, L.nome, L.coordenada_x, L.coordenada_y
        FROM personagem P 
        JOIN locais L ON P.coordenada_x - 1 = L.coordenada_x 
                     AND P.coordenada_y = L.coordenada_y
        WHERE P.idpersonagem = %s
        """,
        (personagem_selecionado, personagem_selecionado, 
         personagem_selecionado, personagem_selecionado)
    )
    
    locais_adjacentes = cursor.fetchall()
    
    if not locais_adjacentes:
        print("\nNenhum local adjacente disponível.")
        return

    print("\nLocais Adjacentes:")
    for i, (direcao, nome_local, x, y) in enumerate(locais_adjacentes, 1):
        print(f"{i}. {direcao}: {nome_local}")

    # Menu de movimentação
    while True:
        try:
            escolha = input("\nEscolha o número do local para mover ou '0' para cancelar: ")
            
            if escolha == '0':
                print("Movimentação cancelada.")
                return
                
            escolha = int(escolha)
            if 1 <= escolha <= len(locais_adjacentes):
                direcao, nome_local, novo_x, novo_y = locais_adjacentes[escolha-1]
                
                # Atualiza posição do personagem
                cursor.execute(
                    "UPDATE personagem SET coordenada_x = %s, coordenada_y = %s WHERE idpersonagem = %s",
                    (novo_x, novo_y, personagem_selecionado))
                conn.commit()
                
                print(f"\nMovido com sucesso para {direcao}: {nome_local}")
                return
            else:
                print("Número inválido. Tente novamente.")
                
        except ValueError:
            print("Por favor, digite um número válido.")


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
        elif opcao == "3":
            print("Saindo...")
            break
        else:
            print("Opção inválida.")


# 🚀 Executar login
login()

# 🔒 Fechar conexão
cursor.close()
conn.close()