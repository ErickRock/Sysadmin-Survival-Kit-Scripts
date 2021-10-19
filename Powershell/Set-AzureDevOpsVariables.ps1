# Faz a conversao dos valores presentes no variable.auto.tfvars
# Ivo Dias

$nomeApp = "##app_name##"
Write-Host "Configurando variavel: nomeApp"
Write-Host "##vso[task.setvariable variable=nomeApp;]$nomeApp"

$nomeResourceGroup = "##resource_group##"
Write-Host "Configurando variavel: nomeResourceGroup"
Write-Host "##vso[task.setvariable variable=nomeResourceGroup;]$nomeResourceGroup"

$localizacaoResourceGroup = "##resource_group_location##"
Write-Host "Configurando variavel: localizacaoResourceGroup"
Write-Host "##vso[task.setvariable variable=localizacaoResourceGroup;]$localizacaoResourceGroup"