Import-Module .\PSWriteHTML.Helper.psd1 -Force

Get-SimpleFontsList | Format-Table

Repair-FontsSimple -FontPath 'C:\Support\GitHub\PSWriteHTML\Resources\CSS\fontsSimpleIcons.min.css'