# GUI - Desligamento
# Ivo Dias

# Criacao do formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal

# Configura o formulario principal
$GUI.Text ='S.U.M - Desligamento' # Titulo
$GUI.AutoSize = $true # Configura para aumentar caso necessario
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Configuracoes gerais
Set-ExecutionPolicy Bypass -force # Atribui a permissao
$moduloDesligamento = "\\servidor\Config\Desligamento-V8.psm1" # Define o caminho do modulo
Unblock-File -Path $moduloDesligamento # Desbloqueia o arquivo
Import-Module $moduloDesligamento -Force # Carrega o modulo
$logPadrao = "Ultimo retorno:`r`n`r`n" # Configura o log padrao

# Label do texto - Usuário ID
$lblUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblUsuario.Text = "Usuario:" # Define um texto para ela
$lblUsuario.Location  = New-Object System.Drawing.Point(0,10) # Define em qual coordenada da tela vai ser desenhado
$lblUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtUsuario = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtUsuario.Width = 150 # Configura o tamanho
$txtUsuario.Location  = New-Object System.Drawing.Point(50,10) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtUsuario) # Adiciona ao formulario principal

# Botao para realizar o desligamento do usuário
$btnDesligar = New-Object System.Windows.Forms.Button # Cria um botao
$btnDesligar.Location = New-Object System.Drawing.Size(210,10) # Define em qual coordenada da tela vai ser desenhado
$btnDesligar.Size = New-Object System.Drawing.Size(80,20) # Define o tamanho
$btnDesligar.Text = "Desligar" # Define o texto
$GUI.Controls.Add($btnDesligar) # Adiciona ao formulario principal

# Caixa de texto exibir o log da ação
$txtRetorno = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtRetorno.Multiline = $true
$txtRetorno.Enabled = $false
$txtRetorno.Size = New-Object System.Drawing.Size(250,250) # Define o tamanho
$txtRetorno.Location  = New-Object System.Drawing.Point(20,50) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtRetorno) # Adiciona ao formulario principal

# Evento do botao
$btnDesligar.Add_Click({
    try {
        # Recebe o usuario
        $usuarioIdentidade = $txtUsuario.Text
        $txtRetorno.Text = "Aguarde, em processamento..."
        # Faz o procedimento 
        $logProcedimento = DesligarUsuario $usuarioIdentidade
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        $logProcedimento = "Erro: $ErrorMessage" # Log de erro
    }

    # Retorna o Log na tela
    $txtRetorno.Text = $logPadrao + $logProcedimento

})
# Inicia o formulario
$GUI.ShowDialog() # Desenha na tela todos os componentes adicionados ao formulario