function New-SAMCmPackageFromPackageDefinitionSms
{
	<#
		.SYNOPSIS
		Create new Sccm Package from PackageDefintion.sms.
		
		.DESCRIPTION
		Create new Sccm Package from PackageDefintion.sms.

		.EXAMPLE
		New-SAMCmPackageFromPackageDefinitionSms -Path c:\temp\Package01\PackageDefinition.sms

		.EXAMPLE
		Write-Host "Create packages for all PackageDefinition.sms found in a directory tree."
		$applicationsPath = "Z:\Applications"
		$allPackageDefinitionSms = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
		$allPackageDefinitionSms | New-SAMCmPackageFromPackageDefinitionSms -Verbose

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

				if((Test-SAMCmPackageExists -Name $appName) -eq $false)
				{
					Write-Host "Creating package '$appName'..." -ForegroundColor Green -NoNewline
					$parameters = @{
						Name = $appName
						Description = $($packageDefinitionSms.Comment)
						Manufacturer = $($packageDefinitionSms.Publisher)
						Version = $($packageDefinitionSms.Version)						
						Path = $sourceUncPath
					}
					if($packageDefinitionSms.Language)
					{
						$parameters += @{
							Language = $($packageDefinitionSms.Language)
						}
					}

					$package = New-CMPackage @parameters
					Assert-SAMIsNotNull -InputObject $package -Message "Package '$appName' was not created."
					$packageDefinitionSms.Programs | ForEach-Object{
						$smsProgram = $_
						$programParameters = @{
							PackageName = $appName
							StandardProgramName = $smsProgram.Name
							CommandLine = $smsProgram.CommandLine
							RunType = "Hidden"
							RunMode = "RunWithAdministrativeRights"
							ProgramRunType = "WhetherOrNotUserIsLoggedOn"
							UserInteraction = $false
							Duration = 15
						}						
						$program = New-CMProgram @programParameters
						Assert-SAMIsNotNull -InputObject $program -Message "Program '$($appName)->$($smsProgram.Name)' was not created."
					}
					Write-Host "Done!" -ForegroundColor Green
				}
				else {
					Write-Warning "Package '$appName' allready exists."
				}
			}
			catch {
				Write-Host "New-SAMCmPackageFromPackageDefinitionSms failed processing '$($p)' due to: $($_.Exception.Message) (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))" -ForegroundColor Red
			}
		}
	}
	end
	{
	
	}
}
# $applicationsPath = "Z:\Applications"
# $allPackageDefinitionSms = Get-ChildItem -Path filesystem::$applicationsPath -Filter "PackageDefinition.sms" -Recurse -Depth 4
# $allPackageDefinitionSms | New-SAMCmPackageFromPackageDefinitionSms -Verbose