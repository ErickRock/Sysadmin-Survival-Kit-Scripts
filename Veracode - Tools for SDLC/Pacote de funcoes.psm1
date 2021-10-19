# SCA Agent based - Analise de repositorio por Url
function New-ScaScanUrl {
    param (
        [parameter(position=0,Mandatory=$True)]
        $url
    )
    # Faz o download do agente
    iex ((New-Object System.Net.WebClient).DownloadString("https://download.srcclr.com/ci.ps1"))
    # Faz a verificacao
    srcclr scan --url "$url"
}

# SCA Agent based - Analise para uma pasta ou arquivo especifico
function New-ScaScan {
    param (
        [parameter(position=0,Mandatory=$True)]
        $caminhoPasta
    )
    # Faz o download do agente
    iex ((New-Object System.Net.WebClient).DownloadString("https://download.srcclr.com/ci.ps1"))
    # Faz a verificacao
    srcclr scan "$caminhoPasta"
}

# Instalar Veracode Wrapper
function Install-VeracodeWrapper {
    # Configuracoes
    $urlDownloadAPI = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip"

    Clear-Host
    try {
    # Faz o download
        Write-Host "Fazendo o download da ferramenta"
        Invoke-WebRequest -Uri "$urlDownloadAPI" -OutFile "$env:LOCALAPPDATA/VeracodeAPI.zip"
        # Descompacta o arquivo
        Write-Host "Descompactando.."
        Expand-Archive -Path "$env:LOCALAPPDATA/VeracodeAPI.zip" -DestinationPath "$Env:Programfiles/Veracode/API/.NET"
        # Altera o nome do arquivo
        Rename-Item -Path "$Env:Programfiles/Veracode/API/.NET/VeracodeC#API.exe" -NewName "$Env:Programfiles/Veracode/API/.NET/VeracodeAPI.exe"
        # Adiciona o EXE ao caminho do Path do sistema
        Write-Host "Adicionando ao Path do sistema"
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:Programfiles/Veracode/API/.NET")
        Write-Host "Procedimento de configuracao concluido" 
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro ao fazer a configuracao da API"
        Write-Host "$ErrorMessage"
    }
    
}

# Funcao para fazer um scan num arquivo especifico
function New-PipelineScan {
    # Define os parametros que serao utilizados
    param (
        [parameter(position=0,Mandatory=$True)]
        $veracodeID,
        [parameter(position=1,Mandatory=$True)]
        $veracodeAPIkey,
        [parameter(position=2,Mandatory=$True)]
        $arquivo
    )
    try {
        # Filtra os objetos
        $nomearquivo = $arquivo.name # Recebe o nome do arquivo, exemplo: Foto123.png
        $caminhoarquivo = $arquivo.fullname # Recebe o caminho do arquivo: C:/Fotos/Foto123.png
        # Scan
        java -jar "pipeline-scan.jar" -vid $veracodeID -vkey $veracodeAPIkey -f $caminhoarquivo # Faz a validação conforme as orientações do fabricante
    }
    catch {
        # Esse bloco é ativado no caso de algum problema ocorrer no uso dos comandos anteriores
        # Recebendo o erro e exibindo ele, parando a execução
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        # Mostra uma mensagem personalizada
        Write-Host "Erro ao verificar o arquivo: $nomearquivo"
        Write-Host "$ErrorMessage"
    }
}

# Instalar Pipeline Scan
function Install-PipeScan {
    # Pasta padrao
    $pastaferramenta  = "$Env:Programfiles/Veracode/PipeScan"
    # Instalador
    $caminhoInstalador = "$env:userprofile/Download/pipescan.zip"
    # Link para fazer o download da ferramenta, conforme documentação
    $urlPipeScan = "https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip" # Link para fazer o download da ferramenta, conforme documentação

    # Instalacao da ferramenta
    try {
        # Verifica se ja tem o PipelineScan
        $existe = Test-Path -Path "$pastaferramenta"
        if ($Existe -eq $false) {
            # Faz o download
            Invoke-WebRequest -Uri "$urlPipeScan" -OutFile "$caminhoInstalador"
            # Extrai o arquivo
            Expand-Archive -Path "$caminhoInstalador" -DestinationPath "$pastaferramenta"
            # Adiciona o EXE ao caminho do Path do sistema
            Write-Host "Adicionando ao Path do sistema"
            [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaferramenta")
        }
        # Caso ela ja esteja instalada, nada é feito
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro ao fazer o download do Pipeline Scan"
        Write-Host "$ErrorMessage"
    }
}

# Pipeline Scan em uma pasta
function New-PipelineScanFolder {
    param (
        [parameter(position=0,Mandatory=$True)]
        $veracodeID,
        [parameter(position=1,Mandatory=$True)]
        $veracodeAPIkey,
        [parameter(position=2,Mandatory=$True)]
        $tipofiltro
    )

    # Filtra os arquivos
    $arquivos = Get-ChildItem "./*" -Include "*.$tipofiltro" -recurse # Recebe todos os arquivos do tipo especificado que estejam na mesma pasta do script
    # Faz a verificacao
    Clear-Host # Limpa a tela
    foreach ($arquivo in $arquivos) {
        Veracode-FileScan $veracodeID $veracodeAPIkey $arquivo # Valida arquivo por arquivo
    }
}