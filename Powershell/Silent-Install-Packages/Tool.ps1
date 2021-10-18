# Gerenciador de instalacoes silenciosas
# Ivo Dias

function Escreva-Instalador {
    param (
        [parameter(position=0, Mandatory=$True)]
        $NomeSoftware,
        [parameter(position=1, Mandatory=$True)]
        $Path,
        [parameter(position=2, Mandatory=$True)]
        $instalador,
        [parameter(position=3, Mandatory=$True)]
        $Parametro,
        [parameter(position=4, Mandatory=$True)]
        $SoftwarePath,
        [parameter(position=5, Mandatory=$True)]
        $ScriptPath
    )

    # Configuracoes gerais
    $versao = Get-Date -Format yyyyMMddThhmmss # Gera a versao

    # Verifica se as pastas estao criadas
    function Validar-Pasta {
        param (
            [parameter(position=0,Mandatory=$True)]
            $caminho
        )
        # Verifica se ja existe
        $Existe = Test-Path -Path $caminho
        # Cria a pasta
        if ($Existe -eq $false) {
            try {
                $noReturn = New-Item -ItemType directory -Path $caminho # Cria a pasta
            }
            catch {
                exit
            }
        }
    }

    # Escreve a funcao em Powershell
    function Escreva-Powershell {
        param (
            [parameter(position=0, Mandatory=$True)]
            $NomeSoftware,
            [parameter(position=1, Mandatory=$True)]
            $Path,
            [parameter(position=2, Mandatory=$True)]
            $instalador,
            [parameter(position=3, Mandatory=$True)]
            $Parametro,
            [parameter(position=4, Mandatory=$True)]
            $SoftwarePath,
            [parameter(position=5, Mandatory=$True)]
            $ScriptPath,
            [parameter(position=6, Mandatory=$True)]
            $Versao
        )

        # Cabecalho
        $padrao = "# Script de instalacao do $NomeSoftware
# Gerado pela ferramenta desenvolvida por IGD753
# Versao $versao"

        # Biblioteca de funcoes:
        # Configuracoes gerais
        $configuracoesGerais = "
# Configuracoes gerais
@#%PastaTI = &&&C:\TI&&& # Define o caminho padrao da pasta de Logs
@#%pastaLOGs = &&&@#%PastaTI\LOGs&&& # Configura a pasta para os Desligamentos
@#%identificacao = Get-Date -Format LOG@ddMMyyyymmss # Cria um codigo baseado no dia mes ano (02102019)
@#%identificacao += &&&.txt&&& # Atribui um tipo ao log
@#%pastaOk = &&&@#%pastaLOGs\OK&&& # Define a pasta de logs que funcionaram
@#%pastaErro = &&&@#%pastaLOGs\Erro&&& # Define a pasta de logs que nao funcionaram
@#%pastaAndamento = &&&@#%pastaLOGs\Agora&&& # Define a pasta de logs que estao em andamento
@#%LogOk = &&&@#%pastaOk\@#%identificacao&&& # Define o arquivo de logs que funcionaram
@#%LogErro = &&&@#%pastaErro\@#%identificacao&&& # Define o arquivo de que não funcionaram
@#%LogAndamento = &&&@#%pastaAndamento\@#%identificacao&&& # Define o arquivo dos que estao em andamento"
        $configuracoesGerais = $configuracoesGerais -replace "@#%", '$' # Altera os valores para deixar o texto com as variaveis
        $configuracoesGerais = $configuracoesGerais -replace "&&&", '"' # Altera os valores para configurar as ""

        # Validar Pastas
        $funcaoValidarPastas = "
# Verifica se as pastas estao criadas
function Validar-Pasta {
    param (
        [parameter(position=0,Mandatory=@#%True)]
        @#%caminho
    )
    # Verifica se ja existe
    @#%Existe = Test-Path -Path @#%caminho
    # Cria a pasta
    if (@#%Existe -eq @#%false) {
        try {
            @#%noReturn = New-Item -ItemType directory -Path @#%caminho # Cria a pasta
        }
        catch {
            exit
        }
    }
}"
        $funcaoValidarPastas = $funcaoValidarPastas -replace "@#%", '$' # Altera os valores para deixar o texto com as variaveis

        # Validacao dos caminhos
        $validacaoCaminhos = "
# Validacao dos caminhos
Validar-Pasta @#%PastaINFRA
Validar-Pasta @#%pastaLOGs
Validar-Pasta @#%pastaOk
Validar-Pasta @#%pastaErro
Validar-Pasta @#%pastaAndamento"
        $validacaoCaminhos = $validacaoCaminhos -replace "@#%", '$' # Altera os valores para deixar o texto com as variaveis

        # Instalacao de software
        $funcaoInstalarPrograma = "
# Funcao para instalar programas
function Instalar-Software {
    param (
            [parameter(position=0, Mandatory=@#%True)]
            @#%NomeSoftware,
            [parameter(position=1, Mandatory=@#%True)]
            @#%Path,
            [parameter(position=2, Mandatory=@#%True)]
            @#%instalador,
            [parameter(position=3, Mandatory=@#%True)]
            @#%Parametro,
            [parameter(position=4, Mandatory=@#%True)]
            @#%SoftwarePath
        )
        # Verifica se o programa esta instalado
        if (@#%SoftwarePath -eq @#%false) {
            try {
                Add-Content -Path &&&@#%LogAndamento&&& -Value &&&@#%NomeSoftware : Copiando os arquivos&&& # Grava o log
                Copy-Item &&&@#%Path\@#%instalador&&& -Destination &&&@#%PastaINFRA&&& -Force # Copia o arquivo
                Add-Content -Path &&&@#%LogAndamento&&& -Value &&&@#%NomeSoftware : Instalando..&&& # Grava o log
                cmd /c &&&@#%PastaINFRA\@#%instalador @#%Parametro&&& # Faz a instalacao
                Add-Content -Path &&&@#%LogOk&&& -Value &&&@#%NomeSoftware : Instalado&&& # Grava o log
                Remove-Item -Path &&&@#%LogAndamento&&& -Force # Remove o log em Andamento
            }
            catch {
                @#%ErrorMessage = @#%_.Exception.Message # Recebe o erro
                Add-Content -Path &&&@#%LogErro&&& -Value &&&@#%NomeSoftware : @#%ErrorMessage&&& # Grava o log
            }
        } else {
            Add-Content -Path &&&@#%LogOk&&& -Value &&&@#%NomeSoftware ja esta instalado&&&
        }
    }"
        $funcaoInstalarPrograma = $funcaoInstalarPrograma -replace "@#%", '$' # Altera os valores para deixar o texto com as variaveis
        $funcaoInstalarPrograma = $funcaoInstalarPrograma -replace "&&&", '"' # Altera os valores para configurar as ""

        # Parametros
        $parametros = "
    # Parametros
    @#%NomeSoftware = &&&$NomeSoftware&&&
    @#%Path = &&&$Path&&&
    @#%instalador = &&&$instalador&&&
    @#%Parametro = &&&$Parametro&&&
    @#%SoftwarePath = Test-Path -Path &&&$SoftwarePath&&&
    # Faz a instalacao
    Instalar-Software @#%NomeSoftware @#%Path @#%instalador @#%Parametro @#%SoftwarePath"
        $parametros = $parametros -replace "@#%", '$' # Altera os valores para deixar o texto com as variaveis
        $parametros = $parametros -replace "&&&", '"' # Altera os valores para configurar as ""

        # Configura o nome
        $nomeScript = $NomeSoftware -replace " ", '-' # Remove os espacos
        $ScriptPath += "\$nomeScript.ps1"

        # Escreve o script
        try {
            Write-Host "Escrevendo o script Powershell.."
            Add-Content -Path "$ScriptPath" -Value "$padrao"
            Add-Content -Path "$ScriptPath" -Value "$configuracoesGerais"
            Add-Content -Path "$ScriptPath" -Value "$funcaoValidarPastas"
            Add-Content -Path "$ScriptPath" -Value "$validacaoCaminhos"
            Add-Content -Path "$ScriptPath" -Value "$funcaoInstalarPrograma"
            Add-Content -Path "$ScriptPath" -Value "$parametros"
            Write-Host "Script disponivel em: $ScriptPath"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Erro: $ErrorMessage"
        }
    }

    # Escreve a bat para inicializar
    function Escreva-Bat {
        param (
            [parameter(position=0, Mandatory=$True)]
            $NomeSoftware,
            [parameter(position=1, Mandatory=$True)]
            $CaminhoPS1,
            [parameter(position=2, Mandatory=$True)]
            $Versao,
            [parameter(position=3, Mandatory=$True)]
            $ScriptPath
        )

        # Cria o codigo da bat
        $codigoScript = "@echo off
    ================================================================================  
        :: NOME   : INFRA - $NomeSoftware
        :: AUTOR  : Ivo Dias  
        :: VERSAO : $versao 
    ================================================================================
    ::Titulo:
    title TI - $NomeSoftware
    :: Inicia o programa 
    PowerShell.exe -ExecutionPolicy Bypass -File $caminhoPS1"

        # Configura o nome
        $nomeScript = $NomeSoftware -replace " ", '-' # Remove os espacos
        $ScriptPath += "\$nomeScript.bat"

        # Escreve o script
        try {
            Write-Host "Escrevendo a Bat.."
            Add-Content -Path "$ScriptPath" -Value "$codigoScript"
            Write-Host "Script disponivel em: $ScriptPath"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Erro: $ErrorMessage"
        }
    }

    # Escreve o codigo em Go
    function Escreva-Go {
        param (
            [parameter(position=0, Mandatory=$True)]
            $NomeSoftware,
            [parameter(position=1, Mandatory=$True)]
            $CaminhoPS1,
            [parameter(position=2, Mandatory=$True)]
            $Versao,
            [parameter(position=3, Mandatory=$True)]
            $ScriptPath
        )

        # Configura o nome da bat
        $nomeScript = $NomeSoftware -replace " ", '-' # Remove os espacos
        # Duplica as barras para o Go
        $ScriptPathCorrigido = $ScriptPath  -replace "\", '\\'
        # Escreve o codigo em GO
        $codigoScript = "// $NomeSoftware
    // Ivo Dias
    // Pacote principal
    package main

    // Importa a biblioteca
    import (
        !@#bufio!@#
        !@#fmt!@#
        !@#os!@#
        !@#os/exec!@#
    )

    // Funcao principal
    func main() {
        // Nome do script de inicializacao
        scriptInicializacao := !@#$nomeScript!@# // Nome da bat que inicia o Powershell
        scriptInicializacao += !@#.bat!@#
        // Caminho do executavel
        caminhoScript := !@#$ScriptPathCorrigido!@# // Caminho para o repositorio de BATs
        caminhoScript += scriptInicializacao
        // Faz o procedimento
        fmt.Println(!@#Fazendo os procedimentos necessarios..!@#)                    // Escreve na tela
        fmt.Println(!@#Isso pode demorar alguns minutos, favor aguardar!@#) // Escreve na tela
        exec.Command(!@#cmd!@#, !@#/C!@#, caminhoScript).Run()
        // Encerra
        fmt.Println(!@#Procedimento concluido!@#)            // Escreve na tela
        fmt.Println(!@#Aperte alguma tecla para encerrar!@#) // Escreve na tela
        bufio.NewReader(os.Stdin).ReadBytes('\n')        // Aguarda uma entrada de dados para fechar a tela
    }"
        # Converte para voltar as ""
        $codigoScript = $codigoScript -replace "!@#", '"'

        # Configura o nome
        $ScriptPathGo = "$ScriptPath\$nomeScript.Go"

        # Escreve o script
        try {
            Write-Host "Escrevendo o script Go.."
            Add-Content -Path "$ScriptPath" -Value "$codigoScript"
            Write-Host "Script disponivel em: $ScriptPath"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Erro: $ErrorMessage"
        }

        # Compila o arquivo
        try {
            Write-Host "Compilando Go.."
            go build -o "$ScriptPath\$nomeScript.exe" "$ScriptPathGo"
            Write-Host "Script disponivel em: $ScriptPath"
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Erro: $ErrorMessage"
        }
    }
}