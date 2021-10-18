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