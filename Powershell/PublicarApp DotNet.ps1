# Script para publicacao
# Ivo Dias
# Referencia: https://medium.com/@renato.groffe/asp-net-core-powershell-publicando-via-linha-de-comando-e-em-segundos-uma-web-app-no-azure-2e4fee2ea5ba

[CmdletBinding()]
param (
    [Parameter()]
    [string] $pastaPublicacao,
    [string] $recurso,
    [string] $grupo
)

$dataHora = Get-Date
Write-Host "Horario Inicial: $dataHora"

# Força a exclusão de uma pasta para publicação criada anteriormente
if (Test-Path $pastaPublicacao) {
    Remove-Item -Recurse -Force $pastaPublicacao
}

# Realiza a publicação
dotnet publish -c release -o $pastaPublicacao

# Remove um arquivo compactado com a publicação (caso o mesmo tenha sido
# criado anteriormente)
$arqPublicacao = "publicacao.zip"
if (Test-Path $arqPublicacao) {
    Remove-Item -Force $arqPublicacao
}

# Efetua a compressão da pasta com a publicação
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($pastaPublicacao, $arqPublicacao)

# Efetua o deployment utilizando o arquivo compactado (.zip)
az webapp deployment source config-zip -n $recurso -g $grupo --src $arqPublicacao

$dataHora = Get-Date
Write-Host "Horario Final: $dataHora"