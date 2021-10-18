# Gerar uma senha como arquivo Hash
# Ivo Dias

# Faz o procedimento
Clear-Host
Write-Host "Converter senha em arquivo seguro"
try {
    # Recebe as informacoes necessarias
    $caminhoArquivo = Read-Host "Informe o caminho do arquivo"
    $hash = Get-Date -Format SEC@ddMMyyyyssmm # Cria um identificador com base no dia e hora
    # Gera a chave
    $KeyFile = "$caminhoArquivo\$hash.key" # Define o caminho do arquivo
    $Key = New-Object Byte[] 32   # Voce pode usar 16 (128-bit), 24 (192-bit), ou 32 (256-bit) para AES
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key) # Cria a chave de criptografia
    $Key | Out-File $KeyFile # Salva em um arquivo
    # Gera a senha
    Read-Host "Informe sua senha" -AsSecureString | ConvertFrom-SecureString -key $Key | Out-File "$caminhoArquivo\$hash.pass" # Gera a senha
    Write-Host "Arquivos gerados em: $caminhoArquivo"
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
    Write-Host "Erro: $ErrorMessage"
}
Pause