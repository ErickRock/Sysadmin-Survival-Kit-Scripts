# Configuracoes
$urlDownload = "https://github.com/IGDEXE/MLSA-Powershell/archive/main.zip"
$pastaMyGIT = "C:\MyGIT"
$arquivoDownload = "$env:LOCALAPPDATA/GIT.zip"

# Configurando o Narrador 
Add-Type -AssemblyName System.speech # Adiciona biblioteca
$narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer # Cria narrador 

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
        Write-Host "Já existe o diretorio: $nomePasta"
        $narrador.Speak("Já existe o diretorio: $nomePasta")
    } 
    # Se a pasta existe, executamos o bloco de codigo
    else {
        # Executar o comando de criação de pasta
        $esconderRetorno = New-Item -Path "$caminhoPasta" -ItemType "Directory" # Vamos jogar isso numa variavel para nao aparecer o retorno padrao na tela
        # Recebendo o nome da pasta com base no caminho
        $infoPasta = Get-ItemProperty $caminhoPasta
        $nomePasta = $infoPasta.Name
        # Mostrar mensagem de confirmação na tela
        Write-Host "Criado diretorio: $nomePasta"
        $narrador.Speak("Criado diretorio: $nomePasta")
    }
}

# Para limpar a tela
Clear-Host

try {
    # Cria a pasta na raiz do sistema
    Validar-Pasta $pastaMyGIT
    # Faz o download do arquivo
    Write-Host "Fazendo o download"
    $narrador.Speak("Fazendo o download")
    Invoke-WebRequest -Uri "$urlDownload" -OutFile "$arquivoDownload"
    # Descompacta para a pasta que criamos
    Write-Host "Descompactando.."
    $narrador.Speak("Descompactando..")
    Expand-Archive -Path "$arquivoDownload" -DestinationPath "$pastaMyGIT" -Force
    # Limpa a instalacao
    Write-Host "Otimizando armazenamento.."
    $narrador.Speak("Otimizando armazenamento..")
    Remove-Item -Path "$arquivoDownload" -Force
    # Conclui o processo
    Write-Host "Configuração concluida"
    $narrador.Speak("Configuração concluida")
    Write-Host "Disponivel em: $pastaMyGIT"
    $narrador.Speak("Disponivel em: $pastaMyGIT")
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Ocorreu um problema" # Mostra a mensagem
    $narrador.Speak("Ocorreu um problema")
    Write-Host "Erro: $ErrorMessage"
    $narrador.Speak("Erro: $ErrorMessage")
}