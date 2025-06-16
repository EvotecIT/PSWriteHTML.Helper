@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2022 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Module that helps preparing release of PSWriteHTML'
    FunctionsToExport    = @('Get-SimpleFontsList', 'Repair-FontsAwesome', 'Repair-FontsSimple', 'Save-HTMLResource')
    GUID                 = '7b997df6-793a-4168-92a1-ccdfc3941c5d'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('HTML', 'WWW', 'JavaScript', 'CSS', 'Reports', 'Reporting', 'Windows', 'MacOS', 'Linux')
            ProjectUri                 = 'https://github.com/EvotecIT/PSWriteHTML'
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2018/12/PSWriteHTML.png'
            ExternalModuleDependencies = @('Microsoft.PowerShell.Utility')
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.248'
            ModuleName    = 'PSSharedGoods'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        }, @{
            ModuleVersion = '0.16.1'
            ModuleName    = 'PowerShellForGitHub'
            Guid          = '9e8dfd44-f782-445a-883c-70614f71519c'
        }, 'Microsoft.PowerShell.Utility')
    RootModule           = 'PSWriteHTML.Helper.psm1'
}