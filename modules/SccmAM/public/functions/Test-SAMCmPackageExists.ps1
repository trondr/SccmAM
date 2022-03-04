function Test-SAMCmPackageExists
{
	<#
		.SYNOPSIS
		Check if Sccm Package exists.
		
		.DESCRIPTION
		Check if Sccm Package exists.

		.EXAMPLE
		Test-SAMCmPackageExists -Name "Test Package 1.0"

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		$Name
	)
	
	begin
	{
		
	}
	process
	{
		$package = Get-CMPackage -Name $Name -Fast -ErrorAction SilentlyContinue
		if($null -eq $package)
		{
			$false
		}
		else {
			$true
		}
	}
	end
	{
	
	}
}