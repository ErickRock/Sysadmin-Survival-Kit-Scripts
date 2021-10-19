function Configurar-Modulo {
    param (
        $nomeModulo
    )
    # Caso ele exista, faz apenas a importacao
    if (Get-Module -ListAvailable -Name $nomeModulo) {
        Write-Host "Importando modulos"
        Import-Module $nomeModulo -Force
    } else {
        Write-Host "Instalando modulos necessarios"
        Install-Module $nomeModulo -AllowClobber -Force
        Import-Module $nomeModulo -Force
    }
}