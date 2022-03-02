function Get-SAMCmCurrentManagementPoint
{
	<#
		.SYNOPSIS
		Get current Sccm management point
		
		.DESCRIPTION
		Get current Sccm management point

		.EXAMPLE
		Get-SAMCmCurrentManagementPoint

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (		
	)
	
	begin
	{
		Assert-SAMCmClientIsInstalled
	}
	process
	{
		(New-Object -ComObject "Microsoft.SMS.Client").GetCurrentManagementPoint()
	}
	end
	{
	
	}
}