function Test-SAMCmApplicationExists
{
	<#
		.SYNOPSIS
		Check if Sccm Application exists.
		
		.DESCRIPTION
		Check if Sccm Application exists.

		.EXAMPLE
		Test-SAMCmApplicationExists -Name "Test Application 1"

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
		$application = Get-CMApplication -Name $Name -Fast -ErrorAction SilentlyContinue
		if($null -eq $application)
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
#TEST:
#Test-SAMCmApplicationExists -Name "Test Application 1"
#Test-SAMCmApplicationExists -Name "My Product"