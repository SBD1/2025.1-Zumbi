import psycopg2
import random
import os

# Conexão com o banco
conn = psycopg2.connect(
    dbname="Zumbi",
    user="postgres",
    password="felipe2910",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

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
                (email, senha, 1))
            conn.commit()
            print("Conta criada com sucesso!")
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
        CriarPersonagem(jogador)
        return
    print("\n👥 Seus Personagens:")
    for idx, (idpersonagem, nome) in enumerate(personagens, start=1):
        print(f"{idx}. {nome}")
    while True:
        try:
            opcao = int(input("\nDigite o número do personagem que deseja usar: "))
            if 1 <= opcao <= len(personagens):
                personagem_selecionado = personagens[opcao - 1][0]
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
    nome_personagem = input("Digite o nome do seu novo personagem: ").strip()
    if not nome_personagem:
        print("O nome do personagem não pode ser vazio!")
        input("Pressione Enter para continuar...")
        return
    try:
        # Cria o personagem na Recepção (IDLocal = 1) com 100 de vida
        cursor.execute(
            'INSERT INTO Personagem (Nome, VidaAtual, IDConta, IDLocal) VALUES (%s, %s, %s, %s) RETURNING IDPersonagem',
            (nome_personagem, 100, jogador[0], 1))
        id_personagem = cursor.fetchone()[0]
        # Dá um item inicial (exemplo: faca, IDClasseltens=2)
        cursor.execute('SELECT COALESCE(MAX(IDInstanciaItem), 0) + 1 FROM Instancias_Itens')
        novo_id_item = cursor.fetchone()[0]
        cursor.execute(
            'INSERT INTO Instancias_Itens (IDInstanciaItem, IDClasseltens, Localizacao, IDPersonagem, Municao) VALUES (%s, %s, %s, %s, %s)',
            (novo_id_item, 2, 'Personagem', id_personagem, None))
        conn.commit()
        print(f"\n✅ Personagem '{nome_personagem}' criado com sucesso!")
        print("Você recebeu uma faca como item inicial!")
        input("\nPressione Enter para continuar...")
        SelecionarPersonagem(jogador)
    except psycopg2.Error as e:
        conn.rollback()
        print(f"\n❌ Erro ao criar personagem: {e}")
        input("Pressione Enter para continuar...")

def Mapa():
    clear_terminal()
    global personagem_selecionado
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado. Selecione um personagem primeiro.")
        return
    while True:
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
            if id_local == 13:
                print("\n🎉 Parabéns! Você chegou ao Quarto da Filha e salvou sua filha! Fim do jogo!\n")
                input("Pressione Enter para sair...")
                exit(0)
        else:
            print("Personagem não encontrado ou sem local definido.")
            return
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
    cursor.execute(
        "SELECT IDLocal FROM Personagem WHERE IDPersonagem = %s",
        (personagem_selecionado,)
    )
    local_atual = cursor.fetchone()
    if not local_atual:
        print("Erro: Local atual do personagem não encontrado.")
        return
    local_atual_id = local_atual[0]
    cursor.execute(
        """
        SELECT 
            A.Nome AS Atual,
            N.Nome AS Norte, N.IDLocal AS NorteID, N.Precisa_Chave AS NorteChave,
            S.Nome AS Sul, S.IDLocal AS SulID, S.Precisa_Chave AS SulChave,
            O.Nome AS Oeste, O.IDLocal AS OesteID, O.Precisa_Chave AS OesteChave,
            L.Nome AS Leste, L.IDLocal AS LesteID, L.Precisa_Chave AS LesteChave
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
    atual, norte, norte_id, norte_chave, sul, sul_id, sul_chave, oeste, oeste_id, oeste_chave, leste, leste_id, leste_chave = locais_adjacentes
    print(f"Norte: {norte if norte else 'N/A'} {'(🔒)' if norte and norte_chave else ''}")
    print(f"Sul: {sul if sul else 'N/A'} {'(🔒)' if sul and sul_chave else ''}")
    print(f"Leste: {leste if leste else 'N/A'} {'(🔒)' if leste and leste_chave else ''}")
    print(f"Oeste: {oeste if oeste else 'N/A'} {'(🔒)' if oeste and oeste_chave else ''}")
    while True:
        try:
            escolha = input("\nEscolha a direção para mover (Norte, Sul, Leste, Oeste) ou '0' para cancelar: ").capitalize()
            novo_id_local = None
            precisa_chave = False
            nome_local = ""
            if escolha == '0':
                print("Movimentação cancelada.")
                return
            elif escolha == 'Norte' and norte:
                novo_id_local = norte_id
                precisa_chave = norte_chave
                nome_local = norte
            elif escolha == 'Sul' and sul:
                novo_id_local = sul_id
                precisa_chave = sul_chave
                nome_local = sul
            elif escolha == 'Leste' and leste:
                novo_id_local = leste_id
                precisa_chave = leste_chave
                nome_local = leste
            elif escolha == 'Oeste' and oeste:
                novo_id_local = oeste_id
                precisa_chave = oeste_chave
                nome_local = oeste
            else:
                print("Direção inválida. Tente novamente.")
                continue
            if novo_id_local:
                if precisa_chave:
                    print(f"\n⚠️ O local {nome_local} está trancado!")
                    cursor.execute(
                        """
                        SELECT 1 FROM Local_Chaves lc
                        JOIN Instancias_Itens ii ON ii.IDClasseltens = lc.IDChave
                        WHERE lc.IDLocal = %s AND ii.IDPersonagem = %s
                        """,
                        (novo_id_local, personagem_selecionado)
                    )
                    tem_chave = cursor.fetchone()
                    if not tem_chave:
                        print("Você não possui a chave necessária para acessar este local!")
                        continue
                    else:
                        print("🔑 Chave encontrada no inventário! Porta destrancada.")
                cursor.execute(
                    "UPDATE Personagem SET IDLocal = %s WHERE IDPersonagem = %s",
                    (novo_id_local, personagem_selecionado))
                conn.commit()
                print(f"\nMovido com sucesso para {escolha}: {nome_local}")
                return
        except ValueError:
            print("Por favor, digite uma direção válida.")
        except psycopg2.Error as e:
            conn.rollback()
            print(f"Erro ao mover personagem: {e}")

def ver_inventario():
    clear_terminal()
    global personagem_selecionado
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        return
    cursor.execute("""
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
            ii.Municao
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
        LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
        LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Chave'
        WHERE ii.IDPersonagem = %s
        ORDER BY c.tipos_itens, ii.IDInstanciaItem;
    """, (personagem_selecionado,))
    itens = cursor.fetchall()
    if not itens:
        print("\nSeu inventário está vazio.")
        return
    print("\n📦 Inventário:")
    print("-" * 40)
    for idx, (id_item, tipo, nome, valor, detalhe) in enumerate(itens, start=1):
        if tipo == 'ArmaDeFogo':
            print(f"{idx}. 🔫 {nome} (Dano: {valor}) | {detalhe}")
        elif tipo == 'ArmaBranca':
            print(f"{idx}. 🔪 {nome} (Dano: {valor})")
        elif tipo == 'Medicamentos':
            print(f"{idx}. 💊 {nome} (Cura: {valor})")
        elif tipo == 'Chave':
            print(f"{idx}. 🔑 {nome}")
        else:
            print(f"{idx}. ❓ {nome} (Tipo desconhecido)")
    print("0. Voltar")
    print("-" * 40)
    while True:
        try:
            escolha = int(input("Digite o número do item que deseja usar (0 para voltar): "))
            if escolha == 0:
                break
            if 1 <= escolha <= len(itens):
                id_item, tipo, nome, valor, _ = itens[escolha - 1]
                if tipo == 'Medicamentos':
                    cursor.execute("""
                        SELECT VidaAtual FROM Personagem WHERE IDPersonagem = %s
                    """, (personagem_selecionado,))
                    vida_atual = cursor.fetchone()[0]
                    nova_vida = min(100, vida_atual + valor)
                    cursor.execute("""
                        UPDATE Personagem SET VidaAtual = %s WHERE IDPersonagem = %s
                    """, (nova_vida, personagem_selecionado))
                    cursor.execute("""
                        DELETE FROM Instancias_Itens WHERE IDInstanciaItem = %s
                    """, (id_item,))
                    conn.commit()
                    print(f"\n✅ Você usou '{nome}' e recuperou {valor} de vida! Vida atual: {nova_vida}/100\n")
                    break
                else:
                    print("⚠️ Este item não pode ser usado diretamente.")
            else:
                print("Escolha inválida.")
        except ValueError:
            print("Digite um número válido.")

def verificar_itens_no_local(id_local):
    clear_terminal()
    global personagem_selecionado
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        input("\nPressione Enter para continuar...")
        return
    cursor.execute("""
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
            ii.Municao
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
        LEFT JOIN Medicamentos m ON m.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Medicamentos'
        LEFT JOIN Chaves ch ON ch.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'Chave'
        WHERE ii.IDLocal = %s
          AND ii.IDPersonagem IS NULL
          AND ii.Localizacao = 'Local';
    """, (id_local,))
    itens_no_local = cursor.fetchall()
    if not itens_no_local:
        print("\nNão há itens para coletar neste local.")
        input("\nPressione Enter para continuar...")
        return
    print("\n📦 Itens disponíveis no local:")
    for idx, (id_instancia, tipo, nome, valor, municao) in enumerate(itens_no_local, start=1):
        if tipo == 'ArmaDeFogo':
            print(f"{idx}. 🔫 {nome} (Dano: {valor}, Munição: {municao})")
        elif tipo == 'ArmaBranca':
            print(f"{idx}. 🔪 {nome} (Dano: {valor})")
        elif tipo == 'Medicamentos':
            print(f"{idx}. 💊 {nome} (Cura: {valor})")
        elif tipo == 'Chave':
            print(f"{idx}. 🔑 {nome}")
        else:
            print(f"{idx}. ❓ {nome}")
    print(f"\n0. Voltar (não coletar nada)")
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
            for i in indices:
                id_item = itens_no_local[i-1][0]
                cursor.execute("""
                    UPDATE Instancias_Itens 
                    SET 
                        IDPersonagem = %s, 
                        IDLocal = NULL,
                        Localizacao = 'Personagem'
                    WHERE IDInstanciaItem = %s
                """, (personagem_selecionado, id_item))
            conn.commit()
            print("\n✅ Itens coletados com sucesso!")
            input("Pressione Enter para continuar...")
            break
        except (ValueError, IndexError):
            print("Entrada inválida. Digite números separados por vírgula.")
        except psycopg2.Error as e:
            conn.rollback()
            print(f"\n❌ Erro no banco de dados: {e}")
            input("Pressione Enter para continuar...")

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
            END AS Dano,
            ii.Municao
        FROM Instancias_Itens ii
        JOIN Classeltens c ON c.IDClasseltens = ii.IDClasseltens
        LEFT JOIN ArmaDeFogo af ON af.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaDeFogo'
        LEFT JOIN ArmaBranca ab ON ab.IDClasseltens = c.IDClasseltens AND c.tipos_itens = 'ArmaBranca'
        WHERE ii.IDPersonagem = %s 
        AND c.tipos_itens IN ('ArmaDeFogo', 'ArmaBranca')
    """, (personagem_id,))
    armas = cursor.fetchall()
    if not armas:
        print("\n❌ Você não possui armas para usar no combate!")
        input("Pressione Enter para continuar...")
        return None
    print("\n🔫 Armas disponíveis:")
    for i, (id_item, tipo, nome_arma, dano, municao) in enumerate(armas, start=1):
        tipo_formatado = "Arma de fogo" if tipo == "ArmaDeFogo" else "Arma branca"
        if tipo == "ArmaDeFogo":
            print(f"{i}. 🔫 {nome_arma} ({tipo_formatado}) | Dano: {dano} | Munição: {municao}")
        else:
            print(f"{i}. 🔪 {nome_arma} ({tipo_formatado}) | Dano: {dano}")
    while True:
        try:
            escolha = input("\nEscolha o número da arma que deseja usar (0 para cancelar): ")
            if escolha == '0':
                return None
            escolha = int(escolha)
            if 1 <= escolha <= len(armas):
                arma_selecionada = armas[escolha - 1]
                id_item, tipo, nome_arma, dano, municao = arma_selecionada
                if tipo == "ArmaDeFogo" and (municao is None or municao <= 0):
                    print("\n⚠️ Esta arma não tem munição! Selecione outra arma.")
                    input("Pressione Enter para continuar...")
                    continue
                return arma_selecionada
            else:
                print("Escolha inválida! Digite um número entre 1 e", len(armas))
        except ValueError:
            print("Por favor, digite um número válido!")

def combate():
    clear_terminal()
    global personagem_selecionado, conn, cursor
    if personagem_selecionado is None:
        print("Nenhum personagem selecionado.")
        input("Pressione Enter para continuar...")
        return
    try:
        arma_escolhida = selecionar_arma(personagem_selecionado)
    except Exception as e:
        print(f"Erro ao selecionar arma: {e}")
        input("Pressione Enter para continuar...")
        return
    if arma_escolhida is None:
        print("Combate cancelado ou nenhuma arma selecionada.")
        input("Pressione Enter para continuar...")
        return
    try:
        id_item, tipo_arma, nome_arma, dano_arma, municao = arma_escolhida
    except Exception:
        print("Erro ao recuperar dados da arma.")
        input("Pressione Enter para continuar...")
        return
    print(f"\nVocê escolheu: {nome_arma} (Dano: {dano_arma})")
    try:
        cursor.execute("""
            SELECT p.IDLocal, p.VidaAtual, p.Nome, l.Nome AS NomeLocal
            FROM Personagem p
            JOIN Local l ON p.IDLocal = l.IDLocal
            WHERE p.IDPersonagem = %s
        """, (personagem_selecionado,))
        resultado = cursor.fetchone()
    except Exception as e:
        print(f"Erro ao buscar personagem: {e}")
        input("Pressione Enter para continuar...")
        return
    if not resultado:
        print("Personagem não encontrado.")
        input("Pressione Enter para continuar...")
        return
    id_local, vida_personagem, nome_personagem, nome_local = resultado
    usando_arma_fogo = tipo_arma == 'ArmaDeFogo'
    infectado = False
    if usando_arma_fogo and (municao is None or municao <= 0):
        print("Esta arma não tem munição! Selecione outra arma.")
        input("Pressione Enter para continuar...")
        return
    try:
        cursor.execute("""
            SELECT iz.IDInstanciaZumbi, iz.VidaAtual, COALESCE(zb.DanoBase, zi.DanoBase, zc.DanoBase, 10), tz.Nome, tz.IDTipoZumbi,
                   zb.Resistencia_a_bala, zi.Taxa_Infeccao
            FROM Instancia_Zumbi iz
            JOIN TipoZumbi tz ON tz.IDTipoZumbi = iz.IDTipoZumbi
            LEFT JOIN Zumbi_Brutamonte zb ON zb.IDZumbiBrutamonte = tz.IDTipoZumbi
            LEFT JOIN Zumbi_Infeccioso zi ON zi.IDZumbiInfeccioso = tz.IDTipoZumbi
            LEFT JOIN Zumbi_Comum zc ON zc.IDZumbiComum = tz.IDTipoZumbi
            WHERE iz.IDLocal = %s AND iz.VidaAtual > 0
        """, (id_local,))
        zumbis = cursor.fetchall()
    except Exception as e:
        print(f"Erro ao buscar zumbis: {e}")
        input("Pressione Enter para continuar...")
        return
    if not zumbis:
        print(f"\nNão há zumbis no local ({nome_local}) para combater.")
        input("Pressione Enter para continuar...")
        return
    print(f"\nZumbis em {nome_local}:")
    for i, (id_zumbi, vida_zumbi, dano_zumbi, nome_zumbi, id_tipo, resistencia, taxa_infeccao) in enumerate(zumbis, start=1):
        tipo_especial = ""
        if resistencia:
            tipo_especial = " [Brutamonte - Resistente a balas]"
        elif taxa_infeccao:
            tipo_especial = f" [Infeccioso - Taxa de infecção: {taxa_infeccao}%]"
        print(f"{i}. Zumbi {nome_zumbi} | Vida: {vida_zumbi} | Dano: {dano_zumbi}{tipo_especial}")
    while True:
        try:
            escolha = input("\nEscolha o número do zumbi para combater (0 para cancelar): ")
            if escolha == '0':
                print("\nCombate cancelado.")
                input("Pressione Enter para continuar...")
                return
            escolha = int(escolha)
            if 1 <= escolha <= len(zumbis):
                zumbi_selecionado = zumbis[escolha - 1]
                break
            else:
                print(f"Escolha inválida. Digite um número entre 1 e {len(zumbis)} ou 0 para cancelar.")
        except ValueError:
            print("Por favor, digite um número válido.")
    id_zumbi, vida_zumbi, dano_zumbi, nome_zumbi, _, resistencia, taxa_infeccao = zumbi_selecionado
    zumbi_brutamonte = bool(resistencia)
    zumbi_infeccioso = taxa_infeccao is not None and taxa_infeccao > 0
    print(f"\nIniciando combate com o Zumbi {nome_zumbi} usando {nome_arma}!")
    if zumbi_brutamonte and usando_arma_fogo:
        print("⚠️ Este zumbi Brutamonte é resistente a balas!")
    if zumbi_infeccioso:
        print(f"☣️ Este zumbi Infeccioso pode contaminar você (Taxa: {taxa_infeccao}%!)")
    input("Pressione Enter para começar o combate...")
    clear_terminal()
    while vida_personagem > 0 and vida_zumbi > 0:
        print(f"\n{nome_personagem} - Vida: {vida_personagem}/100")
        print(f"Zumbi {nome_zumbi} - Vida: {vida_zumbi}")
        if usando_arma_fogo:
            print(f"Munição: {municao}")
        if infectado:
            print("☣️ VOCÊ ESTÁ INFECTADO! Use um medicamento logo após o combate!")
        print("\n1. Atacar")
        print("2. Fugir")
        opcao = input("Escolha: ").strip()
        if opcao == "1":
            if usando_arma_fogo and municao <= 0:
                print("\nSem munição! Você não pode atacar com esta arma.")
                input("Pressione Enter para continuar...")
                clear_terminal()
                continue
            dano_causado = max(1, dano_arma - random.randint(0, 3))
            if zumbi_brutamonte and usando_arma_fogo:
                dano_causado = max(1, int(dano_causado * 0.2))
                print("\nO zumbi Brutamonte resiste ao dano de bala!")
            vida_zumbi -= dano_causado
            if usando_arma_fogo:
                municao -= 1
                try:
                    cursor.execute("""
                        UPDATE Instancias_Itens 
                        SET Municao = %s 
                        WHERE IDInstanciaItem = %s
                    """, (municao, id_item))
                    conn.commit()
                except Exception as e:
                    print(f"Erro ao atualizar munição: {e}")
            print(f"\nVocê causou {dano_causado} de dano no zumbi usando {nome_arma}!")
            try:
                cursor.execute("""
                    UPDATE Instancia_Zumbi 
                    SET VidaAtual = %s 
                    WHERE IDInstanciaZumbi = %s
                """, (max(0, vida_zumbi), id_zumbi))
                conn.commit()
            except Exception as e:
                print(f"Erro ao atualizar vida do zumbi: {e}")
            if vida_zumbi <= 0:
                print(f"\nZumbi {nome_zumbi} derrotado!")
                if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao:
                    infectado = True
                    print(f"☣️ VOCÊ FOI INFECTADO pelo zumbi {nome_zumbi}!")
                input("Pressione Enter para continuar...")
                break
            dano_recebido = max(1, dano_zumbi - random.randint(0, 3))
            if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao:
                infectado = True
                print("\n☣️ O zumbi infeccioso te contaminou!")
            vida_personagem -= dano_recebido
            print(f"\nO zumbi causou {dano_recebido} de dano em você!")
            try:
                cursor.execute("""
                    UPDATE Personagem 
                    SET VidaAtual = %s 
                    WHERE IDPersonagem = %s
                """, (max(0, vida_personagem), personagem_selecionado))
                conn.commit()
            except Exception as e:
                print(f"Erro ao atualizar vida do personagem: {e}")
            if vida_personagem <= 0:
                print("\nVocê morreu. Fim de jogo.")
                personagem_selecionado = None
                input("Pressione Enter para continuar...")
                break
            input("Pressione Enter para continuar...")
            clear_terminal()
        elif opcao == "2":
            chance_fuga = random.randint(1, 100)
            if chance_fuga <= 50:
                print("\nVocê fugiu do combate!")
                input("Pressione Enter para continuar...")
                break
            else:
                print("\nFuga falhou! O zumbi ataca!")
                dano_recebido = max(1, dano_zumbi - random.randint(0, 3))
                if zumbi_infeccioso and random.randint(1, 100) <= taxa_infeccao // 2:
                    infectado = True
                    print("☣️ O zumbi infeccioso te contaminou durante a fuga!")
                vida_personagem -= dano_recebido
                print(f"O zumbi causou {dano_recebido} de dano em você!")
                try:
                    cursor.execute("""
                        UPDATE Personagem 
                        SET VidaAtual = %s 
                        WHERE IDPersonagem = %s
                    """, (max(0, vida_personagem), personagem_selecionado))
                    conn.commit()
                except Exception as e:
                    print(f"Erro ao atualizar vida do personagem na fuga: {e}")
                if vida_personagem <= 0:
                    print("\nVocê morreu. Fim de jogo.")
                    personagem_selecionado = None
                    input("Pressione Enter para continuar...")
                    break
                input("Pressione Enter para continuar...")
                clear_terminal()
        else:
            print("\nOpção inválida.")
            input("Pressione Enter para continuar...")
            clear_terminal()
    if infectado:
        print("\n⚠️ Atenção: Você foi infectado! Use um medicamento o quanto antes!")
        input("Pressione Enter para continuar...")

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
        print("0. Sair")
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
        elif opcao == "0":
            print("Saindo...")
            break
        else:
            print("Opção inválida.")

clear_terminal()
login()
cursor.close()
conn.close() 