function New-SAMCmApplicationFromPackageDefinitionSms
{
	<#
		.SYNOPSIS
		Create new Sccm Application from PackageDefinition.sms and DetectionMethod.ps1
		
		.DESCRIPTION
		Create new Sccm Application from PackageDefinition.sms and DetectionMethod.ps1

		PackageDefinition.sms should have a INSTALL program and a UNINSTALL program and optionally a REPAIR program.
		
		There should exist a DetectionMethod.ps1 file in the same folder as the PackageDefintion.sms and this PowerShell script
		should contain the logic detecting if the application is installed, following the rules stated by:
		https://docs.microsoft.com/en-us/previous-versions/system-center/system-center-2012-R2/gg682159(v=technet.10)#to-use-a-custom-script-to-determine-the-presence-of-a-deployment-type

		The same folder as PackageDefinition.sms is the source path of the application.
		
		.EXAMPLE
		New-SAMCmApplicationFromPackageDefinitionSms -Path c:\temp\Package01\PackageDefinition.sms

		.EXAMPLE
		$allPackageDefinitionSms = Get-ChildItem -Path "\\sccmserver01\pkgsrc\applications" -Filter "PackageDefinition.sms" -Recurse -Depth 4
		$allPackageDefinitionSms | New-SAMCmApplicationFromPackageDefinitionSms

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
		[Alias("FullName")]
		[string[]]
		$Path
	)
	
	begin
	{
		Connect-SAMCmSite		
	}
	process
	{
		foreach($p in $Path)
		{
			try {				
				Assert-SAMFileExists -Path $p -Message "Failed to create application. PackageDefinition.sms is required."
				
				$sourcePath = $([System.IO.FileInfo]$p).Directory.FullName

				$detectionMethodsPs1 = [System.IO.Path]::Combine($sourcePath,"DetectionMethod.ps1")
				Assert-SAMFileExists -Path $detectionMethodsPs1 -Message "Failed to create application. DetectionMethod.ps1 is required."

				[PackageDefinitionSms]$packageDefinitionSms = Import-SAMPackageDefinitionSms -Path $p
				$packageDefinitionSms
				
				$appName = $($packageDefinitionSms.Name)
				if((Test-SAMCmApplicationExists -Name $appName) -eq $false)
				{
					$app = New-CmApplication -Name $appName -Publisher $($packageDefinitionSms.Publisher) -AutoInstall $true -SoftwareVersion $($packageDefinitionSms.Vesion)
					[ProgramSms]$installProgram = $packageDefinitionSms.Programs | Where-Object{$_.Name -eq "INSTALL"} | Select-Object -First 1
					[ProgramSms]$uninstallProgram = $packageDefinitionSms.Programs | Where-Object{$_.Name -eq "UNINSTALL"} | Select-Object -First 1				
					$deploymentType = Add-CMScriptDeploymentType -ApplicationName $appName -DeploymentTypeName "Custom-Script-Installer" -InstallCommand $($installProgram.CommandLine) -UninstallCommand $($uninstallProgram.CommandLine) -ContentLocation $sourcePath -ScriptFile $detectionMethodsPs1 -ScriptLanguage PowerShell
				}
				else {
					Write-Warning "Application '$appName' allready exists."
				}				
			}
			catch {
				Write-Host "New-SAMCmApplicationFromPackageDefinitionSms failed processing '$($p)' due to: $($_.Exception.Message) (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))"
			}
		}
	}
	end
	{
	
	}
}
#TEST
#$allPackageDefinitionSms = Get-ChildItem -Path "c:\temp\packages" -Filter "PackageDefinition.sms" -File -Recurse -Depth 4
#$allPackageDefinitionSms | New-SAMCmApplicationFromPackageDefinitionSms