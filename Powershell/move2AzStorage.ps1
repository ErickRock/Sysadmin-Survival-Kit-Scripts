# Move to Az Storage
# ivo Dias

# Instala modulo
Install-Module Az.Storage -Confirm:$false -Force -AllowClobber
Import-Module Az.Storage -Force

# Variaveis do Pipeline do Az DevOps
$prefixo = "$(prefixo)"
$pastazip = "$(pastaZipada)"
$pastaDestino = "$(pastaDestino)"
$ambiente = "$(Release.EnvironmentName)"
$container = "$(container)"
$chaveAcesso = "$(chaveAcesso)"
$chaveSAS = "$(chaveSAS)"

# Configuracoes
$env:Path += ";C:\Users\Public\azcopy_windows_amd64_10.6.0"
$data = Get-Date -Format ddMMyyyy-hhmm
$pasta = $pastazip.replace(".zip","-$data.zip")
$prefixo = $prefixo.ToLower()
$container += $ambiente
$urlConexao = "https://$container.blob.core.windows.net/" + $container + "$chaveSAS"

# Procedimento
try {
    # Conecta no Azure
    $contexto = New-AzStorageContext -StorageAccountName "$container" -StorageAccountKey $chaveAcesso

    # Comprime a pasta
    Write-Host "Compriminto o arquivo"
    Compress-Archive -Path $pastaDestino -DestinationPath "$pasta"
    Write-Host "Carregando a pasta $pasta"
    azcopy copy "$pasta" "$urlConexao" --recursive=true

    # Pega as informacoes das pastas
    $pastas = Get-AzStorageBlob -Container "$container" -Blob "*$prefixo*" -Context $contexto
    $totalPastas = $pastas.count
    [int]$indice = $totalPastas - 3

    # Remove o mais antigo
    if ($indice -ge 0) {
        $pastaAntiga = $pastas[$indice].Name
        Write-Host "Removendo a pasta: $pastaAntiga"
        Remove-AzStorageBlob -Container "$container" -Blob "$pastaAntiga" -Context $contexto
    } else {
        Write-Host "Nao existem pastas suficientes para uma remocao"
    }

    # Remove arquivos antigos do Desktop
    Write-Host "Limpando cache"
    Get-ChildItem -Path "C:\Users\Public\Desktop" *.zip | foreach { Remove-Item -Path $_.FullName }
}
catch {
    # Mostra mensagem de erro
    Write-Host "Erro ao fazer o procedimento"
    Write-Host "$_.Exception.Message"
}