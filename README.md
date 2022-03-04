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
$allPackageDefinitionSmsFiles | New-SAMCmApplicationFromPackageDefinitionSms
```

## Example creating Sccm Packages:
```
Write-Host "Create applications"
$applicationsPath = "Z:\Applications"
$allPackageDefinitionSmsFiles = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
$allPackageDefinitionSmsFiles | New-SAMCmPackageFromPackageDefinitionSms
```

## Example PackageDefintion.sms
The package definition must both contain an INSTALL and UNINSTALL program when used to create a Sccm Application. The package defintion can optionally contain a REPAIR program.
Only Name and CommandLine is currently processed from the program definition. The other program properties are hard coded to run in system context, minimized and with no user interaction. This may change in future versions of the CmdLets.
```
[PDF]
Version = 2.0

[Package Definition]
Name = Test Application
Version = 1.0.16239.2
Publisher = MyCompany
Language = EN
Comment = Test Comment
Programs = INSTALL,REPAIR,UNINSTALL

[INSTALL]
Name = INSTALL
CommandLine = Install.cmd > "%Public%\Logs\Test_Application_1_0_16239_2_Install.cmd.log"
CanRunWhen = AnyUserStatus
UserInputRequired = False
AdminRightsRequired = True
UseInstallAccount = True
Run = Minimized
Icon = App.ico
Comment = Install comment

[REPAIR]
Name = REPAIR
CommandLine = Repair.cmd > "%Public%\Logs\Test_Application_1_0_16239_2_Repair.cmd.log"
CanRunWhen = AnyUserStatus
UserInputRequired = False
AdminRightsRequired = True
UseInstallAccount = True
Run = Minimized
Icon = App.ico
Comment = Repair comment

[UNINSTALL]
Name = UNINSTALL
CommandLine = UnInstall.cmd > "%Public%\Logs\Test_Application_1_0_16239_2_UnInstall.cmd.log"
CanRunWhen = AnyUserStatus
UserInputRequired = False
AdminRightsRequired = True
UseInstallAccount = True
Run = Minimized
Comment = Uninstall comment
```
## Example DetectionMethod.ps1
The detection script is expected to be located in the same folder as PackageDefinition.sms. The detection script is added as detection method when a Sccm application is created.
```
# https://docs.microsoft.com/en-us/previous-versions/system-center/system-center-2012-R2/gg682159(v=technet.10)#to-use-a-custom-script-to-determine-the-presence-of-a-deployment-type

try {
    throw "Not implemented"
    $IsInstalled = $false #Check install condition here, Do not write to STDOUT or STDERR when doing the check.
    if($IsInstalled)
    {
        Write-Host "Installed"
    }
    else {
        #Not installed, keep silent do not write to STDOUT or STDERR
    }    
    EXIT 0
}
catch {
    #Failed, write to STDERR and return non-zero exit code.
    Write-Error "$($_.Exception.Message)(Line: $($_.InvocationInfo.ScriptLineNumber))(ScriptName: $($_.InvocationInfo.ScriptName))" -ErrorAction Continue
    EXIT 1
}
```

## Setup local repository
```powershell
$RepositoryName = "LocalPSModuleRepository"
$RepositorySourceLocation = "C:\$RepositoryName"
New-Item -Path C:\ -Name $RepositoryName -ItemType Directory -Force -ErrorAction SilentlyContinue
Register-PSRepository -Name $RepositoryName -SourceLocation $RepositorySourceLocation -PublishLocation $RepositorySourceLocation -InstallationPolicy Trusted -ErrorAction SilentlyContinue
```
## Update Nuget.exe
```
Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
```

## Publish Module to local repository
```powershell
Publish-Module -Path ".\modules\SccmAM" -Repository LocalPSModuleRepository
```

## Install Module from local repository
```powershell
Install-Module -Name SccmAM -Repository LocalPSModuleRepository
Import-Module SccmAM
```

## Publish Module to PowerShell Gallery
```powershell
$ApiKey="...api...key...here..."
Publish-Module -Path ".\modules\SccmAM" -Repository PSGallery -NuGetApiKey $ApiKey
