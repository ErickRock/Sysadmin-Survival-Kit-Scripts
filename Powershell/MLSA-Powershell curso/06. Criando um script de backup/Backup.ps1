# Funcao para validar as pastas
# Vamos modifica-la para esse projeto, passando como parametro o caminho completo
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
        # Informamos que a pasta já existe
        Write-Host "Já existe o diretorio: $caminhoPasta"
    } 
    # Se a pasta existe, executamos o bloco de codigo
    else {
        # Executar o comando de criação de pasta
        $esconderRetorno = New-Item -Path "$caminhoPasta" -ItemType "Directory" # Vamos jogar isso numa variavel para nao aparecer o retorno padrao na tela
        # Mostrar mensagem de confirmação na tela
        Write-Host "Criado diretorio: $caminhoPasta"
    }
}

# Configuracoes
# Como a ideia é criar um script automatizado, vamos definir os caminhos nessa seção, para não precisarmos informar durante o uso
$raizBackup = "$env:USERPROFILE\OneDrive\Backups" # Caminho comum do OneDrive, pode variar caso tenha modificado algo no sistema
$caminhoLista = "$env:USERPROFILE\Desktop\pastasBackups.txt" # Coloquei para pegar da area de trabalho

# Validando se a pasta raiz já existe
Validar-Pasta $raizBackup

# Criando nosso identificador
$identificador = Get-Date -Format hhmmss-ddMMyy
# Configurando nossa pasta destino
$pastaBackup = "$raizBackup\$identificador"
# Criamos nossa pasta destino
Validar-Pasta $pastaBackup

# Recebe as pastas da lista
$pastas = Get-Content -Path $caminhoLista
# Fazemos o processo para cada pasta na lista
foreach ($pasta in $pastas) {
    try {
        # Recebendo o nome da pasta com base no caminho
        $infoPasta = Get-ItemProperty $pasta
        $nomePasta = $infoPasta.Name
        Compress-Archive -Path "$pasta\*" -DestinationPath $pastaBackup\$nomePasta.zip
        Write-Host "Feito o Backup da pasta $nomePasta"
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Ocorreu um erro durante o backup da pasta $nomePasta" # Mostra a mensagem
        Write-Host "Erro: $ErrorMessage"
    }
}

# Informa que o procedimento foi concluido
Write-Host "O script terminou"