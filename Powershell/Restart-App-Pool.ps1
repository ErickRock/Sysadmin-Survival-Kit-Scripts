# Funcao para reiniciar os Pools parados em um servidor
# Ivo Dias

function Set-PoolUp {
    # Recebe todos os Pools da pasta padrao do IIS
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
                    Write-Host "-----> $ApplicationPoolName foi reiniciado."
                }
                catch {
                    $ErrorMessage = $_.Exception.Message # Recebe o erro
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