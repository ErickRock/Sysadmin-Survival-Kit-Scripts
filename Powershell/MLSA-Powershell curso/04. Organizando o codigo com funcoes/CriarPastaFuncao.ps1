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

    # Se ela já existe, exibimos uma mensagem de erro
    if ($pastaValidacao) {
        # Informamos que a pasta já existe
        Clear-Host # Limpamos a tela para deixar mais bonito
        Write-Host "A pasta $nomePasta já existe no caminho $Local"
    } 
    # Se a pasta existe, executamos o bloco de codigo
    else {
        # Executar o comando de criação de pasta
        New-Item -Path "$Local/$nomePasta" -ItemType "Directory"
        # Mostrar mensagem de confirmação na tela
        Clear-Host # Limpamos a tela para deixar mais bonito
        Write-Host "A pasta $nomePasta foi criada em $Local"
    }
}

# Limpamos a tela para facilitar a visualização
Clear-Host

# Receber o local e armazenar em uma variável chamada Local
$Local = Read-Host "Informe o local onde quer criar a pasta"
# Receber o nome da pasta e armazenar na variável nomePasta
$nomePasta = Read-Host "Informe um nome para a pasta"
# Agora vamos utilizar nossa funcao
Validar-Pasta $Local $nomePasta # Aqui a ordem é importante, como definimos que o primeiro seria o Local, temos que colocar primeiro ele e depois o nome da pasta