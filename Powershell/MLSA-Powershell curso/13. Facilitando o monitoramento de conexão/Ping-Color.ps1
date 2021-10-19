function Ping-Color {
    param (
        [parameter(position=0, Mandatory=$True)]
        $nomeComputador
    )

    # Configura o tamanho da barra
    $barraColorida = "                                               "
    # Limpamos a tela
    Clear-Host
    # Alteramos o titulo do terminal
    $host.UI.RawUI.WindowTitle = "Analisando $nomeComputador - CTRL + C para cancelar"
    Write-Host "A analise demora alguns segundos"
    Write-Host "O comando para cancelar precisa ser apertado algumas vezes"
    # Cria um loop para validacao
    do {
        if(Test-Connection -ComputerName $nomeComputador -Quiet) {
            Write-Host "$barraColorida" -BackgroundColor Green
            Write-Host "O equipamento $nomeComputador esta online"
            break
        } else {
            Write-Host "$barraColorida" -BackgroundColor Red
        }
    } while ($true)
}