# Configuracoes
$vid = ""
$vkey = ""

# Recebe os APP ids e nomes
[xml]$INFO = $(VeracodeAPI.exe -vid "$vid" -vkey "$vkey" -action GetAppList)
$listaApps = $INFO.applist.app
$indice = 0

# Faz um loop para pegar as informacoes
foreach ($App in $listaApps) {
    # Recebe os valores
    $appNome = $INFO.applist.app.app_name[$indice]
    $appID = $INFO.applist.app.app_id[$indice]
    [xml]$preScanInfo = $(VeracodeAPI.exe -vid $vid -vkey $vkey -action getprescanresults -appid $appID)
    $tamanhos = $preScanInfo.prescanresults.module.size

    # Mostra os valores
    Write-Host "Nome: $appNome" 
    Write-Host "ID: $appID" 
    Write-Host "Tamanhos dos modulos:"
    Write-Host $tamanhos
    Write-Host "   "
    ## Incrementa o indice
    $indice++
}