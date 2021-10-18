# Configuracoes
$pastaProjeto = ""
$veracodeID = ""
$veracodeAPIkey = ""
$veracodeAppName = "OnPremised.DVWA"
$numeroVersao = Get-Date -Format hhmmssddMMyy
$caminhoArquivo = "$env:LOCALAPPDATA/$numeroVersao.zip"

# Processo de enpacotamento
Compress-Archive -Path "$pastaProjeto" -DestinationPath "$caminhoArquivo" 

# Recebe o App ID com base no nome da aplicacao dentro do Veracode
[xml]$INFO = $(VeracodeAPI.exe -vid "$veracodeID" -vkey "$veracodeAPIkey" -action GetAppList | Select-String -Pattern $veracodeAppName)
# Filtra o App ID
$appID = $INFO.app.app_id

# Faz o Uploud and Scan
try {
    # Caso exista um App ID, segue com os procedimentos
    if ($appID) {
        Clear-Host
        Write-Host "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') | Perfil do aplicativo localizado com ID: $appID"
        # Faz o Uploud and Scan
        Write-Host "Iniciando Upload and Scan"
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScanByAppId -appid "$appID" -filepath "$caminhoArquivo" -version $numeroVersao
        Write-Host "Procedimento concluido"
    } else {
        Write-Host "Não foi encontrado um App ID para o $veracodeAppName"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao iniciar Uploud and Scan"
    Write-Host "$ErrorMessage"
    $o = Read-Host "Aperte enter para encerrar"
    exit
}


try {
    # Configuracoes do loop
    [int]$contador = 10
    [int]$hardcount = 0
    if ($hardcount -le 300) {
        do {
            VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action GetPreScanResults -appid "$appID" >> "$env:LOCALAPPDATA\$numeroVersao.txt"
            $retorno = Get-Content "$env:LOCALAPPDATA\$numeroVersao.txt"
            Clear-Host
            if ($retorno -match "$appID") {
                break
            } else {
                $validacao = $true
                Write-Host "Validando se o Scan $numeroVersao já foi concluido"
                Write-Host "Por favor aguarde"
                Start-Sleep -s $contador
                $hardcount += $contador
            }
        } while ($validacao)
        # Pega o ID da build
        [string]$INFO = VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action GetAppBuilds -appid "$appID"
        [xml]$INFO = $INFO.Replace(' xmlns=', ' _xmlns=')
        $buildINFO = $INFO.SelectSingleNode("//application[@app_id='$appId']")
        $buildID = $buildINFO.build.build_id
        # Gera o relatorio
        $out = VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action summaryreport -buildid "$buildID" -outputfilepath "$env:LOCALAPPDATA\$numeroVersao.xml"
        $securityINFO = [xml](Get-Content "$env:LOCALAPPDATA\$numeroVersao.xml")
        # Recebendo informacoes
        Clear-Host
        $notaLetra = $securityINFO.summaryreport.'static-analysis'.rating
        $notaScore = $securityINFO.summaryreport.'static-analysis'.score
        $quemEnviou = $securityINFO.summaryreport.submitter
        $politica = $securityINFO.summaryreport.policy_name
        $complicanceStatus = $securityINFO.summaryreport.policy_compliance_status
        # Exibe os resultados
        Write-Host "Resultado do Scan: $numeroVersao"
        Write-Host "Nome App: $veracodeAppName - App ID: $appID"
        Write-Host "Enviado por: $quemEnviou"
        Write-Host "Politica: $politica"
        Write-Host "Nota: $notaLetra - Score: $notaScore - Resultado: $complicanceStatus"
        Write-Host "Lista dos problemas encontrados:"
        $levels = $securityINFO.summaryreport.severity.level
        foreach ($level in $levels) {
            $securityINFO.summaryreport.severity[$level].category
        }
    } else {
        Clear-Host
        Write-Host "Um erro aconteceu ao fazer o procedimento"
        Write-Host "Favor verificar a mensagem abaixo e comunicar o suporte"
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action GetPreScanResults -appid "$appID"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao validar o Scan e pegar os dados"
    Write-Host "$ErrorMessage"
}