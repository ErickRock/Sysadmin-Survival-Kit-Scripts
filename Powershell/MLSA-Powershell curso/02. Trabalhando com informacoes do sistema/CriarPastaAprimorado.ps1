# Limpamos a tela para facilitar a visualização
Clear-Host

# Receber o local e armazenar em uma variável chamada Local
$Local = Read-Host "Informe o local onde quer criar a pasta"
# Receber o nome da pasta e armazenar na variável nomePasta
$nomePasta = Read-Host "Informe um nome para a pasta"
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