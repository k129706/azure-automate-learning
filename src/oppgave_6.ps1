[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]$UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop'
$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

#$webRequest = Invoke-WebRequest http://nav-deckofcards.herokuapp.com/shuffle
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
Clear-Host
Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"
Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"


$meg = $kortstokk[0..1]
#Write-Output $(kortstokk[0..1])
$kortstokk = $kortstokk[2..($kortstokk.Count - 1)]
Write-Output "meg: $(kortStokkTilStreng -kortstokk $meg)"

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..($kortstokk.Count - 1)]
Write-Output "magnus: $(kortStokkTilStreng -kortstokk $magnus)"
Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"