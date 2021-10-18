# Gerar uma senha como arquivo Hash
# Ivo Dias

# Biblioteca de funcoes:
# Funcao para pegar a pasta
Function Localizar-Pasta {
    try {
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
        $OpenFileDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        #$OpenFileDialog.SelectedPath = "$servidor"
        $OpenFileDialog.ShowDialog() | Out-Null
        $caminhoPasta = $OpenFileDialog.SelectedPath
        return $caminhoPasta
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Mostrar-Erro $ErrorMessage # Exibe a mensagem de erro
    }
}

# Criar o arquivo da senha e a chave
function Criar-ArquivoSenha {
    param (
        [parameter(position=0, Mandatory=$True)]
        $senha,
        [parameter(position=1, Mandatory=$True)]
        $caminho
    )
    
    try {
        # Cria a chave
        $hash = Get-Date -Format SECddMMyyyyssmm # Cria um identificador com base no dia e hora
        $KeyFile = "$caminho\$hash.key" # Define o caminho do arquivo
        $Key = New-Object Byte[] 32   # Voce pode usar 16 (128-bit), 24 (192-bit), ou 32 (256-bit) para AES
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key) # Cria a chave de criptografia
        $Key | Out-File $KeyFile # Salva em um arquivo

        # Cria a senha
        ConvertFrom-SecureString $senha -key $Key | Out-File "$caminho\$hash.pass"
        $retorno = $hash
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        $retorno = "Erro: $ErrorMessage"
    }
    return $retorno
}

# Interface Grafica: 
# Formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
Add-Type -AssemblyName PresentationFramework # Recebe a biblioteca de mensagens
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal
$GUI.Text ='Novo ArquivoSenha' # Titulo
#$GUI.AutoSize = $true # Configura para aumentar caso necessario
$GUI.Size = New-Object System.Drawing.Size(320,130) # Define o tamanho
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Senha
$lblSenha = New-Object System.Windows.Forms.Label # Cria a label
$lblSenha.Text = "Informe sua senha:" # Define um texto para ela
$lblSenha.Location  = New-Object System.Drawing.Point(0,10) # Define em qual coordenada da tela vai ser desenhado
$lblSenha.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblSenha) # Adiciona ao formulario principal
$txtSenha = New-Object Windows.Forms.MaskedTextBox # Cria a caixa de texto
$txtSenha.PasswordChar = '*' # Coloca um caractere especial para a senha
$txtSenha.Width = 200 # Configura o tamanho
$txtSenha.Location  = New-Object System.Drawing.Point(100,10) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtSenha) # Adiciona ao formulario principal

# Diretorio
$lblDiretorio = New-Object System.Windows.Forms.Label # Cria a label
$lblDiretorio.Text = "Diretorio Backup:" # Define um texto para ela
$lblDiretorio.Location  = New-Object System.Drawing.Point(0,30) # Define em qual coordenada da tela vai ser desenhado
$lblDiretorio.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblDiretorio) # Adiciona ao formulario principal
# Botao para escolher o diretorio
$btnDiretorio = New-Object System.Windows.Forms.Button # Cria um botao
$btnDiretorio.Location = New-Object System.Drawing.Size(100,30) # Define em qual coordenada da tela vai ser desenhado
$btnDiretorio.Size = New-Object System.Drawing.Size(200,18) # Define o tamanho
$btnDiretorio.Text = "Definir pasta" # Define o texto
$GUI.Controls.Add($btnDiretorio) # Adiciona ao formulario principal

# Botao para fazer o procedimento
$btnGerarArquivo = New-Object System.Windows.Forms.Button # Cria um botao
$btnGerarArquivo.Location = New-Object System.Drawing.Size(5,50) # Define em qual coordenada da tela vai ser desenhado
$btnGerarArquivo.Visible = $false # Deixa desativado
$btnGerarArquivo.Size = New-Object System.Drawing.Size(300,25) # Define o tamanho
$btnGerarArquivo.Text = "Gerar arquivo" # Define o texto
$GUI.Controls.Add($btnGerarArquivo) # Adiciona ao formulario principal

# Label para salvar dados
$lblProcesso = New-Object System.Windows.Forms.Label # Cria a label
$lblProcesso.Text = "" # Coloca um texto em branco
$lblProcesso.Visible = $false # Deixa invisivel na inicializacao
$lblProcesso.Location  = New-Object System.Drawing.Point(0,15) # Define em qual coordenada da tela vai ser desenhado
$lblProcesso.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblProcesso) # Adiciona ao formulario principal
$lblCaminhoProcesso = New-Object System.Windows.Forms.Label # Cria a label
$lblCaminhoProcesso.Text = "" # Coloca um texto em branco
$lblCaminhoProcesso.Visible = $false # Deixa invisivel na inicializacao
$lblCaminhoProcesso.Location  = New-Object System.Drawing.Point(0,15) # Define em qual coordenada da tela vai ser desenhado
$lblCaminhoProcesso.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblCaminhoProcesso) # Adiciona ao formulario principal

# Label para receber o retorno do procedimento
$lblRetorno = New-Object System.Windows.Forms.Label # Cria a label
$lblRetorno.Text = "" # Coloca um texto em branco
$lblRetorno.Location  = New-Object System.Drawing.Point(0,50) # Define em qual coordenada da tela vai ser desenhado
$lblRetorno.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblRetorno) # Adiciona ao formulario principal

# Evento do Botao Diretorio
$btnDiretorio.Add_Click({
    $caminhoPasta = Localizar-Pasta # Recebe a pasta
    $lblProcesso.Text = $caminhoPasta # Salva caminho selecionado
    $lblRetorno.Text = ""
    $btnGerarArquivo.Visible = $true # Ativa o botão
})

# Evento do Botao que gera o arquivo
$btnGerarArquivo.Add_Click({
    $senha = $txtSenha.Text # Recebe a senha
    $senha = ConvertTo-SecureString -String $senha –asplaintext –force
    $caminho = $lblProcesso.Text # Recebe o caminho selecionado
    try {
        $retorno = Criar-ArquivoSenha $senha $caminho # Faz o procedimento
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        $retorno = "Erro: $ErrorMessage"
    }
    # Limpa as caixas e exibe o retorno
    $lblRetorno.Text = "Ultimo gerado: $retorno"
    $btnGerarArquivo.Visible = $false
    $txtSenha.Text = ""
})

# Inicia o formulario
$GUI.ShowDialog() # Desenha na tela todos os componentes adicionados ao formulario