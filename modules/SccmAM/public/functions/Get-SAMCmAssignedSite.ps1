function Get-SAMCmAssignedSite
{
	<#
		.SYNOPSIS
		Get Sccm assigned site
		
		.DESCRIPTION
		Get Sccm assigned site

		.EXAMPLE
		Get-SAMCmAssignedSite

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline=$true)]
		$InputObject
	)
	
	begin
	{
		Assert-SAMCmClientIsInstalled
	}
	process
	{
		$((New-Object -ComObject "Microsoft.SMS.Client").GetAssignedSite())
	}
	end
	{
	
	}
}