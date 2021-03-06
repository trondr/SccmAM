function New-SAMCmApplicationFromPackageDefinitionSms
{
	<#
		.SYNOPSIS
		PowerShell cmdlets creating Sccm Applications from custom PackageDefinition.sms using InstallDetection.ps1 script as detection method.
		
		.DESCRIPTION
		PowerShell cmdlets creating Sccm Applications from custom PackageDefinition.sms using InstallDetection.ps1 script as detection method.

		PackageDefinition.sms should have a INSTALL program and a UNINSTALL program and optionally a REPAIR program.
		
		There should exist a InstallDetection.ps1 file in the same folder as the PackageDefintion.sms and this PowerShell script
		should contain the logic detecting if the application is installed, following the rules stated by:
		https://docs.microsoft.com/en-us/previous-versions/system-center/system-center-2012-R2/gg682159(v=technet.10)#to-use-a-custom-script-to-determine-the-presence-of-a-deployment-type

		The same folder as PackageDefinition.sms is the source path of the application.
		
		.EXAMPLE
		New-SAMCmApplicationFromPackageDefinitionSms -Path c:\temp\Package01\PackageDefinition.sms

		.EXAMPLE
		Write-Host "Create applications for all PackageDefinition.sms found in a directory tree."
		$applicationsPath = "Z:\Applications"
		$allPackageDefinitionSms = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
		$allPackageDefinitionSms | New-SAMCmApplicationFromPackageDefinitionSms -Verbose

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
				[PackageDefinitionSms]$packageDefinitionSms = Import-SAMPackageDefinitionSms -Path $p	
				Assert-SAMIsNotNull -InputObject $packageDefinitionSms -Message "PackageDefinition is not defined."
				$appName = $($packageDefinitionSms.Name)

				$sourcePath = $([System.IO.FileInfo]$p).Directory.FullName
				$sourceUncPath = [SccmAM.PathOperation]::GetUncPath($sourcePath,$false)

				$InstallDetectionsPs1 = [System.IO.Path]::Combine($sourcePath,"InstallDetection.ps1")
				Write-Verbose "Asserting that InstallDetection.ps1 ($InstallDetectionsPs1) exists."
				Assert-SAMFileExists -Path $InstallDetectionsPs1 -Message "Failed to create application '$appName'. InstallDetection.ps1 is missing."
				Assert-SAMFileIsNotEmpty -Path $InstallDetectionsPs1 -Message "Failed to create application '$appName'. InstallDetection.ps1 is empty."

				
				if((Test-SAMCmApplicationExists -Name $appName) -eq $false)
				{
					Write-Host "Creating application '$appName'..." -ForegroundColor Green -NoNewline
					[ProgramSms]$installProgram = $packageDefinitionSms.Programs | Where-Object{$_.Name -eq "INSTALL"} | Select-Object -First 1
					Assert-SAMIsNotNull -InputObject $installProgram -Message "INSTALL program must be defined in PackageDefinition.sms."
					[ProgramSms]$uninstallProgram = $packageDefinitionSms.Programs | Where-Object{$_.Name -eq "UNINSTALL"} | Select-Object -First 1
					Assert-SAMIsNotNull -InputObject $uninstallProgram -Message "UNINSTALL program must be defined in PackageDefinition.sms."

					[ProgramSms]$repairProgram = $packageDefinitionSms.Programs | Where-Object{$_.Name -eq "REPAIR"} | Select-Object -First 1

					$app = New-CmApplication -Name $appName -Publisher $($packageDefinitionSms.Publisher) -AutoInstall $true -SoftwareVersion $($packageDefinitionSms.Vesion)
					Assert-SAMIsNotNull -InputObject $app -Message "Application '$appName' was not created."					
					$parameters = @{
						ApplicationName = "$appName" 
						DeploymentTypeName = "Custom-Script-Installer"
						Comment = "Generated by SccmAM PowerShell module"
						InstallCommand = $($installProgram.CommandLine)
						UninstallCommand = $($uninstallProgram.CommandLine)
						ContentLocation = $sourceUncPath
						EstimatedRuntimeMins = 10
						MaximumRuntimeMins = 30
						InstallationBehaviorType = "InstallForSystem"
						LogonRequirementType = "WhetherOrNotUserLoggedOn"
						UserInteractionMode = "Hidden"
						CacheContent = $true
						ContentFallback = $true						
						SlowNetworkDeploymentMode = "Download"
						ScriptLanguage = "PowerShell"
                    	ScriptFile = $InstallDetectionsPs1
					}
					if($null -ne $repairProgram -and ([string]::IsNullOrWhiteSpace($repairProgram.CommandLine) -eq $false))
					{
						$parameters += @{
							RepairCommand = $($repairProgram.CommandLine)
						}
					}					
					$deploymentType = Add-CMScriptDeploymentType @parameters
					Assert-SAMIsNotNull -InputObject $deploymentType -Message "DeploymentType for '$appName' was not created."
					Write-Host "Done!" -ForegroundColor Green
				}
				else {
					Write-Warning "Application '$appName' allready exists."
				}				
			}
			catch {
				Write-Host "New-SAMCmApplicationFromPackageDefinitionSms failed processing '$($p)' due to: $($_.Exception.Message) (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))" -ForegroundColor Red
			}
		}
	}
	end
	{
	
	}
}
#TEST
# $allPackageDefinitionSms = Get-ChildItem -Path "c:\temp\packages" -Filter "PackageDefinition.sms" -File -Recurse -Depth 4
# $allPackageDefinitionSms | New-SAMCmApplicationFromPackageDefinitionSms

# $applicationsPath = "Z:\Applications"
# $allPackageDefinitionSms = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
# $allPackageDefinitionSms | New-SAMCmApplicationFromPackageDefinitionSms -Verbose
