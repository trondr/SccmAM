function Assert-SAMStringIsNotNullOrWhiteSpace
{
	<#
		.SYNOPSIS
		Assert that string value is not null or white space.
		
		.DESCRIPTION
		Assert that string value is not null or white space.

		.EXAMPLE
		Assert-SAMStringIsNotNullOrWhiteSpace

		.NOTES        
		Version:        1.0
		Author:         eta410
		Company:        MyCompany
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline=$true)]
		[string]
		$Text,
		[Parameter(Mandatory=$true)]
        [string]
        $Message
	)
	
	begin
	{
		
	}
	process
	{
		if([string]::IsNullOrWhiteSpace($Text))
        {
            throw "Value '$Text' is null or white space. $Message"
        }        
	}
	end
	{
	
	}
}