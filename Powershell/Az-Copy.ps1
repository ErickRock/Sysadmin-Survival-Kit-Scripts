# Configuracoes
$env:Path += ";C:\Users\Public\azcopy_windows_amd64_10.6.0"
$data = Get-Date -Format ddMMyyyy-hhmm
$pastazip = "$(pastaZipada)"
$pasta = $pastazip.replace(".zip","-$data.zip")
$urlConexao = ""
[int]$indice = 0

try {
    # Comprime a pasta
    Write-Host "Compriminto o arquivo"
    Compress-Archive -Path $(pastaDestino) -DestinationPath "$pasta"
    Write-Host "Carregando a pasta $pasta"
    azcopy copy "$pasta" "$urlConexao" --recursive=true

    # Pega as informacoes das pastas
    $pastas = Get-ChildItem -Recurse | ?{ $_.PSIsContainer }
    $totalPastas = $pastas.count
    [int]$indice = $totalPastas - 3
    # Remove o mais antigo
    if ($indice -ge 0) {
        $pastaAntiga = $pastas[$indice].Name
        Write-Host "Removendo a pasta: $pastaAntiga"
        Remove-Item –path $pastaAntiga –recurse
    } else {
        Write-Host "Nao existem pastas suficientes para uma remocao"
    }
}
catch {
    # Mostra mensagem de erro
    Write-Host "Erro ao fazer o procedimento"
    Write-Host "$_.Exception.Message"
}