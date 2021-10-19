# Funcoes Basicas
# Ivo Dias

# Validar as pastas
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

# Credencial do AD
function Credencial-AD {
    param (
        [parameter(position=0,Mandatory=$True)]
        $caminhoArquivoSenha
    )
    # Para gerar esses arquivos, favor consultar a documentacao:
    # https://gallery.technet.microsoft.com/Gerar-arquivo-de-senha-302bad71
    $usuarioAdministrador = "usuario@dominio.com.br"
    $identificador = "SEC@311020190706"
    $ArquivoSenha = "$caminhoArquivoSenha\$identificador.pass"
    $ChaveCriptografia = Get-Content "$caminhoArquivoSenha\$identificador.key"
    $credencialSUM = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $usuarioAdministrador, (Get-Content $ArquivoSenha | ConvertTo-SecureString -Key $ChaveCriptografia)
    return $credencialSUM
}

# Funcao para pegar arquivo
Function Localizar-Arquivo($initialDirectory) {
    try {
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.initialDirectory = $initialDirectory
        $OpenFileDialog.filter = "Arquivo de Dados (*.csv)| *.csv"
        $OpenFileDialog.ShowDialog() | Out-Null
        $OpenFileDialog.filename
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        return $ErrorMessage # Exibe a mensagem de erro
    }
}