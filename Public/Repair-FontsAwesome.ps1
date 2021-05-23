function Repair-FontsAwesome {
    [cmdletBinding()]
    param(
        [string] $FontURL = 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.3/webfonts',
        [string] $FontPath
    )
    $TempProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $Content = Get-Content -Raw -Path $FontPath

    $FontReplacePath = $Env:TEMP
    $FontsToReplace = @(
        #[ordered] @{ FileType = 'font-eot'  ; Search = '../webfonts/fa-solid-900.eot' ; FontFileName = "fa-solid-900.eot" }
        [ordered] @{ FileType = 'font-woff2' ; Search = '../webfonts/fa-solid-900.woff2'; FontFileName = "fa-solid-900.woff2" }
        [ordered] @{ FileType = 'font-woff'  ; Search = '../webfonts/fa-solid-900.woff' ; FontFileName = "fa-solid-900.woff" }
        #[ordered] @{ FileType = 'font-ttf'  ; Search = '../webfonts/fa-solid-900.ttf' ; FontFileName = "fa-solid-900.ttf" }
        #[ordered] @{ FileType = 'font-svg'  ; Search = '../webfonts/fa-solid-900.svg' ; FontFileName = "fa-solid-900.svg" }
        #[ordered] @{ FileType = 'font-eot'  ; Search = '../webfonts/fa-brands-400.eot' ; FontFileName = "fa-brands-400.eot" }
        [ordered] @{ FileType = 'font-woff2' ; Search = '../webfonts/fa-brands-400.woff2' ; FontFileName = "fa-brands-400.woff2" }
        [ordered] @{ FileType = 'font-woff'  ; Search = '../webfonts/fa-brands-400.woff' ; FontFileName = "fa-brands-400.woff" }
        #[ordered] @{ FileType = 'font-ttf'  ; Search = '../webfonts/fa-brands-400.ttf' ; FontFileName = "fa-brands-400.ttf" }
        #[ordered] @{ FileType = 'font-svg'  ; Search = '../webfonts/fa-brands-400.svg' ; FontFileName = "fa-brands-400.svg" }
        #[ordered] @{ FileType = 'font-eot'  ; Search = '../webfonts/fa-regular-400.eot' ; FontFileName = "fa-regular-400.eot" }
        [ordered] @{ FileType = 'font-woff2' ; Search = '../webfonts/fa-regular-400.woff2' ; FontFileName = "fa-regular-400.woff2" }
        [ordered] @{ FileType = 'font-woff'  ; Search = '../webfonts/fa-regular-400.woff' ; FontFileName = "fa-regular-400.woff" }
        #[ordered] @{ FileType = 'font-ttf'  ; Search = '../webfonts/fa-regular-400.ttf' ; FontFileName = "fa-regular-400.ttf" }
        #[ordered] @{ FileType = 'font-svg'  ; Search = '../webfonts/fa-regular-400.svg' ; FontFileName = "fa-regular-400.svg" }
    )
    foreach ($Font in $FontsToReplace) {
        $OutFont = [io.path]::Combine($FontReplacePath, $($Font.FontFileName))
        Invoke-WebRequest -Uri "$FontURL/$($Font.FontFileName)" -OutFile $OutFont

        $Content = Convert-FontToBinary -Content $Content -FileType $Font.FileType -Search $Font.Search -ReplacePath $FontReplacePath\$($Font.FontFileName)
    }
    Out-File -Encoding utf8 -FilePath $FontPath -InputObject $Content
    $ProgressPreference = $TempProgressPreference
}

<# read https://css-tricks.com/understanding-web-fonts-getting/ to undderstand

# Builds Fonts Awasome for Offline Use
# remeber to remove types from original file
# ttf / svg / eot / eot


$FontReplacePath = 'C:\Support\GitHub\PSWriteHTML\Ignore\fontawesome-free-5.15.1-web\webfonts'
$FontPath = 'C:\Support\GitHub\PSWriteHTML\Ignore\fontawesome-free-5.15.1-web\css\all-modified.min.css'
#$FontPath = 'C:\Support\GitHub\PSWriteHTML\Ignore\fontawesome-free-5.15.1-web\css\all-modified.css'
$TargetPath = "$PSScriptRoot\..\Resources\CSS\fontsAwesome.css"

Optimize-CSS -File 'C:\Support\GitHub\PSWriteHTML\Ignore\fontawesome-free-5.15.1-web\css\all-modified.css' -OutputFile 'C:\Support\GitHub\PSWriteHTML\Ignore\fontawesome-free-5.15.1-web\css\all-modified.min.css'
Copy-Item -Path $FontPath -Destination $TargetPath

$Content = Get-Content -Raw -Path $PSScriptRoot\..\Resources\CSS\fontsAwesome.css
#$Content = Convert-FontToBinary -FileType 'font-eot' -Search '../webfonts/fa-solid-900.eot' -ReplacePath "$FontReplacePath\fa-solid-900.eot" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff2' -Search '../webfonts/fa-solid-900.woff2' -ReplacePath "$FontReplacePath\fa-solid-900.woff2" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff' -Search '../webfonts/fa-solid-900.woff' -ReplacePath "$FontReplacePath\fa-solid-900.woff" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-ttf' -Search '../webfonts/fa-solid-900.ttf' -ReplacePath "$FontReplacePath\fa-solid-900.ttf" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-svg' -Search '../webfonts/fa-solid-900.svg' -ReplacePath "$FontReplacePath\fa-solid-900.svg" -Content $Content
#
#$Content = Convert-FontToBinary -FileType 'font-eot' -Search '../webfonts/fa-brands-400.eot' -ReplacePath "$FontReplacePath\fa-brands-400.eot" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff2' -Search '../webfonts/fa-brands-400.woff2' -ReplacePath "$FontReplacePath\fa-brands-400.woff2" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff' -Search '../webfonts/fa-brands-400.woff' -ReplacePath "$FontReplacePath\fa-brands-400.woff" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-ttf' -Search '../webfonts/fa-brands-400.ttf' -ReplacePath "$FontReplacePath\fa-brands-400.ttf" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-svg' -Search '../webfonts/fa-brands-400.svg' -ReplacePath "$FontReplacePath\fa-brands-400.svg" -Content $Content
#
#$Content = Convert-FontToBinary -FileType 'font-eot' -Search '../webfonts/fa-regular-400.eot' -ReplacePath "$FontReplacePath\fa-regular-400.eot" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff2' -Search '../webfonts/fa-regular-400.woff2' -ReplacePath "$FontReplacePath\fa-regular-400.woff2" -Content $Content
$Content = Convert-FontToBinary -FileType 'font-woff' -Search '../webfonts/fa-regular-400.woff' -ReplacePath "$FontReplacePath\fa-regular-400.woff" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-ttf' -Search '../webfonts/fa-regular-400.ttf' -ReplacePath "$FontReplacePath\fa-regular-400.ttf" -Content $Content
#$Content = Convert-FontToBinary -FileType 'font-svg' -Search '../webfonts/fa-regular-400.svg' -ReplacePath "$FontReplacePath\fa-regular-400.svg" -Content $Content
Out-File -Encoding utf8 -FilePath $PSScriptRoot\..\Resources\CSS\fontsAwesome.css -InputObject $Content
#>