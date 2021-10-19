# Direciona o catch diretamente para uma pesquisa no StackOverflow
# Ivo Dias

# Funcao para fazer a pesquisa
function Get-StackOverflowAnswer {
    param (
        $mensagemErro
    )

    # Abre uma pesquisa com o termo que deu erro
    Start-Process "https://stackoverflow.com/search?q=$mensagemErro"
}

# Exemplo de uso
try {
    Set-ADUser -Identity "87ssdd877sd"
}
catch {
    $mensagemErro = $_.Exception.Message
    Get-StackOverflowAnswer $mensagemErro
}