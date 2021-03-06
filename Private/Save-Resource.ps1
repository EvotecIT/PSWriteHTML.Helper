function Save-Resource {
    [cmdletBinding()]
    param(
        [uri[]] $ResourceLinks,
        [string[]] $Target,
        [ValidateSet('CSS', 'JS')][string] $Type,
        [string] $PathToSave
    )
    $TempProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $Output = for ($i = 0; $i -lt $ResourceLinks.Count; $i++) {
        if ($Target) {
            # If target given means we replace something
            Write-Verbose "Downloading $($ResourceLinks[$i].OriginalString) to $($Target[$i])"
            Invoke-WebRequest -Uri $ResourceLinks[$i] -OutFile $Target[$i] -Verbose:$false
            #$Target[$i]
        } else {
            $Splitted = $ResourceLinks[$i].OriginalString -split '/'
            $FileName = $Splitted[ - 1]
            $FilePath = [IO.Path]::Combine($PathToSave, $Type, $FileName)
            $FilePathScriptRoot = -Join ('"', '$PSScriptRoot\..\Resources\', "$Type", '\', $FileName, '"')
            $FilePathScriptRoot

            Invoke-WebRequest -Uri $ResourceLinks[$i] -OutFile $FilePath -Verbose:$false
        }
    }
    $ProgressPreference = $TempProgressPreference
    $Output
}