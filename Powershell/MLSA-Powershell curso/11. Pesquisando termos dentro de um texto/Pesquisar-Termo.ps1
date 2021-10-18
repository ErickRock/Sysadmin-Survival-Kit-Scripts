function Pesquisar-Termo {
    param (
        [Parameter(Mandatory=$true, HelpMessage="Informe um termo para ser pesquisado")] # Colocamos uma mensagem caso o usuario inicie a funcao sem os parametros
        [string] $termo,
        $pasta = (Get-Location).Path # Definimos um valor padrao caso nenhum seja passado, nesse caso, a pasta onde o script foi executado
    )

    # Configuracoes
    Clear-Host
    Write-Host "Pesquisando $termo"
    $hash = Get-Date -Format ddMMyy-mmhh

    # Pega todos os arquivos de uma pasta
    $arquivos = (Get-ChildItem -Path "$pasta" -File).Name
    
    # Verifica o conteudo de cada arquivo
    foreach ($arquivo in $arquivos) {
        try {
            Write-Host "Verificando arquivo: $arquivo"
            $encontrei = Select-String -Path "$pasta\$arquivo" -Pattern "$termo"
            Add-Content -Path "$pasta\Encontrar_$termo-$hash.txt" -Value $encontrei
        }
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            Write-Host "Erro: $ErrorMessage"
        }
    }
    # Exibimos o retorno ao finalizar
    Write-Host "Analise concluida"
    Write-Host "Disponivel em: $pasta\Encontrar_$termo-$hash.txt"
}