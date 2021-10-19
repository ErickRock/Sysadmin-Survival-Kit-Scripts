# Funcao para pegar a pasta
Function Localizar-Pasta {
    try {
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
        $OpenFileDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $OpenFileDialog.ShowDialog() | Out-Null
        $caminhoPasta = $OpenFileDialog.SelectedPath
        return $caminhoPasta
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host $ErrorMessage # Exibe a mensagem de erro
    }
}

# Faz o backup
function Fazer-Backup {
    param (
        [parameter(position=0, Mandatory=$True)]
        $origem,
        [parameter(position=1, Mandatory=$True)]
        $destino
    )

    # Faz a copia
    try {
        Copy-Item "$origem\*" -Destination "$destino" -Recurse -Force # Copia o arquivo
        $retorno = "Procedimento concluido"
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        $retorno = "Erro: $ErrorMessage"
    }

    # Retorna a resposta da funcao
    return $retorno
    
}

# Interface Grafica: 
# Formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
Add-Type -AssemblyName PresentationFramework # Recebe a biblioteca de mensagens
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal
$GUI.Text ='Fazer Backup' # Titulo
$GUI.Size = New-Object System.Drawing.Size(320,130) # Define o tamanho
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Pasta de origem
$lblOrigem = New-Object System.Windows.Forms.Label # Cria a label
$lblOrigem.Text = "Pasta origem:" # Define um texto para ela
$lblOrigem.Location  = New-Object System.Drawing.Point(0,10) # Define em qual coordenada da tela vai ser desenhado
$lblOrigem.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblOrigem) # Adiciona ao formulario principal
# Botao para escolher o diretorio
$btnOrigem = New-Object System.Windows.Forms.Button # Cria um botao
$btnOrigem.Location = New-Object System.Drawing.Size(100,10) # Define em qual coordenada da tela vai ser desenhado
$btnOrigem.Size = New-Object System.Drawing.Size(200,18) # Define o tamanho
$btnOrigem.Text = "Definir pasta" # Define o texto
$GUI.Controls.Add($btnOrigem) # Adiciona ao formulario principal

# Pasta de destino
$lblDestino = New-Object System.Windows.Forms.Label # Cria a label
$lblDestino.Text = "Pasta destino:" # Define um texto para ela
$lblDestino.Location  = New-Object System.Drawing.Point(0,30) # Define em qual coordenada da tela vai ser desenhado
$lblDestino.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblDestino) # Adiciona ao formulario principal
# Botao para escolher o diretorio
$btnDestino = New-Object System.Windows.Forms.Button # Cria um botao
$btnDestino.Location = New-Object System.Drawing.Size(100,30) # Define em qual coordenada da tela vai ser desenhado
$btnDestino.Size = New-Object System.Drawing.Size(200,18) # Define o tamanho
$btnDestino.Text = "Definir pasta" # Define o texto
$GUI.Controls.Add($btnDestino) # Adiciona ao formulario principal

# Botao para fazer o procedimento
$btnFazerBackup = New-Object System.Windows.Forms.Button # Cria um botao
$btnFazerBackup.Location = New-Object System.Drawing.Size(5,50) # Define em qual coordenada da tela vai ser desenhado
$btnFazerBackup.Visible = $false # Deixa desativado
$btnFazerBackup.Size = New-Object System.Drawing.Size(300,25) # Define o tamanho
$btnFazerBackup.Text = "Fazer Backup" # Define o texto
$GUI.Controls.Add($btnFazerBackup) # Adiciona ao formulario principal

# Label para salvar dados
$ProdOrigem = New-Object System.Windows.Forms.Label # Cria a label
$ProdOrigem.Text = "" # Coloca um texto em branco
$ProdOrigem.Visible = $false # Deixa invisivel na inicializacao
$ProdOrigem.Location  = New-Object System.Drawing.Point(0,15) # Define em qual coordenada da tela vai ser desenhado
$ProdOrigem.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($ProdOrigem) # Adiciona ao formulario principal
$ProdDestino = New-Object System.Windows.Forms.Label # Cria a label
$ProdDestino.Text = "" # Coloca um texto em branco
$ProdDestino.Visible = $false # Deixa invisivel na inicializacao
$ProdDestino.Location  = New-Object System.Drawing.Point(0,15) # Define em qual coordenada da tela vai ser desenhado
$ProdDestino.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($ProdDestino) # Adiciona ao formulario principal

# Label para receber o retorno do procedimento
$lblRetorno = New-Object System.Windows.Forms.Label # Cria a label
$lblRetorno.Text = "" # Coloca um texto em branco
$lblRetorno.Location  = New-Object System.Drawing.Point(0,50) # Define em qual coordenada da tela vai ser desenhado
$lblRetorno.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblRetorno) # Adiciona ao formulario principal

# Evento do Botao Diretorio de origem
$btnOrigem.Add_Click({
    $caminhoPasta = Localizar-Pasta # Recebe a pasta
    $ProdOrigem.Text = $caminhoPasta # Salva caminho selecionado
    $lblRetorno.Text = "Selecione uma pasta destino"
})

# Evento do Botao Diretorio de destino
$btnDestino.Add_Click({
    $caminhoPasta = Localizar-Pasta # Recebe a pasta
    $ProdDestino.Text = $caminhoPasta # Salva caminho selecionado
    $btnFazerBackup.Visible = $true # Ativa o botão
})

# Evento do Botao de backup
$btnFazerBackup.Add_Click({
    # Recebe os dados
    $lblRetorno.Text = "Fazendo a copia..."
    $origem = $ProdOrigem.Text
    $destino = $ProdDestino.Text
    # Faz o procedimento e exibe
    $retono = Fazer-Backup $origem $destino
    $lblRetorno.Text = "$retono"
    # Limpa as caixas
    $btnFazerBackup.Visible = $false
    $ProdOrigem.Text = ""
    $ProdDestino.Text = ""
})

# Inicia o formulario
$GUI.ShowDialog() # Desenha na tela todos os componentes adicionados ao formulario