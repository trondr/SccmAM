function Assert-SAMFileIsNotEmpty
{
	<#
		.SYNOPSIS
		Assert that file has size greater than zero
		
		.DESCRIPTION
		Assert that file has size greater than zero

		.EXAMPLE
		Assert-SAMFileIsNotEmpty -Path "c:\temp\DetectionMethod.ps1" -Message "Important file cannot be of zero length."

		.NOTES        
		Version:        1.0
		Author:         trondr
		Company:        MyCompany
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
        [string]
        $Path,
        [Parameter(Mandatory=$true)]
        [string]
        $Message
	)
	
	begin
	{
		
	}
	process
	{
		if((Test-Path -Path filesystem::$Path -PathType Leaf) -eq $false)
        {
            throw "File does not exist: '$Path'. The file should exist and have non-zero length. $Message"
        }
		$fileInfo = [System.IO.FileInfo]$Path
		if($fileInfo.Length -eq 0)
		{
			throw "File has zero lenght: '$Path'. The file should have non-zero length. $Message"
		}
	}
	end
	{
	
	}
}
#TEST:
# Assert-SAMFileIsNotEmpty -Path "c:\temp\DetectionMethod.ps1" -Message "Important file cannot be of zero length."
# Assert-SAMFileIsNotEmpty -Path "Z:\Applications\App1\DetectionMethod.ps1" -Message "Important file cannot be of zero length."
# Assert-SAMFileIsNotEmpty -Path "c:\temp\Packages\App1\DetectionMethod.ps1" -Message "Important file cannot be of zero length."