# Configuracao
$pastaferramenta  = "$Env:Programfiles/Veracode/" # Define uma pasta onde vamos colocar a ferramenta
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaferramenta") # Adiciona o caminho no Path do sistema

# Download e configuração: Pipeline Scan
$urlDownload = "https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip" # Define a url de download
$caminhoDownload = "$env:LOCALAPPDATA/VeracodePipeline.zip" # Define um caminho para o arquivo de download
Invoke-WebRequest -Uri "$urlDownload" -OutFile "$caminhoDownload" # Faz o download
Expand-Archive -Path "$caminhoDownload" -DestinationPath "$pastaferramenta" # Descompacta o ZIP para uma pasta
Remove-Item "$caminhoDownload" # Remove o arquivo de download

# Download e configuração: API Wrapper
$urlDownload = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip" # Define a url de download
$caminhoDownload = "$env:LOCALAPPDATA/VeracodeAPI.zip" # Define um caminho para o arquivo de download
Invoke-WebRequest -Uri "$urlDownload" -OutFile "$caminhoDownload" # Faz o download
Expand-Archive -Path "$caminhoDownload" -DestinationPath "$pastaferramenta" # Descompacta o ZIP para uma pasta
Rename-Item -Path "$pastaferramenta/VeracodeC#API.exe" -NewName "$pastaferramenta/VeracodeAPI.exe" # Renomei para remover o # do nome
Remove-Item "$caminhoDownload" # Remove o arquivo de download

# Utilizacao das ferrementas:
VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScan -appname "$NomeApp" -filepath "$caminhoArquivo" -version $numeroVersao # API Wrapper
java -jar "pipeline-scan.jar" -vid $veracodeID -vkey $veracodeAPIkey -f $caminhoarquivo # Pipeline Scan


$Env:SRCCLR_API_TOKEN = "Disponivel no portal da Veracode"