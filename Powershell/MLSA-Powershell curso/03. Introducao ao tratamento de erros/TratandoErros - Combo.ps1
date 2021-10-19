# Limpamos a tela para facilitar a visualização
Clear-Host

# Receber o local e armazenar em uma variável chamada Local
$Local = Read-Host "Informe o local onde quer criar a pasta"
# Receber o nome da pasta e armazenar na variável nomePasta
$nomePasta = Read-Host "Informe um nome para a pasta"

try {
    # Vamos começar com as validações
    $listaPastas = Get-ChildItem -Path $Local -Directory # Recebemos todas as pastas dentro de um caminho, junto com todas as informações dela
    # Como podemos ter varias pastas, teremos que criar um loop, verificando item a item de nossa lista
    foreach ($pasta in $listaPastas) {
        $pasta = $pasta.name # Como queremos validar apenas o nome da pasta, utilizaremos apenas a propriedade NAME
        # Para compararmos valores, utilizamos o parametro -eq
        if ($nomePasta -eq $pasta) {
            $pastaValidacao = "Existe" # Se encontrarmos uma pasta com o mesmo nome, atribuimos o valor Existe para nossa variavel de validacao
        }
    }
}
catch {
    # Recebemos a mensagem de erro e armazenamos em uma variavel
    $mensagemErro = $_.Exception.Message
    # Limpamos a tela e exibimos a mensagem de erro
    Clear-Host
    Write-Host "Erro ao tentar criar a pasta $nomePasta"
    Write-Host "$mensagemErro"
    Pause # Utilizamos isso para aguardarmos um retorno do usuario
    Exit # Encerramos o terminal
}

# Se ela já existe, exibimos uma mensagem de erro
if ($pastaValidacao -eq "Existe") {
    # Informamos que a pasta já existe
    Clear-Host # Limpamos a tela para deixar mais bonito
    Write-Host "A pasta $nomePasta já existe no caminho $Local"
} 
# Se a pasta nao existe, executamos o bloco de codigo
else {
    # Executar o comando de criação de pasta
    New-Item -Path "$Local/$nomePasta" -ItemType "Directory"
    # Mostrar mensagem de confirmação na tela
    Clear-Host # Limpamos a tela para deixar mais bonito
    Write-Host "A pasta $nomePasta foi criada em $Local"
}