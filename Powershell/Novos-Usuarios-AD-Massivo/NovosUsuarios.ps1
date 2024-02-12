# Novo Usuario - Interface Grafica
# Ivo Dias

# Funcao para limpar a tela
function Limpar-Tela {
    # Limpa os campos
    $txtOU.Text = ""
    $txtReferencia.Text = ""
    $txtEmailAntigo.Text = ""
    $txtCSV.Text = ""
    # Retorna ao padrao
    $Button.Enabled = $false
    $btnArquivo.Text = "Escolher arquivo"
}

# Formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
Add-Type -AssemblyName PresentationFramework # Recebe a biblioteca de mensagens
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal
$GUI.Text ='TI - Novos Usuarios no AD' # Titulo
$GUI.AutoSize = $true # Configura para aumentar caso necessario
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Importacao dos modulos
Set-ExecutionPolicy Bypass -force # Atribui a permissao
$moduloPadrao = "$PSScriptRoot\Funcoes\ModuloPadrao.psm1" # Define o caminho do modulo
Unblock-File -Path $moduloPadrao # Desbloqueia o arquivo
Import-Module $moduloPadrao -Force # Carrega o modulo
$moduloUsuario = "$PSScriptRoot\Funcoes\NovosUsuarios-Padrao.psm1" # Define o caminho do modulo
Unblock-File -Path $moduloUsuario # Desbloqueia o arquivo
Import-Module $moduloUsuario -Force # Carrega o modulo

# Configuracoes gerais
$CredencialAdministrador = Credencial-AD "$PSScriptRoot\Credenciais"
$caminhoLOGs = "$PSScriptRoot\LOGs"

# OU
$lblOU = New-Object System.Windows.Forms.Label # Cria a label de indentificacao
$lblOU.Text = "Nome OU:" # Configura o texto
$lblOU.Location  = New-Object System.Drawing.Point(0,10) # Define a localizacao
$lblOU.AutoSize = $true # Configura o tamanho automatico
$GUI.Controls.Add($lblOU) # Adiciona ao formulario principal
$txtOU = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto para o nome
$txtOU.Width = 300 # Configura o tamanho
$txtOU.Location  = New-Object System.Drawing.Point(80,10) # Define a localizacao
$GUI.Controls.Add($txtOU) # Adiciona ao formulario principal

# Usuario de referencia
$lblReferencia = New-Object System.Windows.Forms.Label # Cria a label de indentificacao
$lblReferencia.Text = "Referencia:" # Configura o texto
$lblReferencia.Location  = New-Object System.Drawing.Point(0,30) # Define a localizacao
$lblReferencia.AutoSize = $true # Configura o tamanho automatico
$GUI.Controls.Add($lblReferencia) # Adiciona ao formulario principal
$txtReferencia = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtReferencia.Width = 300 # Configura o tamanho
$txtReferencia.Location  = New-Object System.Drawing.Point(80,30) # Define a localizacao
$GUI.Controls.Add($txtReferencia) # Adiciona ao formulario principal

# Caminho do CSV
$lblCSV = New-Object System.Windows.Forms.Label # Cria a label de indentificacao
$lblCSV.Text = "CSV:" # Configura o texto
$lblCSV.Location  = New-Object System.Drawing.Point(0,50) # Define a localizacao
$lblCSV.AutoSize = $true # Configura o tamanho automatico
$GUI.Controls.Add($lblCSV) # Adiciona ao formulario principal
$txtCSV = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtCSV.Visible = $false # Deixa invisivel
$txtCSV.Location  = New-Object System.Drawing.Point(80,50) # Define a localizacao
$GUI.Controls.Add($txtCSV) # Adiciona ao formulario principal
# Botao para escolher o arquivo
$btnArquivo = New-Object System.Windows.Forms.Button # Cria um botao
$btnArquivo.Location = New-Object System.Drawing.Size(80,50) # Define em qual coordenada da tela vai ser desenhado
$btnArquivo.Size = New-Object System.Drawing.Size(300,20) # Define o tamanho
$btnArquivo.Text = "Escolher arquivo" # Define o texto
$GUI.Controls.Add($btnArquivo) # Adiciona ao formulario principal

# Botao de Criar
$btnNovoUsuario = New-Object System.Windows.Forms.Button # Cria o botao
$btnNovoUsuario.Location = New-Object System.Drawing.Size(400,12) # Define a localizacao
$btnNovoUsuario.Size = New-Object System.Drawing.Size(120,50) # Configura o tamanho
$btnNovoUsuario.Text = "Criar" # Configura o texto
$GUI.Controls.Add($btnNovoUsuario) # Adiciona ao formulario principal

# Campo de retorno
$lblResposta = New-Object System.Windows.Forms.Label # Cria a label para receber o retorno
$lblResposta.Text = "" # Coloca o texto inicial vazio
$lblResposta.Location  = New-Object System.Drawing.Point(0,170) # Define a localizacao
$lblResposta.AutoSize = $true # Configura o tamanho automatico
$GUI.Controls.Add($lblResposta) # Adiciona ao formulario principal

# Label de retorno 2 linha
$lbl2linha = New-Object System.Windows.Forms.Label # Cria a label para receber o retorno
$lbl2linha.Text = "" # Coloca o texto inicial vazio
$lbl2linha.Location  = New-Object System.Drawing.Point(0,200) # Define a localizacao
$lbl2linha.AutoSize = $true # Configura o tamanho automatico
$GUI.Controls.Add($lbl2linha) # Adiciona ao formulario principal

# Evento do Botao para localizar o arquivo
$btnArquivo.Add_Click({
    # Limpa a tela
    $lblResposta.Text = ""
    $lbl2linha.Text = ""
    $caminhoPasta = Localizar-Arquivo # Recebe a pasta onde o arquivo CSV esta
    $btnArquivo.Text = $caminhoPasta # Exibe o caminho selecionado
    $txtCSV.Text = $caminhoPasta # Salva o caminho selecionado
    $btnNovoUsuario.Enabled = $true # Torna utilizavel
})

# Evento do Botao para criar um novo usuario
$btnNovoUsuario.Add_Click({
    try {
        $hash = Get-Date -Format yyyyMMddTHHmmssffff
        $lblResposta.Text = "Aguarde o procedimento"
        $lbl2linha.Text = "Mais detalhes em: $caminhoLOGs"
        # Recebe os valores dos campos    
        $OU = $txtOU.Text
        $UsuarioReferencia = $txtReferencia.Text
        $CaminhoCSV = $txtCSV.Text
        # Recebe os valores do CSV
        $Identificacoes = 'Nome', 'Sobrenome'
        $usuarios = Import-Csv -Path "$CaminhoCSV" -Header $Identificacoes
        # Faz o procedimento
        foreach ($usuario in $usuarios) {
            $Nome = $usuario.Nome
            $Sobrenome = $usuario.Sobrenome
            Novo-UsuarioAD "$Nome" "$Sobrenome" $CredencialAdministrador "$UsuarioReferencia" "$OU" "$hash" "empresa.com.br" "$caminhoLOGs"
        }
        $resposta = "Procedimento concluido"
    }
    catch {
        # Reporta o erro, caso ocorra
        $ErrorMessage = $_.Exception.Message
        $resposta = "|Algo de muito errado aconteceu|"
        $Linha2 = "|Erro: $ErrorMessage|"
    }
    # Escreve o retorno e limpa a tela
    $lblResposta.Text = $resposta
    $lbl2linha.Text = $Linha2
    Limpar-Tela
})

# Inicia o formulario
$GUI.ShowDialog()