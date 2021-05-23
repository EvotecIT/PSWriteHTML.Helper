function Get-SimpleFontsList {
    [cmdletBinding()]
    param(
        [switch] $NamesOnly,
        [switch] $ToClipboard
    )
    $Content = Get-GitHubContent -Uri 'https://api.github.com/repos/simple-icons/simple-icons/' -Path /icons
    $All = @(
        if (-not $NamesOnly) { "FontsSimple = @(" }
        foreach ($T in $Content.entries.name) {
            "'$($T.Replace('.svg', ''))'"
        }
        if (-not $NamesOnly) { ")" }
    )
    if ($ToClipboard) {
        $All | Set-Clipboard
    } else {
        $All
    }
}