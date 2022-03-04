function Import-SAMPackageDefinitionSms
{
	<#
		.SYNOPSIS
		Import PackageDefinition.sms file to a PackageDefinitionSms object.
		
		.DESCRIPTION
		Import PackageDefinition.sms file to a PackageDefinitionSms object.

		.EXAMPLE
		Import-SAMPackageDefinitionSms -Path "c:\temp\package01\PackageDefinition.sms"

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
		
	}
	process
	{
		foreach($p in $Path)
		{
			try {
				Assert-SAMFileExists -Path $p -Message "PackageDefinition.sms file not found."
				$Name = Get-SAMIniFileValue -Path $p -Section "Package Definition" -Key "Name"
				$Version = Get-SAMIniFileValue -Path $p -Section "Package Definition" -Key "Version"
				$Publisher = Get-SAMIniFileValue -Path $p -Section "Package Definition" -Key "Publisher"
				$Comment = Get-SAMIniFileValue -Path $p -Section "Package Definition" -Key "Comment"
				$Programs = $(Get-SAMIniFileValue -Path $p -Section "Package Definition" -Key "Programs")  -Split ","
				$ProgramSmsArray = $Programs | ForEach-Object{
					$programName = Get-SAMIniFileValue -Path $p -Section $_ -Key "Name";
					$commandLine = Get-SAMIniFileValue -Path $p -Section $programName -Key "CommandLine";
					$programComment = Get-SAMIniFileValue -Path $p -Section $programName -Key "Comment"
					Write-Output -InputObject $([ProgramSms]::New($programName,$CommandLine,$programComment))
				}				
				Write-Output -InputObject $([PackageDefinitionSms]::New($Name,$Version,$Publisher,$Comment,$ProgramSmsArray))
			}
			catch {
				Write-Host "Import-SAMPackageDefinitionSms failed processing '$($p)' due to: $($_.Exception.Message). (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))"
			}
		}
	}
	end
	{
	
	}
}
#TEST:
#Import-SAMPackageDefinitionSms -Path "c:\temp\PackageDefinition.sms"