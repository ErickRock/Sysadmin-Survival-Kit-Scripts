# Criar multiplos Storages
# Ivo Dias

# Instala modulo
Install-Module Az.Storage -Confirm:$false -Force -AllowClobber
Import-Module Az.Storage -Force

# Configuracao
$grupoRecursosBase = ""
$localizacao = ""
$sku = ""
$nomeContaBase = ""
$caminhoArquivo = ""

# Recebe os dados
$nomes = Get-Content -Path $caminhoArquivo

# Faz o procedimento para o ambiente HMG
$ambiente = "HMG"
$grupoRecursos = $grupoRecursosBase + $ambiente
$ambiente = $ambiente.ToLower()
foreach ($nome in $nomes) {
    try {
            # Configura o nome
            $nome = $nome.ToLower()
            $nomeConta = $nomeContaBase + $nome + $ambiente
            # Cria o Storage
            Write-Host "Criando Storage: $nomeConta"
            New-AzStorageAccount -ResourceGroupName $grupoRecursos -AccountName $nomeConta -Location $localizacao -SkuName $sku -AccessTier Cool
            # Pega a chave de acesso
            $chaveAcesso = Get-AzStorageAccountKey -ResourceGroupName "$grupoRecursos" -AccountName "$nomeConta"
            $chaveAcesso = $chaveAcesso.Value[0]
            # Acessa
            $contexto = New-AzStorageContext -StorageAccountName "$nomeConta" -StorageAccountKey "$chaveAcesso"
            # Cria o container
            Write-Host "Criando Container: $nomeConta"
            New-AzStorageContainer -Name "$nomeConta" -Permission Blob -Context $contexto
    }
    catch {
        # Mostra mensagem de erro
        Write-Host "Erro ao fazer o procedimento"
        Write-Host "Erro: $_.Exception.Message"
    }
}