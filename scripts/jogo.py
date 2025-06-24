import psycopg2
import random
import os

# Conexão com o banco
conn = psycopg2.connect(
    dbname="Zumbi",
    user="postgres",
    password="",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

# Variável global para guardar o personagem selecionado
personagem_selecionado = None


def clear_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

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
            clear_terminal()
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
    clear_terminal()
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
                clear_terminal()
                return
            else:
                clear_terminal()
                print("Opção inválida. Tente novamente.")
             
        except ValueError:
            print("Digite um número válido.")
            
def CriarPersonagem(jogador):
    clear_terminal()
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
    clear_terminal()
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
    clear_terminal()
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
    clear_terminal()
    global personagem_selecionado
    
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return
    
    # Busca os itens no inventário com todas as informações
    cursor.execute(
        """
       SELECT 
    ii.IDInstanciaItem,
    c.tipos_itens AS TipoItem,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
        WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
        ELSE 'Desconhecido'
    END AS NomeItem,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Dano_maximo
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Dano_maximo
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Ganho_vida
        ELSE NULL
    END AS Valor,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN CONCAT('Munição: ', af.Munição)
        ELSE ''
    END AS Detalhe
FROM 
    Instancias_Itens ii
JOIN 
    Classeltens c ON c.IDClasseltens = ii.IDClasseltens
LEFT JOIN 
    ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    Medicamentos m ON m.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    Chaves ch ON ch.IDClasseltens = c.IDClasseltens
WHERE 
    ii.IDPersonagem = %s
ORDER BY
    c.tipos_itens, ii.IDInstanciaItem;

        """,
        (personagem_selecionado,))
    
    itens = cursor.fetchall()
    
    if not itens:
        print("\nSeu inventário está vazio.")
        return
    
    print("\n📦 Inventário:")
    print("-" * 40)
    
    for id_item, tipo, nome, valor, detalhe in itens:
        # Formata a exibição de acordo com o tipo de item
        if tipo == 'ArmaDeFogo':
            print(f"🔫 {nome} (Dano: {valor}) | {detalhe}")
        elif tipo == 'ArmaBranca':
            print(f"🔪 {nome} (Dano: {valor})")
        elif tipo == 'Medicamentos':
            print(f"💊 {nome} (Cura: {valor})")
        elif tipo == 'Chave':
            print(f"🔑 {nome}")
        else:
            print(f"❓ {nome} (Tipo desconhecido)")
    
    print("-" * 40)

def verificar_itens_no_local(id_local):
    clear_terminal()
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        input("\nPressione Enter para continuar...")
        return

    # Busca itens no local com informações completas
    cursor.execute(
        """
        SELECT 
            ii.IDInstanciaItem,
            c.tipos_itens AS TipoItem,
            CASE
                WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
                WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
                WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
                WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
                ELSE 'Desconhecido'
            END AS NomeItem,
            CASE
                WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Dano_maximo
                WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Dano_maximo
                WHEN c.tipos_itens = 'Medicamentos' THEN m.Ganho_vida
                ELSE NULL
            END AS Valor
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens
        LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens
        LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens
        WHERE ii.IDLocal = %s
          AND ii.IDPersonagem IS NULL
          AND ii.Localizacao = 'Local';
        """,
        (id_local,)
    )
    itens_no_local = cursor.fetchall()

    if not itens_no_local:
        print("\nNão há itens para coletar neste local.")
        input("\nPressione Enter para continuar...")
        return

    print("\n📦 Itens disponíveis no local:")
    for idx, (id_instancia, tipo, nome, valor) in enumerate(itens_no_local, start=1):
        if tipo == 'ArmaDeFogo':
            print(f"{idx}. 🔫 {nome} (Dano: {valor})")
        elif tipo == 'ArmaBranca':
            print(f"{idx}. 🔪 {nome} (Dano: {valor})")
        elif tipo == 'Medicamentos':
            print(f"{idx}. 💊 {nome} (Cura: {valor})")
        elif tipo == 'Chave':
            print(f"{idx}. 🔑 {nome}")
        else:
            print(f"{idx}. ❓ {nome}")

    print(f"\n0. Voltar (não coletar nada)")

    # Selecionar itens para coletar
    while True:
        try:
            escolhas = input("\nDigite os números dos itens que deseja coletar (separados por vírgula): ").strip()
            if escolhas == '0':
                return
            
            if not escolhas:
                print("Por favor, digite algum valor.")
                continue

            indices = []
            for i in escolhas.split(','):
                if i.strip().isdigit():
                    num = int(i.strip())
                    if 1 <= num <= len(itens_no_local):
                        indices.append(num)
                    else:
                        print(f"Índice inválido: {num}")
            
            if not indices:
                print("Nenhum item válido selecionado.")
                continue

            ids_para_coletar = [itens_no_local[i-1][0] for i in indices]

            # Executa a stored procedure
            cursor.execute(
                "SELECT coletar_itens(%s, %s::int[])",
                (personagem_selecionado, ids_para_coletar)
            )
            resultado = cursor.fetchone()
            conn.commit()

            clear_terminal()
            print(resultado[0])  # Mostra a mensagem da função coletar_itens
            break

        except (ValueError, IndexError):
            print("Entrada inválida. Digite números separados por vírgula.")
        except psycopg2.Error as e:
            conn.rollback()
            print(f"\n❌ Erro no banco de dados: {e}")
      
def selecionar_arma(personagem_id):
    cursor.execute("""
        SELECT 
            ii.IDInstanciaItem,
            c.tipos_itens AS TipoItem,
            CASE 
                WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
                WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
                ELSE NULL
            END AS NomeArma,
            CASE
                WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Dano_maximo
                WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Dano_maximo
                ELSE NULL
            END AS Dano
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
        WHERE ii.IDPersonagem = %s 
        AND c.tipos_itens IN ('ArmaDeFogo', 'ArmaBranca')
    """, (personagem_id,))
    
    armas = cursor.fetchall()
    
    if not armas:
        print("❌ Você não possui armas para usar no combate!")
        return None
    
    print("\n🔫 Armas disponíveis:")
    for i, (id_item, tipo, nome_arma, dano) in enumerate(armas, start=1):
        tipo_formatado = "Arma de fogo" if tipo == "ArmaDeFogo" else "Arma branca"
        print(f"{i}. {nome_arma} ({tipo_formatado}) | Dano: {dano}")
    
    while True:
        try:
            escolha = int(input("\nEscolha o número da arma que deseja usar (0 para cancelar): "))
            if escolha == 0:
                return None
            if 1 <= escolha <= len(armas):
                return armas[escolha - 1]  # Retorna (id_item, tipo, nome_arma, dano)
            print("Escolha inválida!")
        except ValueError:
            print("Digite um número válido!")

def combate():
    clear_terminal()
    global personagem_selecionado

    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return

    arma_escolhida = selecionar_arma(personagem_selecionado)
    if arma_escolhida is None:
        print("Combate cancelado ou nenhuma arma selecionada.")
        return

    id_item, tipo_arma, nome_arma, dano_arma = arma_escolhida
    print(f"\nVocê escolheu: {nome_arma} (Dano: {dano_arma})")

    # Obtém localização, vida e munição (caso seja arma de fogo)
    cursor.execute("""
        SELECT p.IDLocal, p.VidaAtual, p.Nome,
               CASE 
                   WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Munição
                   ELSE NULL
               END AS Municao
        FROM Personagem p
        LEFT JOIN Instancias_Itens ii ON ii.IDPersonagem = p.IDPersonagem AND ii.IDInstanciaItem = %s
        LEFT JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens
        WHERE p.IDPersonagem = %s
    """, (id_item, personagem_selecionado))

    resultado = cursor.fetchone()
    if not resultado:
        print("Personagem não encontrado.")
        return

    id_local, vida_personagem, nome_personagem, municao = resultado
    usando_arma_fogo = tipo_arma == 'ArmaDeFogo'
    infectado = False

    # Busca zumbis vivos no local
    cursor.execute("""
        SELECT iz.IDInstanciaZumbi, iz.VidaAtual, tz.DanoBase, tz.Nome, tz.IDTipoZumbi,
               zb.Resistencia_a_bala, zi.Taxa_Infeccao
        FROM Instancia_Zumbi iz
        JOIN TipoZumbi tz ON tz.IDTipoZumbi = iz.IDTipoZumbi
        LEFT JOIN Zumbi_Brutamonte zb ON zb.IDZumbiBrutamonte = tz.IDTipoZumbi
        LEFT JOIN Zumbi_Infeccioso zi ON zi.IDZumbiInfeccioso = tz.IDTipoZumbi
        WHERE iz.IDLocal = %s AND iz.VidaAtual > 0
    """, (id_local,))

    zumbis = cursor.fetchall()
    if not zumbis:
        print("\nNão há zumbis no local para combater.\n")
        return

    print("\nZumbis no local:")
    for i, (id_zumbi, vida_zumbi, dano_zumbi, nome_zumbi, id_tipo, resistencia, taxa_infeccao) in enumerate(zumbis, start=1):
        tipo_especial = ""
        if resistencia:
            tipo_especial = " [Brutamonte - Resistente a balas]"
        elif taxa_infeccao:
            tipo_especial = f" [Infeccioso - Taxa de infecção: {taxa_infeccao}%]"
        print(f"{i}. Zumbi {nome_zumbi} | Vida: {vida_zumbi} | Dano: {dano_zumbi}{tipo_especial}")

    # Escolha do zumbi
    while True:
        try:
            escolha = int(input("\nEscolha o número do zumbi para combater (0 para cancelar): "))
            if escolha == 0:
                print("\nCombate cancelado.")
                return
            if 1 <= escolha <= len(zumbis):
                zumbi_selecionado = zumbis[escolha - 1]
                break
            else:
                print("Escolha inválida.")
        except ValueError:
            print("Digite um número válido.")

    id_zumbi, vida_zumbi, dano_zumbi, nome_zumbi, _, resistencia, taxa_infeccao = zumbi_selecionado
    zumbi_brutamonte = resistencia is not None and resistencia
    zumbi_infeccioso = taxa_infeccao is not None and taxa_infeccao > 0

    print(f"\nIniciando combate com o Zumbi {nome_zumbi} usando {nome_arma}!")

    if zumbi_brutamonte and usando_arma_fogo:
        print("⚠️ Este zumbi Brutamonte é resistente a balas!")
    if zumbi_infeccioso:
        print(f"☣️ Este zumbi Infeccioso pode contaminar você (Taxa: {taxa_infeccao}%)!")

    while vida_personagem > 0 and vida_zumbi > 0:
        print(f"\n{nome_personagem} - Vida: {vida_personagem}")
        print(f"Zumbi {nome_zumbi} - Vida: {vida_zumbi}")
        if usando_arma_fogo:
            print(f"Munição: {municao}")
        if infectado:
            print("☣️ VOCÊ ESTÁ INFECTADO! Use um medicamento logo após o combate!")

        print("\n1. Atacar")
        print("2. Fugir")
        opcao = input("Escolha: ")

        if opcao == "1":
            if usando_arma_fogo and (municao is None or municao <= 0):
                print("Sem munição! Você não pode atacar com esta arma.")
                continue

            dano_causado = max(1, dano_arma - random.randint(0, 3))
            if zumbi_brutamonte and usando_arma_fogo:
                dano_causado = max(1, int(dano_causado * 0.2))
                print("O zumbi Brutamonte resiste ao dano de bala!")

            vida_zumbi -= dano_causado

            if usando_arma_fogo:
                municao -= 1
                cursor.execute("""
                    UPDATE ArmaDeFogo
                    SET Munição = %s
                    WHERE IDClasseltens = (
                        SELECT IDClasseltens
                        FROM Instancias_Itens
                        WHERE IDInstanciaItem = %s
                    )
                """, (municao, id_item))

            print(f"\nVocê causou {dano_causado} de dano no zumbi usando {nome_arma}!")
            cursor.execute("""
                UPDATE Instancia_Zumbi 
                SET VidaAtual = %s 
                WHERE IDInstanciaZumbi = %s
            """, (vida_zumbi, id_zumbi))
            conn.commit()
            clear_terminal()

            if vida_zumbi <= 0:
                print(f"Zumbi {nome_zumbi} derrotado!")
                if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao:
                    infectado = True
                    print(f"☣️ VOCÊ FOI INFECTADO pelo zumbi {nome_zumbi}!")
                break

            dano_recebido = max(1, dano_zumbi - random.randint(0, 3))
            if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao:
                infectado = True
                print("☣️ O zumbi infeccioso te contaminou!")

            vida_personagem -= dano_recebido
            print(f"O zumbi causou {dano_recebido} de dano em você!")

            cursor.execute("""
                UPDATE Personagem 
                SET VidaAtual = %s 
                WHERE IDPersonagem = %s
            """, (max(0, vida_personagem), personagem_selecionado))
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
                dano_recebido = max(1, dano_zumbi - random.randint(0, 3))
                if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao // 2:
                    infectado = True
                    print("☣️ O zumbi infeccioso te contaminou durante a fuga!")

                vida_personagem -= dano_recebido
                print(f"O zumbi causou {dano_recebido} de dano em você!")

                cursor.execute("""
                    UPDATE Personagem 
                    SET VidaAtual = %s 
                    WHERE IDPersonagem = %s
                """, (max(0, vida_personagem), personagem_selecionado))
                conn.commit()

                if vida_personagem <= 0:
                    print("Você morreu. Fim de jogo.")
                    personagem_selecionado = None
                    break
        else:
            print("Opção inválida.")

def info_personagem():
    clear_terminal()
    global personagem_selecionado
    
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return
    
    # Informações básicas do personagem
    cursor.execute("""
        SELECT p.Nome, p.VidaAtual, l.Nome AS LocalAtual
        FROM Personagem p
        JOIN Local l ON p.IDLocal = l.IDLocal
        WHERE p.IDPersonagem = %s
    """, (personagem_selecionado,))
    personagem = cursor.fetchone()
    
    if not personagem:
        print("Personagem não encontrado.")
        return
    
    nome, vida, local = personagem
    
    print(f"\n👤 INFORMAÇÕES DO PERSONAGEM: {nome}")
    print("═" * 50)
    print(f"❤️ Vida Atual: {vida}/100")
    print(f"📍 Local Atual: {local}")
    print("─" * 50)
    
    # Itens no inventário
    cursor.execute("""
       SELECT 
    c.tipos_itens AS TipoItem,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Nome
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Nome
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Nome
        WHEN c.tipos_itens = 'Chave' THEN ch.Nome_Chave
        ELSE 'Desconhecido'
    END AS NomeItem,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Dano_maximo
        WHEN c.tipos_itens = 'ArmaBranca' THEN ab.Dano_maximo
        WHEN c.tipos_itens = 'Medicamentos' THEN m.Ganho_vida
        ELSE NULL
    END AS Valor,
    CASE
        WHEN c.tipos_itens = 'ArmaDeFogo' THEN af.Munição
        ELSE NULL
    END AS Municao
FROM 
    Instancias_Itens ii
JOIN 
    Classeltens c ON c.IDClasseltens = ii.IDClasseltens
LEFT JOIN 
    ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    Medicamentos m ON m.IDClasseltens = c.IDClasseltens
LEFT JOIN 
    Chaves ch ON ch.IDClasseltens = c.IDClasseltens
WHERE 
    ii.IDPersonagem = %s
ORDER BY 
    c.tipos_itens;

    """, (personagem_selecionado,))
    
    itens = cursor.fetchall()
    
    print("\n🎒 INVENTÁRIO:")
    if itens:
        for tipo, nome, valor, municao in itens:
            if tipo == 'Arma de fogo':
                print(f"🔫 {nome} (Dano: {valor}, Munição: {municao})")
            elif tipo == 'Arma Branca':
                print(f"🔪 {nome} (Dano: {valor})")
            elif tipo == 'Medicamentos':
                print(f"💊 {nome} (Cura: {valor})")
            elif tipo == 'Chave':
                print(f"🔑 {nome}")
    else:
        print("Vazio")
    print("─" * 50)
    
    # Missões ativas
    cursor.execute("""
        SELECT m.Nome, m.Descricao, m.Status 
        FROM Personagem_Missao pm
        JOIN Missao m ON pm.IDMissao = m.IDMissao
        WHERE pm.IDPersonagem = %s
        ORDER BY m.Status
    """, (personagem_selecionado,))
    
    missoes = cursor.fetchall()
    
    print("\n📜 MISSÕES:")
    if missoes:
        for nome, descricao, status in missoes:
            print(f"• {nome} ({status})")
            print(f"        {descricao}")
    else:
        print("Nenhuma missão ativa")
    print("─" * 50)
    
def menu_jogo(jogador):
    clear_terminal()
    while True:
        print("\n--- Menu ---")
        if personagem_selecionado is None:
            print("1. Selecionar Personagem")
            print("2. Criar Personagem")
        else:
            print("1. Mapa")
            print("2. Ver Inventário")
            print("3. Combate")
            print("4. Informações do Personagem")  # Nova opção

        print("5. Sair")  # Aumentou para 5 opções

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
            combate()
        elif opcao == "4" and personagem_selecionado:  # Nova condição
            info_personagem()
        elif opcao == "5":
            print("Saindo...")
            break
        else:
            print("Opção inválida.")

clear_terminal()
login()

cursor.close()
conn.close() 