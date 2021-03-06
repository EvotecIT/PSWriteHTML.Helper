function Save-HTMLResource {
    [cmdletBinding()]
    param(
        [string[]] $Keys,
        [System.Collections.IDictionary] $Configuration,
        [string] $PathToSave
    )
    foreach ($SearchKey in $Keys) {
        $FoundKeys = $Configuration.Features.Keys | Where-Object { $_ -like $SearchKey }
        foreach ($Key in $FoundKeys) {
            if ($($Configuration).Features.$Key.Internal -eq $true) {
                # Do not update, as it's internal code
                continue
            }
            foreach ($Place in @('Header', 'Footer', 'Body')) {
                if ($($Configuration).Features.$Key.$Place.JsLink -and $($Configuration).Features.$Key.$Place.Js) {
                    if ($($Configuration).Features.$Key.$Place.JSLinkOriginal) {
                        $JSLink = $($Configuration).Features.$Key.$Place.JsLinkOriginal
                    } else {
                        $JSLink = $($Configuration).Features.$Key.$Place.JsLink
                    }
                    Save-Resource -PathToSave $PathToSave -ResourceLinks $JSLink -Type 'JS' -Target $($Configuration).Features.$Key.$Place.Js -Verbose

                }
                if ($($Configuration).Features.$Key.$Place.CssLink -and $($Configuration).Features.$Key.$Place.Css) {
                    if ($($Configuration).Features.$Key.$Place.CssLinkOriginal) {
                        $CSSLink = $($Configuration).Features.$Key.$Place.CssLinkOriginal
                    } else {
                        $CSSLink = $($Configuration).Features.$Key.$Place.CssLink
                    }
                    Save-Resource -PathToSave $PathToSave -ResourceLinks $CSSLink -Type 'CSS' -Target $($Configuration).Features.$Key.$Place.Css -Verbose
                }
            }
        }
    }
}

