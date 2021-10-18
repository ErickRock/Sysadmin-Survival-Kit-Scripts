# Para organizar nosso script, vamos manter as funcoes na parte de cima do codigo
# É possivel, diria até que recomendavel, que crie um modulo com as funcoes, mas isso veremos depois

# Funcao para validar as pastas
function Validar-Pasta {
    param (
        # Aqui definimos qual a posicao e se é obrigatorio ou nao o parametro
        # O contador de posicoes comeca em 0, é importante lembrar disso
        [parameter(position=0,Mandatory=$True)]
        $Local, # Utilizamos a virgula para fazer a separacao quando utilizamos mais de um parametro
        [parameter(position=1,Mandatory=$True)]
        $nomePasta # O ultimo nao precisa de nada
    )
    # Validamos se o caminho existe, salvando a resposta em uma variavel
    $pastaValidacao = Test-Path -Path "$Local/$nomePasta"

    # Como agora teremos varias pastas, nao vamos limpar a tela
    # Vamos criar uma identificacao para saber com o que estamos trabalhando
    Write-Host "Trabalhando com a pasta: $nomePasta"

    # Se ela já existe, exibimos uma mensagem de erro
    if ($pastaValidacao) {
        # Informamos que a pasta já existe
        Write-Host "A pasta $nomePasta já existe no caminho $Local"
    } 
    # Se a pasta existe, executamos o bloco de codigo
    else {
        # Executar o comando de criação de pasta
        $esconderRetorno = New-Item -Path "$Local/$nomePasta" -ItemType "Directory" # Vamos jogar isso numa variavel para nao aparecer o retorno padrao na tela
        # Mostrar mensagem de confirmação na tela
        Write-Host "A pasta $nomePasta foi criada em $Local"
    }
}

# Funcao para receber a lista e o caminho das pastas
function Novas-Pastas {
    param (
        [parameter(position=0,Mandatory=$True)]
        $Local, # Utilizamos a virgula para fazer a separacao quando utilizamos mais de um parametro
        [parameter(position=1,Mandatory=$True)]
        $caminhoLista # O ultimo nao precisa de nada
    )
    # Recebemos os valores do arquivo
    $listaNomes = Get-Content -Path $caminhoLista
    # Vamos criar o loop (Indice dentro da lista)
    foreach ($nomePasta in $listaNomes) {
        Validar-Pasta $Local $nomePasta # Utilizamos nossa funcao para criar pastas
    }
}

# Limpamos a tela para facilitar a visualização
Clear-Host
# Receber o local e armazenar em uma variável chamada Local
$Local = Read-Host "Informe o local onde quer criar as pastas"
# Receber o caminho do arquivo com a lista de nomes
$caminhoLista = Read-Host "Informe o local onde esta a lista (ex: C:\Temp\nomes.txt)"
# Fazemos o procedimento, informando os parametros conforme definidos na funcao
Novas-Pastas $Local $caminhoLista