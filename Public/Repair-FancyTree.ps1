function Repair-FancyTree {
    [cmdletBinding()]
    param(
        [string]$CSSPath,
        [string]$ImageBaseURL = 'https://cdn.jsdelivr.net/npm/jquery.fancytree@2.38.5/dist/'
    )
    $TempProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    if (-not (Test-Path -Path $CSSPath)) {
        Write-Error "CSS file not found at: $CSSPath"
        return
    }

    $Content = Get-Content -Raw -Path $CSSPath

    # Regex to find url("...") patterns, excluding data URIs
    $regex = [regex] 'url\("(?!data:)(?<url>.*?)"\)'
    $matches = $regex.Matches($Content)

    $uniqueRelativeUrls = $matches.ForEach({$_.Groups['url'].Value}) | Select-Object -Unique

    if ($null -eq $uniqueRelativeUrls -or $uniqueRelativeUrls.Count -eq 0) {
        Write-Warning "No relative image URLs found to replace in $CSSPath."
        $ProgressPreference = $TempProgressPreference
        return
    }

    Write-Verbose "Found $($uniqueRelativeUrls.Count) unique relative URLs to process."

    $urlToDataUriMap = @{}

    foreach ($relativeUrl in $uniqueRelativeUrls) {
        # The relative URLs are like ../skin-win8/icons.gif. We need to construct the full URL.
        # The base URL is for the 'dist' folder, and the CSS is in 'dist/skin-win8'.
        # So, ../skin-win8/ becomes skin-win8/
        $correctedRelativePath = $relativeUrl.Replace('../', '')
        $downloadUrl = $ImageBaseURL + $correctedRelativePath

        $fileName = [System.IO.Path]::GetFileName($downloadUrl)
        $tempImagePath = [System.IO.Path]::Combine($Env:TEMP, $fileName)

        try {
            Write-Verbose "Downloading $downloadUrl"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $tempImagePath -UseBasicParsing -ErrorAction Stop
        }
        catch {
            Write-Warning "Failed to download '$fileName' from '$downloadUrl'. Error: $_. Skipping."
            continue
        }

        $imageBytes = [System.IO.File]::ReadAllBytes($tempImagePath)
        $imageBase64 = [System.Convert]::ToBase64String($imageBytes)

        $mimeType = ''
        $extension = [System.IO.Path]::GetExtension($fileName).ToLower()
        switch ($extension) {
            '.gif'   { $mimeType = 'image/gif' }
            '.png'   { $mimeType = 'image/png' }
            '.jpg'   { $mimeType = 'image/jpeg' }
            '.jpeg'  { $mimeType = 'image/jpeg' }
            '.svg'   { $mimeType = 'image/svg+xml' }
            default {
                Write-Warning "Unknown image extension '$extension' for file '$fileName'. Cannot determine MIME type. Skipping."
                Remove-Item -Path $tempImagePath -ErrorAction SilentlyContinue
                continue
            }
        }

        $dataUri = "data:$mimeType;base64,$imageBase64"
        $urlToDataUriMap[$relativeUrl] = $dataUri
        Remove-Item -Path $tempImagePath -ErrorAction SilentlyContinue
    }

    foreach ($relativeUrl in $urlToDataUriMap.Keys) {
        $dataUri = $urlToDataUriMap[$relativeUrl]
        # Ensure we replace the original quoted URL
        $Content = $Content.Replace('url("' + $relativeUrl + '")', "url('$dataUri')")
    }

    Out-File -Encoding utf8 -FilePath $CSSPath -InputObject $Content -NoNewline
    $ProgressPreference = $TempProgressPreference
    Write-Verbose "Processed $CSSPath and embedded $($urlToDataUriMap.Count) unique images."
}
