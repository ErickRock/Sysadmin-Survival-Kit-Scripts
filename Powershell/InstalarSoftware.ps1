# Instalar Software
# Ivo Dias

# Funcao para validar as pastas
function Validar-Pasta {
    param (
        [parameter(position=0,Mandatory=$True)]
        $caminho
    )
    # Verifica se ja existe
    $Existe = Test-Path -Path $caminho
    # Cria a pasta
    if ($Existe -eq $false) {
        Write-Host "Configurando pasta: $caminho"
        try {
            $noReturn = New-Item -ItemType directory -Path $caminho # Cria a pasta
            Write-Host "Pasta configurada com sucesso"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Ocorreu um erro durante a configuracao da pasta" # Mostra a mensagem
            Write-Host "Erro: $ErrorMessage"
            exit
        }
    }
}

# Funcao para instalar programas
function Instalar-Software {
    param (
        [parameter(position=0, Mandatory=$True)]
        $NomeSoftware,
        [parameter(position=1, Mandatory=$True)]
        $Path,
        [parameter(position=2, Mandatory=$True)]
        $instalador,
        [parameter(position=3, Mandatory=$True)]
        $Parametro,
        [parameter(position=4, Mandatory=$True)]
        $SoftwarePath
    )

    # Configuracoes gerais
    $pastaPadrao = "C:\TI\TEMP"
    Validar-Pasta $pastaPadrao

    # Verifica se o programa esta instalado
    if ($SoftwarePath -eq $false) {
        Write-Host "Instalando: $NomeSoftware"
        try {
            Copy-Item "$Path\$instalador" -Destination "$pastaPadrao" -Force # Copia o arquivo
            cmd /c "$pastaPadrao\$instalador $Parametro" # Faz a instalacao
            Write-Host "Instalacao concluida"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Ocorreu um erro durante a instalacao do $NomeSoftware : $ErrorMessage" # Mostra a mensagem 
        }
    } else {
        Write-Host "$NomeSoftware ja esta instalado"
    }
}

# Exemplo de uso
function Exemplo-InstalarSoftware {
    $NomeSoftware = "Adobe DC" # Nome de exibicao do software
    $Path = "\\servidor\Softwares\Utilitarios\Adobe Acrobat" # Caminho onde esta o instalador
    $instalador = "AcroRdrDC1900820071_pt_BR.exe" # Arquivo de instalacao
    $Parametro = "/sAll" # Parametros para instalacao, consultar com o fabricante ou testar alguns padroes: /s, /silent, /quiet...
    $SoftwarePath = Test-Path -Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC" # Caminho onde o softwate fica depois de instalado
    # Faz a instalacao
    Instalar-Software $NomeSoftware $Path $instalador $Parametro $SoftwarePath
}

# Instalador com ajuda
function InstalarSoftware-Ajuda {
    $NomeSoftware = Read-Host "Informe o nome do software"
    $Path = Read-Host "Informe o caminho da pasta do instalador"
    $instalador = Read-Host "Informe o instalador (ex: instalador.exe)"
    $Parametro = Read-Host "Informe o parametro de instalacao (ex: /s, /silent, /quiet...)"
    $caminhoPasta = Read-Host "Informe o caminho para validacao de instalacao"
    $SoftwarePath = Test-Path -Path $caminhoPasta
    # Faz a instalacao
    Instalar-Software $NomeSoftware $Path $instalador $Parametro $SoftwarePath
}