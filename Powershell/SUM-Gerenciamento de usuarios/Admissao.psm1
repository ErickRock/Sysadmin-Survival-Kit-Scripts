# RPA INFRA - Admissão
# Ivo Dias
# Versao 12.0

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

# Copiar grupos de referencia
function Copiar-Grupos {
    param (
        [parameter(position=0,Mandatory=$True)]
        $referencia,
        [parameter(position=1,Mandatory=$True)]
        $credencialDominio
    )
    $usuarioReferencia = Get-ADUser -Identity $referencia -Properties * # Recebe todas as informacoes do usuario de referencia
    $referenciaGrupos = $usuarioReferencia.MemberOf # Recebe todos os grupos em que ele esta
    foreach ($grupo in $referenciaGrupos) {
        Add-ADGroupMember -Identity $grupo -Members $adUsuario -Credential $credencialDominio # Para cada grupo na lista, adiciona o novo usuario
    }
}

# Envia o email com os dados
function Enviar-Email {
    param (
        [parameter(position=0,Mandatory=$True)]
        $nomeUsuario,
        [parameter(position=1,Mandatory=$True)]
        $titulo,
        [parameter(position=2,Mandatory=$True)]
        $CorpoEmail
    )

    # Credencial
    $SUM = "SUM@dominio.com.br"
    $identificador = "SEC@311020190706"
    $PasswordFile = "\\servidor\SUM\Config\$identificador.pass"
    $key = Get-Content "\\servidor\SUM\Config\$identificador.key"
    $credencialSUM = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SUM, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)

    # Opcoes do email
    $To = "suporte@dominio.com.br"
    $from = $SUM

# Escreve o Email
$Email = @"
<style>
    body { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; color:#434242;}
    TABLE { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TR {border-width: 1px;padding: 10px;border-style: solid;border-color: white; }
    TD {font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;padding: 10px;border-style: solid;border-color: white; background-color:#C3DDDB;}
    .Func {background-color:green; color:white;}
    .Not {background-color:red; color:white;}
    .colort{background-color:#58A09E; padding:20px; color:white; font-weight:bold;}
</style>
<body>
$CorpoEmail
</body>
"@

    # Envia o e-mail
    Write-Host "Enviando o relatorio"
            send-mailmessage `
                -To $To `
                -Subject "$titulo" `
                -Body $Email `
                -BodyAsHtml `
                -Priority high `
                -UseSsl `
                -Port 587 `
                -SmtpServer 'smtp.office365.com' `
                -From $from `
                -Credential $credencialSUM 
}

# Cria a funcao de Admissão
function NovoUsuario {
    param (
        [parameter(position=0,Mandatory=$True)]
        $nomeUsuario,
        [parameter(position=1,Mandatory=$True)]
        $sobrenomeCompleto,
        [parameter(position=2,Mandatory=$True)]
        $sobrenomeUsuario,
        [parameter(position=3,Mandatory=$True)]
        $usuarioReferencia,
        [parameter(position=4,Mandatory=$True)]
        $contratoUsuario,
        [parameter(position=5,Mandatory=$True)]
        $cargoUsuario,
        [parameter(position=6,Mandatory=$True)]
        $areaUsuario
    )   

    # Configuracoes gerais
    $SUM = "\\servidor\SUM" # Define o caminho padrao da pasta de Logs
    $pastaAdmitidos = "$SUM\Admitidos" # Configura a pasta para os Desligamentos
    $identificacao = Get-Date -Format LOG@ddMMyyyy # Cria um codigo baseado no dia mes ano (02102019)
    $identificacao += ".txt" # Atribui um tipo ao log
    $identificacaoOffice = Get-Date -Format Lic@ddMMyyyy # Cria o identificador do Office
    $pastaOk = "$pastaAdmitidos\OK" # Define a pasta de logs que funcionaram
    $pastaErro = "$pastaAdmitidos\Erro" # Define a pasta de logs que nao funcionaram
    $pastaOffice = "$pastaAdmitidos\Office" # Define a pasta do Office
    $licencaOffice = "$pastaOffice\$identificacaoOffice" # Define o caminho do arquivo de licenciamento
    $LogOk = "$pastaOk\$identificacao" # Define o arquivo de logs que funcionaram
    $LogErro = "$pastaErro\$identificacao" # Define o arquivo de que não funcionaram
    $data = Get-Date # Pega a data atual
    $DomainDC = (Get-ADDomain).DistinguishedName # Recebe o nome do AD

    # Validacao dos caminhos
    Validar-Pasta $SUM
    Validar-Pasta $pastaAdmitidos
    Validar-Pasta $pastaOk
    Validar-Pasta $pastaErro
    Validar-Pasta $pastaOffice

    #Faz os procedimentos
    try {
        # Carrega o modulo
        Import-Module ActiveDirectory

        # Carrega as credenciais do AD
        $identificador = "SEC@311020190706"
        $PasswordFile = "$SUM\Config\$identificador.pass"
        $key = Get-Content "$SUM\Config\$identificador.key"
        $credencialDominio = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "SUM@dominio.com.br", (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)

        # Configura os dados
        $completoUsuario = "$nomeUsuario $sobrenomeCompleto" # Cria o nome de exibicao
        $adUsuario = ("$nomeUsuario.$sobrenomeUsuario").ToLower() # Cria o logon
        $emailUsuario = "$adUsuario@dominio.com.br" # Cria o email
        $OU = "OU=$areaUsuario,OU=Dominio,$DomainDC" # Configura a OU
        $senhaUsuario = Get-Date -Format Sin@mmss # Cria uma senha

        # Cria o usuario
        New-ADUser -SamAccountName $adUsuario -Name $completoUsuario -GivenName $nomeUsuario -Surname $sobrenomeUsuario -EmailAddress $emailUsuario -Path "$OU" -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -UserPrincipalName $emailUsuario -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{'msRTCSIP-PrimaryUserAddress'="SIP:$emailUsuario"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{proxyAddresses="SMTP:$adUsuario","SIP:$emailUsuario"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{targetAddress="SMTP:$adUsuario@ID.mail.onmicrosoft.com"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{DisplayName="$completoUsuario"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{displayNamePrintable="$completoUsuario"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{mailNickname="$adUsuario"} -Credential $credencialDominio
        Set-ADUser -Identity $adUsuario -Replace @{uid="$adUsuario"} -Credential $credencialDominio
        Set-ADAccountPassword -Identity $adUsuario -NewPassword (ConvertTo-SecureString -AsPlainText $senhaUsuario -Force) -Credential $credencialDominio # Configura a senha
        Set-ADUser -Identity $adUsuario -changepasswordatlogon $true -Credential $credencialDominio # Configura para trocar a senha no proximo login
        Set-ADUser -Identity $adUsuario -Enabled $true -Credential $credencialDominio # Deixa a conta ativa

        # Configura os grupos do usuário de referência
        Copiar-Grupos $usuarioReferencia $credencialDominio
       
        # Gera arquivo para script do Office
        Add-Content -Path "$licencaOffice" -Value "$completoUsuario:::$emailUsuario:::$cargoUsuario" # Grava o log

        # Configura o retorno de erro para o email
        $titulo = "Usuario $adUsuario criado com sucesso"

        # Gera o Log
        $logTexto = "$completoUsuario`r`n------------------------------------------------------------------------------`r`n$data`r`nUsuario : $adUsuario                       Senha : $senhaUsuario`r`nE-mail : $emailUsuario`r`nContrato : $contratoUsuario           Cargo : $cargoUsuario       Area : $areaUsuario`r`nUsuario Referencia : $usuarioReferencia`r`n`------------------------------------------------------------------------------"
        Add-Content -Path "$LogOk" -Value $logTexto # Grava o log
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        # Gera o Log
        $logTexto = "$completoUsuario`r`n------------------------------------------------------------------------------`r`n$data`r`nErro : $ErrorMessage`r`n------------------------------------------------------------------------------"
        Add-Content -Path "$LogErro" -Value $logTexto # Grava o log
        # Configura o retorno de erro para o email
        $titulo = "Erro ao criar o usuario $adUsuario"
    }

    # Configura a mensagem 
    $corpoEmail = $logTexto -replace "`r`n", '<br>'
    $corpoEmail += "<br>E-mail automatico, sem suporte para acentos<br>"
    $corpoEmail += "Favor nao responder<br>"
    # Envia o e-mail
    Enviar-Email $adUsuario $titulo $corpoEmail

    # Retorna o valor do Log
    return $logTexto
}