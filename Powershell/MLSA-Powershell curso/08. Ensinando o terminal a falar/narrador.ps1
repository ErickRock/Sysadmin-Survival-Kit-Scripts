# Adiciona biblioteca 
Add-Type -AssemblyName System.speech 
# Cria narrador 
$narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer 
# Recebe o texto  
$texto = Read-Host "Informe o que deseja ouvir" 
# Lê o texto 
$narrador.Speak("$texto")