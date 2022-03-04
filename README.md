# SccmAM
PowerShell cmdlets creating Sccm Applications from custom PackageDefinition.sms and DetectionMethod.ps1

## Import module for development and testing
```powershell
Import-Module -Path ".\modules\SccmAM"
```

## Example creating Sccm Applications:
```
Write-Host "Create applications"
$applicationsPath = "Z:\Applications"
$allPackageDefinitionSmsFiles = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
$allPackageDefinitionSmsFIles | New-SAMCmApplicationFromPackageDefinitionSms
```

## Example creating Sccm Packages:
```
Write-Host "Create applications"
$applicationsPath = "Z:\Applications"
$allPackageDefinitionSmsFiles = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
$allPackageDefinitionSmsFIles | New-SAMCmPackageFromPackageDefinitionSms
```

## Setup local repository
```powershell
$RepositoryName = "LocalPSModuleRepository"
$RepositorySourceLocation = "C:\$RepositoryName"
New-Item -Path C:\ -Name $RepositoryName -ItemType Directory -Force -ErrorAction SilentlyContinue
Register-PSRepository -Name $RepositoryName -SourceLocation $RepositorySourceLocation -PublishLocation $RepositorySourceLocation -InstallationPolicy Trusted
```

## Publish Module to local repository
```powershell
Publish-Module -Path ".\modules\SccmAM" -Repository LocalPSModuleRepository
```

## Install Module from local repository
```powershell
Install-Module -Name SccmAM -Repository LocalPSModuleRepository
Import-Module v
```

## Publish Module to PowerShell Gallery
```powershell
$ApiKey="...api...key...here..."
Publish-Module -Path ".\modules\SccmAM" -Repository PSGallery -NuGetApiKey $ApiKey
