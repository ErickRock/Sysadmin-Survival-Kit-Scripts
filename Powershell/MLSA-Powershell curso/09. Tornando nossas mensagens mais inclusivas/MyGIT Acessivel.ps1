# Configuracoes
$urlDownload = "https://github.com/IGDEXE/MLSA-Powershell/archive/main.zip"
$pastaMyGIT = "C:\MyGIT"
$arquivoDownload = "$env:LOCALAPPDATA/GIT.zip"

# Funcao para retornos acessiveis
function Mensagem-Acessivel {
    param (
        $texto
    )
    # Configurando o Narrador 
    Add-Type -AssemblyName System.speech # Adiciona biblioteca
    $narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer # Cria narrador
    # Retorna as mensagens
    Write-Host "$texto"
    $narrador.Speak("$texto")
}

# Funcao para criar pastas
function Validar-Pasta {
    param (
        # Aqui definimos qual a posicao e se é obrigatorio ou nao o parametro
        # O contador de posicoes comeca em 0, é importante lembrar disso
        [parameter(position=0,Mandatory=$True)]
        $caminhoPasta
    )
    # Validamos se o caminho existe, salvando a resposta em uma variavel
    $pastaValidacao = Test-Path -Path "$caminhoPasta"

    # Se ela já existe, exibimos uma mensagem de erro
    if ($pastaValidacao) {
        # Recebendo o nome da pasta com base no caminho
        $infoPasta = Get-ItemProperty $caminhoPasta
        $nomePasta = $infoPasta.Name
        # Informamos que a pasta já existe
        Mensagem-Acessivel "Já existe o diretorio: $nomePasta"
    } 
    # Se a pasta existe, executamos o bloco de codigo
    else {
        # Executar o comando de criação de pasta
        $esconderRetorno = New-Item -Path "$caminhoPasta" -ItemType "Directory" # Vamos jogar isso numa variavel para nao aparecer o retorno padrao na tela
        # Recebendo o nome da pasta com base no caminho
        $infoPasta = Get-ItemProperty $caminhoPasta
        $nomePasta = $infoPasta.Name
        # Mostrar mensagem de confirmação na tela
        Mensagem-Acessivel "Criado diretorio: $nomePasta"
    }
}

# Para limpar a tela
Clear-Host

try {
    # Cria a pasta na raiz do sistema
    Validar-Pasta $pastaMyGIT
    # Faz o download do arquivo
    Mensagem-Acessivel "Fazendo o download"
    Invoke-WebRequest -Uri "$urlDownload" -OutFile "$arquivoDownload"
    # Descompacta para a pasta que criamos
    Mensagem-Acessivel "Descompactando.."
    Expand-Archive -Path "$arquivoDownload" -DestinationPath "$pastaMyGIT" -Force
    # Limpa a instalacao
    Mensagem-Acessivel "Otimizando armazenamento.."
    Remove-Item -Path "$arquivoDownload" -Force
    # Conclui o processo
    Mensagem-Acessivel "Configuração concluida"
    Mensagem-Acessivel "Disponivel em: $pastaMyGIT"
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Mensagem-Acessivel "Ocorreu um problema" # Mostra a mensagem
    Mensagem-Acessivel "Erro: $ErrorMessage"
}