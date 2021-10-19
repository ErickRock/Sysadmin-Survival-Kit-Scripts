function Get-VeracodeModulesSum {
    param (
        $tamanhos
    )

    # Inicializa as variaveis numericas
    [int]$somaMB = 0
    [int]$somaKB = 0
    # Divide a informacao dos modulos em linhas
    $tamanhoModulos = $tamanhos.split(" ")
    # Para cada linha, separa os MBs dos KBs
    foreach ($tamanhoModulo in $tamanhoModulos) {
        if ($tamanhoModulo -Match "MB") {
            $tamanhoModulo = $tamanhoModulo.replace("MB","")
            [int]$somaMB += $tamanhoModulo
        } if ($tamanhoModulo -Match "KB") {
            $tamanhoModulo = $tamanhoModulo.replace("KB","")
            [int]$somaKB += $tamanhoModulo
        }
    }
    # Converte KBs em MBs e soma os totais, retornando o resultado
    $total = $somaMB + ($somaKB/1024)
    $total = [math]::Round($total,2)
    return $total
}