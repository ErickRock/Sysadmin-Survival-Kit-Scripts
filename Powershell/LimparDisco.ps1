# Limpar disco
# Ivo Dias

# Funcao para deletar os arquivos em uma pasta
function Limpar-Pasta {
    param (
        [parameter(position=0,Mandatory=$True)]
        $pasta
    )
    try {
        if (Test-Path -Path "$pasta") {
            #$noLOG = Remove-Item -Path $pasta -Recurse -Force
            Get-ChildItem "$pasta" -Recurse -Force `
            | Sort-Object -Property FullName -Descending `
            | ForEach-Object {
                try {
                    Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction Stop;
                }
                catch { }
            }
            $mensagem = "Concluida a limpeza"
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        $mensagem = "Erro ao fazer o procedimento: $ErrorMessage"
    }
    return $mensagem
}

function Limpeza {
    param (
        [parameter(position=0,Mandatory=$True)]
        $nomePasta,
        [parameter(position=1,Mandatory=$True)]
        $caminhoPasta
    )

    Write-Host "Limpando: $nomePasta"
    $procedimento = Limpar-Pasta $caminhoPasta
    Write-Host $procedimento
}

# Limpa as pastas: 
# Temporarios do Windows
Limpeza "Temporarios do Windows" "C:\Windows\Temp"

# Pasta da Infra
Limpeza "Instaladores da Infra" "C:\INFRA"

# Windows Update
Limpeza "Windows Update" "C:\Windows\SoftwareDistribution\Download"