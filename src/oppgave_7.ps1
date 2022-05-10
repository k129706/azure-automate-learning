[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]$UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop'
#$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

$webRequest = Invoke-WebRequest http://nav-deckofcards.herokuapp.com/shuffle
$kortstokkJson = $webRequest.Content
$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])$($kort.value)"+","
    }
    return $streng.Substring(0,$streng.Length-1)
}

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk$kortStokkMagnus) | $(kortStokkTilStreng -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortStokkTilStreng -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21



<# $meg = $kortstokk[0..1]
Write-Output $(kortstokk[0..1])
$kortstokk = $kortstokk[2..($kortstokk.Count - 1)]
Write-Output "meg: $(kortStokkTilStreng -kortstokk $meg)"

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..($kortstokk.Count - 1)]
Write-Output "magnus: $(kortStokkTilStreng -kortstokk $magnus)"
Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"
 #>

if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner $meg -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magunx) -eq $blackjack) {
    skrivUtResultat -vinner $magnus -kortStokkMagnus $magnux -kortStokkMeg $meg
    exit
}







