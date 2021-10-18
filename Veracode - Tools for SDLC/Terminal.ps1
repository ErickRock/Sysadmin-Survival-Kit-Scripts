# SCA
iex ((New-Object System.Net.WebClient).DownloadString('https://download.srcclr.com/ci.ps1')) # Faz o download do script
srcclr scan # Executa o scan


# Pipeline Scan
java -jar "pipeline-scan.jar" -vid $veracodeID -vkey $veracodeAPIkey -f $caminhoarquivo 


# API Wrapper
$numeroVersao = Get-Date -Format hhmmssddMMyy # Cria um hash com base no dia e hora para numero de versão
VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScan -appname "$NomeApp" -filepath "$caminhoArquivo" -version $numeroVersao