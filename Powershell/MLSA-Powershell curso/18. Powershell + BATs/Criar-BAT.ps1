# Escreve a bat para inicializar
function Escreva-Bat {
    param (
        [parameter(position=0, Mandatory=$True)]
        $NomeSoftware,
        [parameter(position=1, Mandatory=$True)]
        $CaminhoPS1,
        [parameter(position=2, Mandatory=$True)]
        $Versao,
        [parameter(position=3, Mandatory=$True)]
        $ScriptPath
    )

    # Cria o codigo da bat
    $codigoScript = "@echo off
================================================================================  
    :: NOME   : TI - $NomeSoftware
    :: AUTOR  : Nome Autor 
    :: VERSAO : $versao 
================================================================================
::Titulo:
title TI - $NomeSoftware
:: Inicia o programa 
PowerShell.exe -ExecutionPolicy Bypass -File $caminhoPS1"

    # Configura o nome
    $nomeScript = $NomeSoftware -replace " ", '-' # Remove os espacos
    $ScriptPath += "\$nomeScript.bat"

    # Escreve o script
    try {
        Write-Host "Escrevendo a Bat.."
        Add-Content -Path "$ScriptPath" -Value "$codigoScript"
        Write-Host "Script disponivel em: $ScriptPath"
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro: $ErrorMessage"
    }
}