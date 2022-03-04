function Assert-SAMIsNotNull
{
	<#
		.SYNOPSIS
		Assert that object is not null
		
		.DESCRIPTION
		Assert that object is not null

		.EXAMPLE
		Assert-SAMIsNotNull -InputObject $object

		.NOTES        
		Version:        1.0
		Author:         trondr
		Company:        MyCompany
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
		$InputObject=$null,
		[Parameter(Mandatory=$true)]
		[string]
		$Message
	)
	
	begin
	{
		
	}
	process
	{
		if($null -eq $InputObject)
        {
            throw "Object '$InputObject' is null. $Message"
        }  
	}
	end
	{
	
	}
}
#TEST
#$object = ""
#Assert-SAMIsNotNull -InputObject $object -Message "Important object is null."
#$object = $null
#Assert-SAMIsNotNull -InputObject $object -Message "Important object is null."