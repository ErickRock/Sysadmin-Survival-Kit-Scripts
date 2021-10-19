# Carrega as funções
# Função para fazer a soma dos valores
function Get-VeracodeModulesSum {
    param (
        $tamanhos
    )

    # Inicializa as variaveis numericas
    [int]$somaMB = 0
    [int]$somaKB = 0
    # Divide a informacao dos modulos em linhas
    $tamanhoModulos = $tamanhos.split(" ")
    # Para cada linha, separa os MBs dos KBs
    foreach ($tamanhoModulo in $tamanhoModulos) {
        if ($tamanhoModulo -Match "MB") {
            $tamanhoModulo = $tamanhoModulo.replace("MB","")
            [int]$somaMB += $tamanhoModulo
        } if ($tamanhoModulo -Match "KB") {
            $tamanhoModulo = $tamanhoModulo.replace("KB","")
            [int]$somaKB += $tamanhoModulo
        }
    }
    # Converte KBs em MBs e soma os totais, retornando o resultado
    $total = $somaMB + ($somaKB/1024)
    $total = [math]::Round($total,2)
    return $total
}

# Função para fazer o processo de analise
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

# Faz o processo pegando os dados de um CSV e gerando um log
# Inicia o transcript
Start-Transcript
Get-Date

# Recebe os dados de um arquivo CSV, com a primeira coluna sendo o nome dos perfis 
# E a segunda o caminho do arquivo que vai ser analisado, conforme guia de compilação
$indice = 0
$caminhoCSV = "Informe o caminho do arquivo CSV"
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