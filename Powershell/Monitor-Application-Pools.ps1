# Reinicar Pools parados
# Ivo Dias

# Verifica se o modulo esta instalado
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
        Install-Module $nomeModulo -Force
        Import-Module $nomeModulo -Force
    }
}

# Enviar informacoes para o Logic Apps
function New-LogicAppInfo {
    param (
        [parameter(position=0, Mandatory=$True)]
        $urlLogicApp,
        [parameter(position=1, Mandatory=$True)]
        $nomePool,
        [parameter(position=2)]
        $maisInfos,
        [parameter(position=3)]
        $servidor = $env:computername
    )

    # Configura a informacao
    $infoPool = [PSCustomObject]@{
        NomePool      = "$nomePool"
        Obs           = "$maisInfos"
        Servidor      = "$servidor"
    }

    # Create a line that creates a JSON from this object
    $JSONInfo = $infoPool | ConvertTo-Json 

    # this line sends the email through the logic app
    Invoke-RestMethod -Method POST -Uri $urlLogicApp -Body $JSONInfo -ContentType 'application/json'
}

# Fazer a validacao dos Pools
function Set-PoolUp {
    param (
        [parameter(position=0, Mandatory=$True)]
        $urlLogicApp
    )
    # Recebe todos os Pools
    $ApplicationPools = Get-ChildItem -Path "IIS:\AppPools"
    
    # Verifica na lista
    foreach ($AppPool in $ApplicationPools) {
        try {
            $ApplicationPoolName = $AppPool.Name
            $ApplicationPoolStatus = $AppPool.state
            Write-Host "$ApplicationPoolName -> $ApplicationPoolStatus"
        
            if($ApplicationPoolStatus -ne "Started") {
                Write-Host "-----> $ApplicationPoolName esta parado."
                try {
                    Start-WebAppPool -Name $ApplicationPoolName
                    $horarioReinicio = Get-Date
                    New-LogicAppInfo "$urlLogicApp" "$ApplicationPoolName" "O Pool foi reiniciado em: $horarioReinicio"
                    Write-Host "-----> $ApplicationPoolName foi reiniciado."
                }
                catch {
                    $ErrorMessage = $_.Exception.Message # Recebe o erro
                    New-LogicAppInfo "$urlLogicApp" "$ApplicationPoolName" "Ocorreu um erro ao reiniciar o Pool: $ErrorMessage"
                    Write-Host "Ocorreu um erro ao reiniciar o $ApplicationPoolName"
                    Write-Host "Error: $ErrorMessage"
                }    
            } 
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Ocorreu um erro ao verificar $ApplicationPoolName"
            Write-Host "Error: $ErrorMessage"
        }
    }
}

# Verifica se o IIS esta instalado
$iisStatus = (Get-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole).State
if ($iisStatus -eq "Enabled") {
    Write-Host "IIS esta configurado"
} else {
    Enable-WindowsOptionalFeature –online –featurename IIS-WebServerRole
}

# Configurando modulos necessarios
Configurar-Modulo "WebAdministration"

# Define a localizacao
if (Test-Path "IIS:\AppPools") {
    Write-Host "Pasta do IIS esta disponivel"   
} else {
    Write-Host "Pasta do IIS nao disponivel"
    Write-Host "Nao podemos continuar ate que ela esteja disponivel"
    Pause
    exit
}

# Configuracoes Logic App
$urlLogicApp = "URL Logic Apps"

# Faz o procedimento dentro de um loop
Clear-Host
while ($true) {
    Set-PoolUp "$urlLogicApp"
    Start-Sleep -Seconds 10 # Reinicia a cada minuto
}