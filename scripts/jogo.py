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

def SelecionarPersonagem(jogador):
    global personagem_selecionado

    cursor.execute(
        'SELECT IDPersonagem, Nome FROM Personagem WHERE IDConta = %s and vidaatual >0',
        (jogador[0],))

    personagens = cursor.fetchall()

    if not personagens:
        print("Nenhum personagem encontrado. Crie um personagem primeiro.")
        CriarPersonagem(jogador)  # Chama a função para criar personagem
        return

    print("\n👥 Seus Personagens:")
    for idx, (idpersonagem, nome) in enumerate(personagens, start=1):
        print(f"{idx}. {nome}")

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

def Mapa():
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado. Selecione um personagem primeiro.")
        return

    while True:
        # Consulta o local atual do personagem
        cursor.execute(
            """
            SELECT p.Nome, l.Nome, l.IDLocal
            FROM Personagem p 
            JOIN Local l 
            ON l.IDLocal = p.IDLocal 
            WHERE p.IDPersonagem = %s
            """,
            (personagem_selecionado,)
        )
        resultado = cursor.fetchone()

        if resultado:
            nome_personagem, local_nome, id_local = resultado
            print(f"\nLocal Atual: {local_nome}")
            print(f"Personagem: {nome_personagem}")
        else:
            print("Personagem não encontrado ou sem local definido.")
            return

        # Menu do mapa com nova opção
        print("\n--- Mapa ---")
        print("1. Movimentar")
        print("2. Verificar itens no local")
        print("3. Sair do Mapa")

        opcao = input("Escolha: ")

        if opcao == "1":
            Movimentar()
        elif opcao == "2":
            verificar_itens_no_local(id_local)
        elif opcao == "3":
            print("↩Saindo do mapa...")
            break
        else:
            print("Opção inválida.")

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

def ver_inventario():
    global personagem_selecionado
    
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return
    
    # Obtém o ID do inventário do personagem
    cursor.execute(
        "SELECT idinventario FROM inventario where idpersonagem = %s",
        (personagem_selecionado,))
    id_inventario = cursor.fetchone()[0]
    
    # Busca os itens no inventário
    cursor.execute(
        """
        SELECT ii.IDInstanciaItem, ci.Nome
        FROM Instancias_Itens ii
        JOIN Classeltens ci ON ii.IDClasseltens = ci.IDClasseltens
        WHERE ii.IDInventario = %s
        """,
        (id_inventario,))
    
    itens = cursor.fetchall()
    
    if not itens:
        print("\nSeu inventário está vazio.")
        return
    
    print("\n📦 Inventário:")
    for id_item_instancia, nome_item in itens:
        print(f"- {nome_item}")

def verificar_itens_no_local(id_local):
    global personagem_selecionado

    cursor.execute(
        """
       SELECT I.idinstanciaitem, C.nome FROM public.local_instancias_itens I
join instancias_itens II on II.idinstanciaitem = I.idinstanciaitem
join classeltens C on II.idclasseltens = C.idclasseltens
where idlocal = %s

        """,
        (id_local,)
    )
    itens_no_local = cursor.fetchall()

    if itens_no_local:
        print("\nVocê encontrou os seguintes itens neste local:")
        for id_instancia, nome_item in itens_no_local:
            print(f"- {nome_item} (ID Instância: {id_instancia})")
        
        coletar = input("\nDeseja coletar estes itens? (Y/N): ").upper()
        if coletar == 'Y':
            coletar_itens(itens_no_local)
    else:
        print("\nNão há itens para coletar neste local.")

def coletar_itens(itens_para_coletar):
    global personagem_selecionado

    # Obtém o ID do inventário do personagem
    cursor.execute(
        "SELECT IDInventario FROM Personagem WHERE IDPersonagem = %s",
        (personagem_selecionado,))
    id_inventario_personagem = cursor.fetchone()[0]

    for id_instancia_item, nome_item in itens_para_coletar:
        try:
            # Atualiza o IDInventario na tabela Instancias_Itens
            cursor.execute(
                "UPDATE Instancias_Itens SET IDInventario = %s WHERE IDInstanciaItem = %s",
                (id_inventario_personagem, id_instancia_item)
            )
            # Remove o item da tabela Local_Instancias_Itens
            cursor.execute(
                "DELETE FROM Local_Instancias_Itens WHERE IDInstanciaItem = %s",
                (id_instancia_item,)
            )
            conn.commit()
            print(f"Item '{nome_item}' coletado com sucesso!")
        except psycopg2.Error as e:
            conn.rollback()
            print(f"Erro ao coletar item '{nome_item}': {e}")


def combate():
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return

    # Pega local e vida atual do personagem
    cursor.execute("SELECT IDLocal, VidaAtual, Nome FROM Personagem WHERE IDPersonagem = %s", (personagem_selecionado,))
    resultado = cursor.fetchone()
    if not resultado:
        print("Personagem não encontrado.")
        return
    id_local, vida_personagem, nome_personagem = resultado

    # Busca todos os zumbis no local
    cursor.execute("""
         SELECT iz.IDInstanciaZumbi, iz.VidaAtual, tz.DanoBase, tz.nome
        FROM Instancia_Zumbi iz
        JOIN Local_Instancia_Zumbi liz ON liz.IDInstanciaZumbi = iz.IDInstanciaZumbi
        JOIN TipoZumbi tz ON tz.IDTipoZumbi = iz.IDTipoZumbi
        WHERE liz.IDLocal =%s and iz.vidaatual>0
    """, (id_local,))

    zumbis = cursor.fetchall()

    if not zumbis:
        print("Não há zumbis no local para combater.")
        return

    # Lista os zumbis para escolher
    print("\nZumbis no local:")
    for i, (id_zumbi,vidazumbi, dano, nome) in enumerate(zumbis, start=1):
        print(f"{i}. Zumbi {nome} | Vida: {vidazumbi} | Dano Base: {dano}")

    # Escolher zumbi para combater
    while True:
        try:
            escolha = int(input("Escolha o número do zumbi para combater (0 para cancelar): "))
            if escolha == 0:
                print("Combate cancelado.")
                return
            if 1 <= escolha <= len(zumbis):
                zumbi_selecionado = zumbis[escolha - 1]
                break
            else:
                print("Escolha inválida.")
        except ValueError:
            print("Digite um número válido.")

    id_zumbi, vida_zumbi, dano_zumbi, id_tipo_zumbi = zumbi_selecionado

    # Atributos do personagem (exemplo fixo, pode buscar no banco se quiser)
    ataque_personagem = 15
    defesa_personagem = 5

    print(f"\nIniciando combate com o Zumbi ID {id_zumbi} (Tipo {id_tipo_zumbi})!\n")

    while vida_personagem > 0 and vida_zumbi > 0:
        
        print(f"{nome_personagem} - Vida: {vida_personagem}")
        print(f"Zumbi {nome} - Vida: {vida_zumbi}")

        print("\n1. Atacar")
        print("2. Fugir")
        opcao = input("Escolha: ")

        if opcao == "1":
            dano_causado = max(0, ataque_personagem - random.randint(0, 3))
            vida_zumbi -= dano_causado
            print(f"Você causou {dano_causado} de dano no zumbi!")
            cursor.execute(""" UPDATE Instancia_Zumbi SET VidaAtual = %s WHERE IDInstanciaZumbi = %s """, (vida_zumbi, id_zumbi))
            conn.commit()

            if vida_zumbi <= 0:
                print("Zumbi derrotado!")
                conn.commit()
                break

            # Zumbi ataca
            dano_recebido = max(0, dano_zumbi - defesa_personagem)
            vida_personagem -= dano_recebido
            print(f"O zumbi causou {dano_recebido} de dano em você!")

            cursor.execute(
                "UPDATE Personagem SET VidaAtual = %s WHERE IDPersonagem = %s",
                (max(0, vida_personagem), personagem_selecionado)
            )
            conn.commit()

            if vida_personagem <= 0:
                print("Você morreu. Fim de jogo.")
                personagem_selecionado = None
                break

        elif opcao == "2":
            chance_fuga = random.randint(1, 100)
            if chance_fuga <= 50:
                print("Você fugiu do combate!")
                break
            else:
                print("Fuga falhou! O zumbi ataca!")
                dano_recebido = max(0, dano_zumbi - defesa_personagem)
                vida_personagem -= dano_recebido
                print(f"O zumbi causou {dano_recebido} de dano em você!")

                cursor.execute(
                    "UPDATE Personagem SET VidaAtual = %s WHERE IDPersonagem = %s",
                    (max(0, vida_personagem), personagem_selecionado)
                )
                conn.commit()

                if vida_personagem <= 0:
                    print("Você morreu. Fim de jogo.")
                    break
        else:
            print("Opção inválida.")

def menu_jogo(jogador):
    while True:
        print("\n--- Menu ---")
        if personagem_selecionado is None:
            print("1. Selecionar Personagem")
            print("2. Criar Personagem")
        else:
            print("1. Mapa")
            print("2. Ver Inventário")
            print("3. Combate")  # <<< Aqui

        print("4. Sair")

        opcao = input("Escolha: ")

        if opcao == "1" and personagem_selecionado is None:
            SelecionarPersonagem(jogador)
        elif opcao == "2" and personagem_selecionado is None: 
            CriarPersonagem(jogador)
        elif opcao == "1" and personagem_selecionado:
            Mapa()
        elif opcao == "2" and personagem_selecionado:
            ver_inventario()
        elif opcao == "3" and personagem_selecionado:
            combate()  # Chama o combate aqui
        elif opcao == "4":
            print("Saindo...")
            break
        else:
            print("Opção inválida.")

login()

cursor.close()
conn.close()