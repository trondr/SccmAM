function Assert-SAMFileExists
{
	<#
		.SYNOPSIS
		Assert that file exists.
		
		.DESCRIPTION
		Assert that file exists.

		.EXAMPLE
		Assert-SAMFileExists -Path "c:\temp\somefile.txt" -Message "Can not continue with the important stuff due to some file not found."

		.NOTES        
		Version:        1.0
		Author:         github/trondr
		Company:        github/trondr
		Repository:     https://github.com/trondr/SccmAM.git
	#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Path,
        [Parameter(Mandatory=$true)]
        [string]
        $Message
    )
    
    begin {
        
    }
    
    process {
        if(Test-Path -Path $Path)
        {
            Write-Verbose "File exists: $Path"
        }
        else {
            throw "File does not exist: '$Path'. $Message"
        }
    }
    
    end {
        
    }
}