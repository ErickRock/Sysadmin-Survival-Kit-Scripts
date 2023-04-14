# RPA INFRA - Desligamento
# Ivo Dias e Leonardo Belli
# Versao 8.0

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

# Cria a funcao de Desligamento
function DesligarUsuario {
    param (
        [parameter(position=0,Mandatory=$True)]
        $usuarioIdentidade
    )

    # Configuracoes gerais
    $SUM = "\\servidor\SUM" # Define o caminho padrao da pasta de Logs
    $pastaDesligados = "$SUM\Desligados" # Configura a pasta para os Desligamentos
    $identificacao = Get-Date -Format LOG@ddMMyyyy # Cria um codigo baseado no dia mes ano (02102019)
    $identificacao += ".txt" # Atribui um tipo ao log
    $pastaOk = "$pastaDesligados\OK" # Define a pasta de logs que funcionaram
    $pastaErro = "$pastaDesligados\Erro" # Define a pasta de logs que nao funcionaram
    $LogOk = "$pastaOk\$identificacao" # Define o arquivo de logs que funcionaram
    $LogErro = "$pastaErro\$identificacao" # Define o arquivo de que não funcionaram
    $data = Get-Date # Pega a data atual

    # Validacao dos caminhos
    Validar-Pasta $SUM
    Validar-Pasta $pastaDesligados
    Validar-Pasta $pastaOk
    Validar-Pasta $pastaErro

    # Faz os procedimentos
    try {
        # Carregar modulos necessarios
        Import-Module ActiveDirectory
        Import-Module MSOnline

        # Carrega as credenciais
        $identificador = "SEC@311020190706"
        $PasswordFile = "\\$SUM\Config\$identificador.pass"
        $key = Get-Content "\\$SUM\Config\$identificador.key"
        # Credencial do AD
        $credencialDominio = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "SUM@empresa.com.br", (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
        # Credenciais do Office
        $credencialOffice = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "SUM@empresa.com.br", (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)

        # Conecta no Office 365
        $conexaoOffice365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'https://ps.outlook.com/powershell/' -Credential $credencialOffice -Authentication Basic -AllowRedirection # Configura o acesso
        $noReturn = Import-PSSession $conexaoOffice365 -AllowClobber # Acessa o site
        $noReturn = Connect-MsolService -Credential $credencialOffice # Faz o login no portal do Office

        # Levanta informacoes do usuario
        $usuarioInformacoesAD = Get-ADUser -Identity $usuarioIdentidade -Properties * # Recebe todas as informacoes do usuario
        $usuarioGrupos = $usuarioInformacoesAD.MemberOf # Identifica todos os grupos que o usuario eh membro
        $usuarioEmail = $usuarioInformacoesAD.Mail # Identifica o email do usuario
        $usuarioTelefone = $usuarioInformacoesAD.OfficePhone # Identifica o email do usuario
        $usuarioOU = $usuarioInformacoesAD.DistinguishedName # Identifica a OU do usuario
        $usuarioInformacoesOffice = Get-MsolUser -UserPrincipalName $usuarioEmail # Recebe as informacoes do Office
        $usuarioLicenciamentoOffice = $usuarioInformacoesOffice.Licenses.AccountSKUid # Identifica o licenciamento

        # Remover o usuario dos grupos do AD
        foreach ($grupo in $usuarioGrupos) {
            Remove-ADGroupMember -Identity $grupo -Members $usuarioIdentidade -Confirm:$false -Credential $credencialDominio # Remove o usuario do grupo
        }

        # Move o usuario para a OU de desligados
        $desligadosOU = "OU=Usuarios Desativados,DC=dominio,DC=com,DC=br" # Define a OU de desligados
        Move-ADObject -Identity "$usuarioOU" -TargetPath "$desligadosOU" -Credential $credencialDominio # Move para a OU de desligados

        # Desativar o usuario
        Set-ADUser -Identity $usuarioIdentidade -Enabled $false -Credential $credencialDominio

        # Remover a licenca do Office
        (get-MsolUser -UserPrincipalName $usuarioEmail).licenses.AccountSkuId | ForEach-Object {
            Set-MsolUserLicense -UserPrincipalName $usuarioEmail -RemoveLicenses $_
        }

        # Gera o Log
        $logTexto = "$usuarioIdentidade`r`n------------------------------------------------------------------------------`r`n$data`r`nLicenciamento do Office : $usuarioLicenciamentoOffice`r`nNumero Jabber           : $usuarioTelefone`r`n------------------------------------------------------------------------------"
        Add-Content -Path "$LogOk" -Value $logTexto # Grava o log
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        # Gera o Log
        $logTexto = "$usuarioIdentidade`r`n------------------------------------------------------------------------------`r`n$data`r`nErro : $ErrorMessage`r`n------------------------------------------------------------------------------"
        Add-Content -Path "$LogErro" -Value $logTexto # Grava o log
    }

    # Retorna o valor do Log
    return $logTexto
}