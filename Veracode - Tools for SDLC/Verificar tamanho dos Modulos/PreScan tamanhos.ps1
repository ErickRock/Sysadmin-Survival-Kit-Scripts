
function Get-VeracodeAppSize {
    param (
        $veracodeID = "",
        $veracodeAPIkey = "",
        $nomeProjeto = "",
        $caminhoArquivo = "",
        $caminhoLOG = "$env:LOCALAPPDATA\PreScan-Tamanhos.txt",
        $perfilValidacao = ""
    )

    try {
        # Configuracoes
        $numeroVersao = "$nomeProjeto." + (Get-Date -Format hhmmssddMMyy)

        # Recebe o App ID com base no nome da aplicacao dentro do Veracode
        [xml]$INFO = $(VeracodeAPI.exe -vid "$veracodeID" -vkey "$veracodeAPIkey" -action GetAppList | Select-String -Pattern $perfilValidacao)
        # Filtra o App ID
        $appID = $INFO.app.app_id


        # Deleta a ultima e cria uma nova build
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action deletebuild -appid $appID
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action createbuild -appid $appID -version $numeroVersao

        # Faz o upload do arquivo
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action uploadfile -appid "$appID" -filepath "$caminhoArquivo"

        # Faz o pre scan no perfil de validacao
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action beginprescan -appid "$appID"
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro ao receber as informações"
        Write-Host "$ErrorMessage"
    }
    
    # Pega os resultados
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
                    Write-Host "Validando se o PreScan $nomeProjeto já foi concluido"
                    Write-Host "Por favor aguarde"
                    Start-Sleep -s $contador
                    $hardcount += $contador
                }
            } while ($validacao)

            # Pega os dados do scan
            [xml]$preScanInfo = $(VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action getprescanresults -appid $appID)
            $tamanhos = $preScanInfo.prescanresults.module.size
            $tamanhoTotal = Get-VeracodeModulesSum $tamanhos
            # Faz o log
            Add-Content -Path $caminhoLOG -Value "Projeto: $nomeProjeto | Tamanho dos modulos: $tamanhoTotal MB"

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
}