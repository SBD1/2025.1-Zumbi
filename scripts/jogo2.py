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

# Função para criar conta
def criar_conta():
    print("\n--- Criação de Conta ---")
    while True:
        email = input("Email: ")
        senha = input("Senha: ")
        
        # Verifica se o email já existe
        cursor.execute('SELECT * FROM conta WHERE email = %s', (email,))
        if cursor.fetchone():
            print("Este email já está em uso. Tente outro.")
            continue
        
        try:
            cursor.execute(
                'INSERT INTO conta (email, senha, status) VALUES (%s, %s, %s) RETURNING idconta',
                (email, senha, 1)  # status 1 = ativo
            )
            id_conta = cursor.fetchone()[0]
            conn.commit()
            
            print("\nConta criada com sucesso!")
            print("Vamos criar seu primeiro personagem.")
            criar_personagem(id_conta)
            return id_conta
            
        except psycopg2.Error as e:
            print(f"Erro ao criar conta: {e}")
            conn.rollback()
            return None

# Função para criar personagem
def criar_personagem(id_conta):
    print("\n--- Criação de Personagem ---")
    nome = input("Nome do personagem: ")
    
    # Cria um inventário para o personagem
    cursor.execute(
        'INSERT INTO inventario (capacidademaxima) VALUES (%s) RETURNING idinventario',
        (20,)  # Capacidade máxima de 20 itens
    )
    id_inventario = cursor.fetchone()[0]
    
    # Cria o personagem com valores iniciais
    cursor.execute(
        '''
        INSERT INTO personagem 
        (nome, nivel, vidamaxima, vidaatual, idconta, idinventario, coordenada_x, coordenada_y) 
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s) 
        RETURNING idpersonagem
        ''',
        (nome, 1, 100, 100, id_conta, id_inventario, 0, 0)  # Posição inicial (0,0)
    )
    id_personagem = cursor.fetchone()[0]
    conn.commit()
    
    print(f"\nPersonagem '{nome}' criado com sucesso!")
    return id_personagem

# Função de login
def login():
    while True:
        print("\nVocê possui conta? (Y/N)")
        opcao = input().upper()
        
        if opcao == 'Y':
            email = input("Email: ")
            senha = input("Senha: ")

            cursor.execute(
                'SELECT * FROM conta WHERE email = %s AND senha = %s',
                (email, senha))
            jogador = cursor.fetchone()

            if jogador:
                print(f"\nBem-vindo, {email}!")
                menu_jogo(jogador)
                break
            else:
                print("Login inválido. Tente novamente.")
                
        elif opcao == 'N':
            id_conta = criar_conta()
            if id_conta:
                cursor.execute('SELECT * FROM conta WHERE idconta = %s', (id_conta,))
                jogador = cursor.fetchone()
                menu_jogo(jogador)
                break
        else:
            print("Opção inválida. Digite Y ou N.")

# 🎭 Selecionar Personagem
def SelecionarPersonagem(jogador):
    global personagem_selecionado

    cursor.execute(
        'SELECT idpersonagem, nome FROM personagem WHERE idconta = %s',
        (jogador[0],))
    
    personagens = cursor.fetchall()

    if not personagens:
        print("Nenhum personagem encontrado. Deseja criar um? (Y/N)")
        opcao = input().upper()
        if opcao == 'Y':
            criar_personagem(jogador[0])
            # Recarrega a lista de personagens
            cursor.execute(
                'SELECT idpersonagem, nome FROM personagem WHERE idconta = %s',
                (jogador[0],))
            personagens = cursor.fetchall()
        else:
            personagem_selecionado = None
            return

    print("\n👥 Seus Personagens:")
    for idx, (idpersonagem, nome) in enumerate(personagens, start=1):
        print(f"{idx}. {nome} (ID: {idpersonagem})")

    while True:
        try:
            opcao = int(input("\nDigite o número do personagem que deseja usar (ou 0 para cancelar): "))
            if opcao == 0:
                return
            if 1 <= opcao <= len(personagens):
                personagem_selecionado = personagens[opcao - 1][0]  # idpersonagem
                print(f"\nPersonagem '{personagens[opcao - 1][1]}' selecionado!")
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
            print("Personagem não está em um local válido. Movendo para posição inicial...")
            cursor.execute(
                "UPDATE personagem SET coordenada_x = 0, coordenada_y = 0 WHERE idpersonagem = %s",
                (personagem_selecionado,))
            conn.commit()
            continue

        # Menu do mapa
        print("\n--- Mapa ---")
        print("1. Movimentar")
        print("2. Ver Inventário")
        print("3. Sair do Mapa")

        opcao = input("Escolha: ")

        if opcao == "1":
            Movimentar()
        elif opcao == "2":
            ver_inventario()
        elif opcao == "3":
            print("↩ Saindo do mapa...")
            break
        else:
            print("Opção inválida.")

# Função para ver inventário
def ver_inventario():
    global personagem_selecionado
    
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return
    
    # Obtém o ID do inventário do personagem
    cursor.execute(
        "SELECT idinventario FROM personagem WHERE idpersonagem = %s",
        (personagem_selecionado,))
    id_inventario = cursor.fetchone()[0]
    
    # Busca os itens no inventário
    cursor.execute(
        """
        SELECT ii.idinstanciaitens, ii.quantidade, 
               CASE 
                   WHEN ii.tipoitem = 'ArmaBranca' THEN ab.nome
                   WHEN ii.tipoitem = 'Arma_de_Fogo' THEN af.nome
               END AS nome_item,
               ii.tipoitem
        FROM instanciaitens ii
        LEFT JOIN armabranca ab ON ii.tipoitem = 'ArmaBranca' AND ii.iditem = ab.idarma
        LEFT JOIN arma_de_fogo af ON ii.tipoitem = 'Arma_de_Fogo' AND ii.iditem = af.idarma
        WHERE ii.idinventario = %s
        """,
        (id_inventario,))
    
    itens = cursor.fetchall()
    
    if not itens:
        print("\nSeu inventário está vazio.")
        return
    
    print("\n📦 Inventário:")
    for id_item, quantidade, nome, tipo in itens:
        print(f"- {nome} ({tipo}) x{quantidade}")

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
                
                # Verifica se há itens no novo local
                verificar_itens_no_local(novo_x, novo_y)
                return
            else:
                print("Número inválido. Tente novamente.")
                
        except ValueError:
            print("Por favor, digite um número válido.")

# Função para verificar itens no local
def verificar_itens_no_local(x, y):
    cursor.execute(
        """
        SELECT ii.idinstanciaitens, ii.quantidade, 
               CASE 
                   WHEN ii.tipoitem = 'ArmaBranca' THEN ab.nome
                   WHEN ii.tipoitem = 'Arma_de_Fogo' THEN af.nome
               END AS nome_item,
               ii.tipoitem
        FROM aparecemem_itens ai
        JOIN instanciaitens ii ON ai.idinstanciaitens = ii.idinstanciaitens
        LEFT JOIN armabranca ab ON ii.tipoitem = 'ArmaBranca' AND ii.iditem = ab.idarma
        LEFT JOIN arma_de_fogo af ON ii.tipoitem = 'Arma_de_Fogo' AND ii.iditem = af.idarma
        JOIN locais l ON ai.idlocal = l.idlocal
        WHERE l.coordenada_x = %s AND l.coordenada_y = %s
        """,
        (x, y))
    
    itens = cursor.fetchall()
    
    if itens:
        print("\nVocê encontrou os seguintes itens neste local:")
        for id_item, quantidade, nome, tipo in itens:
            print(f"- {nome} ({tipo}) x{quantidade}")
        
        coletar = input("\nDeseja coletar estes itens? (Y/N): ").upper()
        if coletar == 'Y':
            coletar_itens(itens, x, y)

# Função para coletar itens
def coletar_itens(itens, x, y):
    global personagem_selecionado
    
    # Obtém o ID do inventário do personagem
    cursor.execute(
        "SELECT idinventario FROM personagem WHERE idpersonagem = %s",
        (personagem_selecionado,))
    id_inventario = cursor.fetchone()[0]
    
    for id_item, quantidade, nome, tipo in itens:
        try:
            # Verifica se já tem o item no inventário
            cursor.execute(
                """
                SELECT idinstanciaitens FROM instanciaitens 
                WHERE idinventario = %s AND tipoitem = %s AND iditem = %s
                """,
                (id_inventario, tipo, id_item))
            existing_item = cursor.fetchone()
            
            if existing_item:
                # Atualiza a quantidade
                cursor.execute(
                    """
                    UPDATE instanciaitens 
                    SET quantidade = quantidade + %s 
                    WHERE idinstanciaitens = %s
                    """,
                    (quantidade, existing_item[0]))
            else:
                # Insere novo item
                cursor.execute(
                    """
                    INSERT INTO instanciaitens 
                    (quantidade, idinventario, tipoitem, iditem) 
                    VALUES (%s, %s, %s, %s)
                    """,
                    (quantidade, id_inventario, tipo, id_item))
            
            # Remove o item do local
            cursor.execute(
                "DELETE FROM aparecemem_itens WHERE idinstanciaitens = %s",
                (id_item,))
            
            conn.commit()
            print(f"Item {nome} coletado com sucesso!")
            
        except psycopg2.Error as e:
            print(f"Erro ao coletar item {nome}: {e}")
            conn.rollback()

# Menu principal
def menu_jogo(jogador):
    global personagem_selecionado
    
    while True:
        print("\n--- Menu Principal ---")
        print("1. Personagens")
        print("2. Mapa")
        print("3. Sair")

        opcao = input("Escolha: ")

        if opcao == "1":
            SelecionarPersonagem(jogador)
        elif opcao == "2":
            if personagem_selecionado:
                Mapa()
            else:
                print("Selecione um personagem primeiro.")
        elif opcao == "3":
            print("Saindo do jogo...")
            break
        else:
            print("Opção inválida.")

# 🚀 Executar login
login()

# 🔒 Fechar conexão
cursor.close()
conn.close()