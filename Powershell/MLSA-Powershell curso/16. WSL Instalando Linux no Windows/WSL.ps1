# Configuracoes
$nomeSO = "Ubuntu"
$urlDownload = "https://aka.ms/wsl-ubuntu-1604"
$pastaDownload = "$env:USERPROFILE\Downloads"
$caminhoAppx = "$pastaDownload\$nomeSO.appx"

# Inicia o procedimento
Clear-Host
try {
    # Verifica se o WSL esta instalado
    $WSL = Get-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform"
    $WslStatus = $WSL.State
    if ($WslStatus -eq "Disabled") {
        Write-Host "Precisamos instalar o sub sistema do Linux"
        Write-Host "Iniciando instalacao do WSL"
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -Norestart
        Write-Host "Com a instalacao finalizada, precisamos reiniciar o computador para concluir"
        Write-Host "Reinicie e rode novamente esse script"
        Pause 
        exit
    } else {
        Write-Host "WSL ja instalado, vamos seguir com o $nomeSO"
    }

    # Faz o download do Ubuntu
    Write-Host "Fazendo o download do $nomeSO"
    Invoke-WebRequest -Uri "$urlDownload" -OutFile "$caminhoAppx" -UseBasicParsing

    # Faz a instalacao
    Write-Host "Fazendo a instalacao"
    Add-AppxPackage "$caminhoAppx"
    Write-Host "Instalacao concluida"

    # Removendo arquivo de instalacao
    Write-Host "Limpando arquivos de instalacao"
    Remove-Item -Path "$caminhoAppx" -force

    # Encerrando
    Write-Host "Acesse o $nomeSO no menu iniciar"
    Pause
    exit
}
catch {
    # Mostra mensagem de erro
    Write-Host "Erro ao fazer o procedimento"
    Write-Host "Erro: $_.Exception.Message"
}