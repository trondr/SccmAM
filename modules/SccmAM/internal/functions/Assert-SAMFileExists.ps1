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
        if(Test-Path -Path filesystem::$Path -PathType Leaf)
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
#TEST:
#$Path = "\\someserver\PkgSrc$\Applications\App1\PackageDefinition.sms"
#Assert-SAMFileExists -Path $Path -Message "Important file not found."