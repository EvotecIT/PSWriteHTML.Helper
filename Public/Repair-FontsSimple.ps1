function Repair-FontsSimple {
    [cmdletBinding()]
    param(
        [string] $FontURL = 'https://cdn.jsdelivr.net/npm/simple-icons-font@4.24.0/font',
        [string] $FontPath
    )
    $TempProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $Content = Get-Content -Raw -Path $FontPath

    $FontReplacePath = $Env:TEMP
    $FontsToReplace = @(
        #[ordered] @{ FileType = 'font-eot'  ; Search = 'SimpleIcons.eot' ; FontFileName = "SimpleIcons.eot" }
        [ordered] @{ FileType = 'font-woff2' ; Search = 'SimpleIcons.woff2'; FontFileName = "SimpleIcons.woff2" }
        [ordered] @{ FileType = 'font-woff'  ; Search = 'SimpleIcons.woff' ; FontFileName = "SimpleIcons.woff" }
        #[ordered] @{ FileType = 'font-ttf'  ; Search = 'SimpleIcons.ttf' ; FontFileName = "SimpleIcons.ttf" }
        #[ordered] @{ FileType = 'font-svg'  ; Search = 'SimpleIcons.svg' ; FontFileName = "SimpleIcons.svg" }
    )
    foreach ($Font in $FontsToReplace) {
        $OutFont = [io.path]::Combine($FontReplacePath, $($Font.FontFileName))
        Invoke-WebRequest -Uri "$FontURL/$($Font.FontFileName)" -OutFile $OutFont

        $Content = Convert-FontToBinary -Content $Content -FileType $Font.FileType -Search $Font.Search -ReplacePath $FontReplacePath\$($Font.FontFileName)
    }
    Out-File -Encoding utf8 -FilePath $FontPath -InputObject $Content
    $ProgressPreference = $TempProgressPreference
}