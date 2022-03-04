function Get-SAMIniFileValue
{
	<#
		.SYNOPSIS
		Read value from ini file.
		
		.DESCRIPTION
		Read value from ini file.

		.EXAMPLE
		Get-SAMIniFileValue -Path "c:\temp\package01\PackageDefinition.sms" -Section "Package Definition" -Key "Name"

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
        [string]
		$Path,
        [Parameter(Mandatory=$true)]
        [string]
		$Section,
        [Parameter(Mandatory=$true)]
        [string]
		$Key,
		[switch]
		$AllowEmptyOrNull
	)
	
	begin
	{
		
	}
	process
	{
		$value = [SccmAM.IniFile]::Read($Path,$Section,$Key)
		if($AllowEmptyOrNull -eq $false)
		{
			Assert-SAMStringIsNotNullOrWhiteSpace $value -Message "$Path[$Section]$Key"
		}		
		Write-Output -InputObject $value
	}
	end
	{
	
	}
}