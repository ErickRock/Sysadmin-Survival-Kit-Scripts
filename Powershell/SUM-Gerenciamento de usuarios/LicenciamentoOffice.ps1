# RPA INFRA - Licenciamento Office
# Ivo Dias e Leonardo Belli
# Versao 1.0

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

# Dicionario de licenciamento por cargo
function Dicionario-Licenciamento {
    param (
        [parameter(position=0,Mandatory=$True)]
        $cargo
    )
    # Faz a traducao do cargo numa licenca
    $licenca = "x" # Valor padrao

    # Licenciamento Exchange Online
    if ($cargo -eq "Alocado") { $licenca = "ID:EXCHANGESTANDARD" }

    # Licenciamento E1
    if ($cargo -eq "Analista") { $licenca = "ID:STANDARDPACK" }

    # Licenciamento E3
    if ($cargo -eq "Gerente") { $licenca = "ID:ENTERPRISEPACK" }

    # Retorna o licenciamento
    return $licenca
}

# Configuracoes gerais
$identificacaoOffice = Get-Date -Format Lic@ddMMyyyy # Verifica a data do procedimento
$arquivoOffice = "$pastaOffice\$identificacaoOffice" # Define o caminho do arquivo de licenciamento
$data = Get-Date # Pega a data atual

# Cria os Logs
$SUM = "\\servidor\SUM" # Define o caminho padrao da pasta de Logs
$pastaAdmitidos = "$SUM\Admitidos" # Configura a pasta para os Desligamentos
$identificacao = Get-Date -Format LOG@ddMMyyyy # Cria um codigo baseado no dia mes ano (02102019)
$identificacao += ".txt" # Atribui um tipo ao log
$identificacaoOffice = Get-Date -Format Lic@ddMMyyyy # Cria o identificador do Office
$pastaOffice = "$pastaAdmitidos\Office" # Define a pasta do Office
$pastaOk = "$pastaOffice\OK" # Define a pasta de logs que funcionaram
$pastaErro = "$pastaOffice\Erro" # Define a pasta de logs que nao funcionaram
$pastaOffice = "$pastaAdmitidos\Office" # Define a pasta do Office
$pastaConfig = "$SUM\Config" # Define a pasta para arquivos de configuracao
$LogOk = "$pastaOk\$identificacao" # Define o arquivo de logs que funcionaram
$LogErro = "$pastaErro\$identificacao" # Define o arquivo de que não funcionaram

# Validacao dos caminhos
Validar-Pasta $SUM
Validar-Pasta $pastaAdmitidos
Validar-Pasta $pastaOk
Validar-Pasta $pastaErro
Validar-Pasta $pastaOffice
Validar-Pasta $pastaConfig

# Credenciais do Office
$identificador = "Verificar script de criacao de credenciais"
$usuarioSUM = "SUM@dominio.com.br"
$PasswordFile = "$pastaConfig\$identificador.pass"
$key = Get-Content "$pastaConfig\$identificador.key"
$credencialOffice = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $usuarioSUM, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)


# Conectar ao Office 365
try {
    Import-Module MSOnline # Carrega os modulos do Office
    $conexaoOffice365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'https://ps.outlook.com/powershell/' -Credential $credencialOffice -Authentication Basic -AllowRedirection # Configura o acesso
    $noReturn = Import-PSSession $conexaoOffice365 -AllowClobber # Acessa o site
    $noReturn = Connect-MsolService -Credential $credencialOffice # Faz o login no portal do Office
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
    # Gera o Log
    $logTexto = "Erro ao conectar no Office`r`n------------------------------------------------------------------------------`r`n$data`r`nErro : $ErrorMessage`r`n------------------------------------------------------------------------------"
    Add-Content -Path "$LogErro" -Value $logTexto # Grava o log
}

# Verifica todos os usuarios
$usuariosLicenciamento = Get-Content $arquivoOffice # Recebe os dados do arquivo
foreach ($usuario in $usuariosLicenciamento) {
    # Faz os procedimentos
    try {
        # Recebe os dados
        $completoUsuario, $emailUsuario, $cargoUsuario = $usuario -split(':::')

        # Recebe a licenca correta
        $licencaOffice = Dicionario-Licenciamento $cargoUsuario

        # Configurando o Office
        Set-MsolUser -UserPrincipalName "$emailUsuario" -UsageLocation BR # Configura a localizacao
        Set-MsolUserLicense -UserPrincipalName "$emailUsuario" -AddLicenses "$licencaOffice" # Adiciona a licenca ao usuario

        # Registra o que foi feito
        $logTexto = "$completoUsuario`r`n------------------------------------------------------------------------------`r`n$data`r`nLicenciamento: $licencaOffice`r`n------------------------------------------------------------------------------"
        Add-Content -Path "$LogOk" -Value $logTexto # Grava o log
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        # Gera o Log
        $logTexto = "$completoUsuario`r`n------------------------------------------------------------------------------`r`n$data`r`nErro : $ErrorMessage`r`n------------------------------------------------------------------------------"
        Add-Content -Path "$LogErro" -Value $logTexto # Grava o log
    }    
}
