# Cria a funcao para retornos acessiveis
function Mensagem-Acessivel {
    param (
        $texto
    )
    # Configurando o Narrador 
    Add-Type -AssemblyName System.speech # Adiciona biblioteca
    $narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer # Cria narrador
    # Retorna as mensagens
    Write-Host "$texto"
    $narrador.Speak("$texto")
}