# RPA GUI - Admissão
# Ivo Dias e Leonardo Belli
# Versao 12.0

# Criacao do formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal

# Limpar tela
function Limpar-Tela {

    $txtPrimeiroNomeUsuario.Text = ""
    $txtSobrenomeUsuario.Text = ""
    $txtNomeUsuarioAD.Text = ""
    $txtUsuarioReferencia.Text = ""
    $txtContratoUsuario.Text = ""
    $txtCargoUsuario.Text = ""
    #$txtAreaUsuario.Text = ""
    $cbxSetores.selectedItem = ""
}

# Verifica as OUs
function Listar-OUs {
    $nomeDominio = (Get-ADDomain).Name # Recebe o nome do Dominio
    $dominioCompleto = (Get-ADDomain).DistinguishedName # Recebe o endereco completo
    $ouBase = "OU=$nomeDominio,$dominioCompleto" # Define a OU base para a pesquisa
    $OUs = Get-ADOrganizationalUnit -SearchBase $ouBase -Filter * -SearchScope OneLevel # Busca todas as OU dentro dela
    $nomeOUs = $OUs.Name # Recupera o nome das OUs
    return $nomeOUs # Retorna o valor
}

# Recebe o nome dos usuarios
function Listar-Usuarios {
    $nomeUsuarios = (Get-ADUser -Filter *).samaccountname # Recebe o login de todos os usuarios
    $nomeUsuarios = $nomeUsuarios | sort-object # Organiza em ordem alfabetica
    return $nomeUsuarios # Retorna o valor
}

# Configura o formulario principal
$GUI.Text ='S.U.M - Admissao' # Titulo
$GUI.AutoSize = $true # Configura para aumentar caso necessario
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Configuracoes gerais
Set-ExecutionPolicy Bypass -force # Atribui a permissao
$moduloAdmissao = "\\servidor\Config\Admissao.psm1" # Define o caminho do modulo
Unblock-File -Path $moduloAdmissao # Desbloqueia o arquivo
Import-Module $moduloAdmissao -Force # Carrega o modulo
$logPadrao = "Ultimo retorno:`r`n`r`n" # Configura o log padrao ----------------------------------------------------------

# Label do texto - Usuário ID
$lblPrimeiroNomeUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblPrimeiroNomeUsuario.Text = "Primeiro nome do usuario:" # Define um texto para ela
$lblPrimeiroNomeUsuario.Location  = New-Object System.Drawing.Point(0,10) # Define em qual coordenada da tela vai ser desenhado
$lblPrimeiroNomeUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblPrimeiroNomeUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtPrimeiroNomeUsuario = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtPrimeiroNomeUsuario.Width = 302 # Configura o tamanho
$txtPrimeiroNomeUsuario.Location  = New-Object System.Drawing.Point(140,10) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtPrimeiroNomeUsuario) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblSobrenomeUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblSobrenomeUsuario.Text = "Sobrenome completo do usuario:" # Define um texto para ela
$lblSobrenomeUsuario.Location  = New-Object System.Drawing.Point(0,40) # Define em qual coordenada da tela vai ser desenhado
$lblSobrenomeUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblSobrenomeUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtSobrenomeUsuario = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtSobrenomeUsuario.Width = 272 # Configura o tamanho
$txtSobrenomeUsuario.Location  = New-Object System.Drawing.Point(170,40) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtSobrenomeUsuario) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblNomeUsuarioAD = New-Object System.Windows.Forms.Label # Cria a label
$lblNomeUsuarioAD.Text = "Sobrenome do usuario escolhido:" # Define um texto para ela
$lblNomeUsuarioAD.Location  = New-Object System.Drawing.Point(0,70) # Define em qual coordenada da tela vai ser desenhado
$lblNomeUsuarioAD.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblNomeUsuarioAD) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtNomeUsuarioAD = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtNomeUsuarioAD.Width = 272 # Configura o tamanho
$txtNomeUsuarioAD.Location  = New-Object System.Drawing.Point(170,70) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtNomeUsuarioAD) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblUsuarioReferencia = New-Object System.Windows.Forms.Label # Cria a label
$lblUsuarioReferencia.Text = "Usuario de referencia (nome.sobrenome):" # Define um texto para ela
$lblUsuarioReferencia.Location  = New-Object System.Drawing.Point(0,100) # Define em qual coordenada da tela vai ser desenhado
$lblUsuarioReferencia.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblUsuarioReferencia) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtUsuarioReferencia = New-Object System.Windows.Forms.ComboBox # Cria a caixa de texto
$txtUsuarioReferencia.Width = 229 # Configura o tamanho
$txtUsuarioReferencia.Location  = New-Object System.Drawing.Point(213,100) # Define em qual coordenada da tela vai ser desenhado
$Usuarios = Listar-Usuarios # Recebe os setores
foreach ($usuario in $Usuarios) {
    $txtUsuarioReferencia.Items.Add($usuario) # Adiciona como opcao cada um dos usuarios
}
$GUI.Controls.Add($txtUsuarioReferencia) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblContratoUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblContratoUsuario.Text = "Tipo de contrato do usuario:" # Define um texto para ela
$lblContratoUsuario.Location  = New-Object System.Drawing.Point(0,130) # Define em qual coordenada da tela vai ser desenhado
$lblContratoUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblContratoUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtContratoUsuario = New-Object System.Windows.Forms.ComboBox # Cria a caixa de texto
$txtContratoUsuario.Width = 297 # Configura o tamanho
$txtContratoUsuario.Location  = New-Object System.Drawing.Point(145,130) # Define em qual coordenada da tela vai ser desenhado
$txtContratoUsuario.Items.Add("CLT") # Adiciona como opcao cada um dos tipos de contratos
$txtContratoUsuario.Items.Add("PJ") # Adiciona como opcao cada um dos tipos de contratos
$GUI.Controls.Add($txtContratoUsuario) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblCargoUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblCargoUsuario.Text = "Cargo do usuario:" # Define um texto para ela
$lblCargoUsuario.Location  = New-Object System.Drawing.Point(0,160) # Define em qual coordenada da tela vai ser desenhado
$lblCargoUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblCargoUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$txtCargoUsuario = New-Object System.Windows.Forms.ComboBox # Cria a caixa de texto
$txtCargoUsuario.Width = 347 # Configura o tamanho
$txtCargoUsuario.Items.Add("Alocado") # Adiciona como opcao um tipo de cargo
$txtCargoUsuario.Items.Add("Operacional") # Adiciona como opcao um tipo de cargo
$txtCargoUsuario.Items.Add("Gerencia") # Adiciona como opcao um tipo de cargo
$txtCargoUsuario.Location  = New-Object System.Drawing.Point(95,160) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtCargoUsuario) # Adiciona ao formulario principal

# Label do texto - Usuário ID
$lblAreaUsuario = New-Object System.Windows.Forms.Label # Cria a label
$lblAreaUsuario.Text = "Area do usuario:" # Define um texto para ela
$lblAreaUsuario.Location  = New-Object System.Drawing.Point(0,190) # Define em qual coordenada da tela vai ser desenhado
$lblAreaUsuario.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblAreaUsuario) # Adiciona ao formulario principal

# Caixa de texto para receber a identificação do usuário a ser deligado
$cbxSetores = New-Object System.Windows.Forms.ComboBox # Cria a Combobox dos setores
$cbxSetores.Width = 354 # Configura o tamanho
$cbxSetores.Location  = New-Object System.Drawing.Point(88,190) # Define a localizacao
$Setores = Listar-OUs # Recebe os setores
foreach ($setor in $Setores) {
    $cbxSetores.Items.Add($setor) # Adiciona como opcao cada um dos setores
}
$GUI.Controls.Add($cbxSetores) # Adiciona ao formulario principal

# Caixa de texto exibir o log da ação
$txtRetorno = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$txtRetorno.Multiline = $true
$txtRetorno.Enabled = $false
$txtRetorno.Size = New-Object System.Drawing.Size(407,250) # Define o tamanho
$txtRetorno.Location  = New-Object System.Drawing.Point(20,250) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($txtRetorno) # Adiciona ao formulario principal

# Botao para realizar a admissao do usuário
$btnNovoUsuario = New-Object System.Windows.Forms.Button # Cria um botao
$btnNovoUsuario.Location = New-Object System.Drawing.Size(140,220) # Define em qual coordenada da tela vai ser desenhado
$btnNovoUsuario.Size = New-Object System.Drawing.Size(150,20) # Define o tamanho
$btnNovoUsuario.Text = "Criar novo usuario" # Define o texto
$GUI.Controls.Add($btnNovoUsuario) # Adiciona ao formulario principal

# Evento do botao
$btnNovoUsuario.Add_Click({
    try {
        # Recebimento de dados

        # Recebe o primeiro nome do usuário
        $PrimeiroNomeUsuario = $txtPrimeiroNomeUsuario.Text
        # Recebe o sobrenome do usuário
        $SobrenomeUsuario = $txtSobrenomeUsuario.Text
        # Recebe nome escolhido do AD
        $NomeUsuarioAD = $txtNomeUsuarioAD.Text
        # Recebe o usuario referência
        $UsuarioReferencia = $txtUsuarioReferencia.Text
        # Recebe o tipo de contrato do usuário
        $ContratoUsuario = $txtContratoUsuario.Text
        # Recebe o cargo do usuário
        $CargoUsuario = $txtCargoUsuario.Text
        # Recebe a área do usuário
        $AreaUsuario = $cbxSetores.selectedItem

        # Faz o procedimento 
        $logProcedimento = NovoUsuario $PrimeiroNomeUsuario $SobrenomeUsuario $NomeUsuarioAD $UsuarioReferencia $ContratoUsuario $CargoUsuario $AreaUsuario
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
        $logProcedimento = "Erro: $ErrorMessage" # Log de erro
    }

    Limpar-Tela
    # Retorna o Log na tela
    $txtRetorno.Text = $logPadrao + $logProcedimento

})

# Inicia o formulario
$GUI.ShowDialog() # Desenha na tela todos os componentes adicionados ao formulario
