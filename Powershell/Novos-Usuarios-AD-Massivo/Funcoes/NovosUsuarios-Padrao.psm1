# Novos usuarios Massivo
# Varios usuarios padroes da empresa
# Ivo Dias

function Novo-UsuarioAD {
    param (
        [parameter(position=0,Mandatory=$True)]
        $nome,
        [parameter(position=1,Mandatory=$True)]
        $sobrenome,
        [parameter(position=2,Mandatory=$True)]
        $UsuarioAdministrador,
        [parameter(position=3,Mandatory=$True)]
        $referencia,
        [parameter(position=4,Mandatory=$True)]
        $OU,
        [parameter(position=5,Mandatory=$True)]
        $hash,
        [parameter(position=6,Mandatory=$True)]
        $DominioEmail,
        [parameter(position=7,Mandatory=$True)]
        $caminhoLOGs
    )
    
    # Configuracao geral
    $userName = "$nome $sobrenome"
    $userAlias = ("$nome.$sobrenome").ToLower()
    $userMail = "$userAlias@$DominioEmail"
    $DominioDC = (Get-ADDomain).DistinguishedName
    $OU = "OU=$OU,$DominioDC"
    $Password = "Mudar123"
    $DominioOffice365 = "Empresa.mail.onmicrosoft.com" # Colocar o Dominio Padrao da empresa 
    
    # Cria o  usuario
    try {
        # Cria e faz as configuracoes padroes
        New-ADUser -SamAccountName $userAlias -Name $userName -GivenName $nome -Surname $sobrenome -EmailAddress $userMail -Path "$OU" -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -UserPrincipalName $userMail -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{'msRTCSIP-PrimaryUserAddress'="SIP:$userMail"} -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{proxyAddresses="SMTP:$userMail","SIP:$userMail"} -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{targetAddress="SMTP:$userAlias@$DominioOffice365"} -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{DisplayName="$userName"} -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{displayNamePrintable="$userName"} -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Replace @{mailNickname="$userAlias"} -Credential $UsuarioAdministrador
        Set-ADAccountPassword -Identity $userAlias -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -Credential $UsuarioAdministrador
        Set-ADUser -Identity $userAlias -Enabled $true -Credential $UsuarioAdministrador
        
        # Configura as referencias de grupo
        Copiar-Grupos $referencia $UsuarioAdministrador

        # Confirma a criacao
        Add-Content -Path "$caminhoLOGs\Criados.$hash.log" -Value $userAlias

        # Retorno da funcao
        $mensagemRetorno = "$userAlias criado com sucesso"
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Add-Content -Path "$caminhoLOGs\Erro.$hash.log" -Value "$userAlias | $ErrorMessage"
        # Retorno da funcao
        $mensagemRetorno = "$userAlias | $ErrorMessage"
    }

    return $mensagemRetorno
}