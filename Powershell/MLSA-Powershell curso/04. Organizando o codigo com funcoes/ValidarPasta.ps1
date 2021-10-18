# Funcao para validar as pastas
function Validar-Pasta {
    param (
        # Aqui definimos qual a posicao e se é obrigatorio ou nao o parametro
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