# Antes de começar, lembre-se de carregar a função disponivel em: 
# PreScan tamanhos.ps1

# Inicia o transcript
Start-Transcript
Get-Date

# Recebe os dados de um arquivo CSV, com a primeira coluna sendo o nome dos perfis 
# E a segunda o caminho do arquivo que vai ser analisado, conforme guia de compilação
$indice = 0
$Apps = Import-Csv -Path $caminhoCSV -delimiter ";"

# Para cada item faz o scan
foreach ($app in $Apps) {
    # Pega os dados
    $NomeApp = $Apps.Nome[$indice]
    $caminho = $Apps.Caminho[$indice]
    # Faz o scan
    Get-VeracodeAppSize $veracodeID $veracodeAPIkey $NomeApp $caminho
    Start-Sleep -s 20 # Aguarda 20 segundos entre cada execução
    ## Incrementa o indice
    $indice++
}

# Encerra o transcript
Get-Date
Stop-Transcript