# Limpamos a tela para facilitar a visualização
Clear-Host

# Receber o local e armazenar em uma variável chamada Local
$Local = Read-Host "Informe o local onde quer criar a pasta"
# Receber o nome da pasta e armazenar na variável nomePasta
$nomePasta = Read-Host "Informe um nome para a pasta"
# Executar o comando de criação de pasta
New-Item -Path "$Local/$nomePasta" -ItemType "Directory"
# Mostrar mensagem de confirmação na tela
Write-Host "A pasta $nomePasta foi criada em $Local"