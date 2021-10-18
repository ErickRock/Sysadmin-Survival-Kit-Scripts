# Localizar termos dentro de arquivos
# Ivo Dias

function Pesquisar-Termo {
    param (
        [Parameter(Mandatory=$true, HelpMessage="Informe um termo para ser pesquisado")]
        [string] $termo,
        $pasta = (Get-Location).Path
    )

    # Configuracoes
    Clear-Host
    Write-Host "Pesquisando $termo"
    $hash = Get-Date -Format ddMMyy-mmhh

    # Pega todos os arquivos de uma pasta
    $arquivos = (Get-ChildItem -Path "$pasta" -File).Name
    
    # Verifica o conteudo de cada arquivo
    foreach ($arquivo in $arquivos) {
        Write-Host "Verificando arquivo: $arquivo"
        $encontrei = Select-String -Path "$pasta\$arquivo" -Pattern "$termo"
        Add-Content -Path "$pasta\Encontrar_$termo-$hash.txt" -Value $encontrei
    }
}