# Lembrar de executar como Admin

# Configuracoes
$urlDownloadAPI = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip"
$pastaDownload = "$env:LOCALAPPDATA/VeracodeAPI.zip"
$pastaSistema = "$Env:Programfiles/Veracode/API/.NET"

Clear-Host
try {
# Faz o download
    Write-Host "Fazendo o download da ferramenta"
    Invoke-WebRequest -Uri "$urlDownloadAPI" -OutFile "$pastaDownload"
    # Descompacta o arquivo
    Write-Host "Descompactando.."
    Expand-Archive -Path "$pastaDownload" -DestinationPath "$pastaSistema"
    # Altera o nome do arquivo
    Rename-Item -Path "$pastaSistema/VeracodeC#API.exe" -NewName "$pastaSistema/VeracodeAPI.exe"
    # Adiciona o EXE ao caminho do Path do sistema
    Write-Host "Adicionando ao Path do sistema"
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaSistema")
    Write-Host "Procedimento de configuracao concluido" 
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao fazer a configuracao da API"
    Write-Host "$ErrorMessage"
}