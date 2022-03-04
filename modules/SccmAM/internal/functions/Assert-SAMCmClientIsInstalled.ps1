function Assert-SAMCmClientIsInstalled
{
	<#
		.SYNOPSIS
		Assert that Sccm Client is installed
		
		.DESCRIPTION
		Assert that Sccm Client is installed

		.EXAMPLE
		Assert-SAMCmClientIsInstalled

		.NOTES        
		Version:        1.0
		Author:         github.com/trondr
		Company:        github.com/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline=$true)]
		$InputObject
	)
	
	begin
	{
		
	}
	process
	{
		try {
 			$((New-Object -ComObject "Microsoft.SMS.Client").GetAssignedSite()) | Out-Null
		}
		catch {
			throw "SCCM Client is not installed. Please install SCCM client and try again."
		}
	}
	end
	{
	
	}
}
#TEST:
#Assert-SAMCmClientIsInstalled