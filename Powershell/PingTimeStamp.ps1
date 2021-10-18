# Ping com Log e data
# Ivo Dias

function Ping-TimeStamp {
    param (
        [parameter(position=0, Mandatory=$True)]
        $nomeComputador
    )

    # Configuracoes
    $hash = Get-Date -Format mmssyyyydd
    $logPath = "$env:userprofile\Documents\log.$nomeComputador.$hash.txt"

    # Inicia o registro de Logs
    Start-Transcript -path $logPath -Append

    # Inicia o processo de Ping com a data
    try {
        $host.UI.RawUI.WindowTitle = "Verificando $nomeComputador - Aperte CTRL + C para cancelar"
        Ping.exe -t $nomeComputador | ForEach {"{0} - {1}" -f (Get-Date),$_}
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host "Ocorreu um erro ao verificar $nomeComputador"
        Write-Host "Error: $ErrorMessage"
    }  
}