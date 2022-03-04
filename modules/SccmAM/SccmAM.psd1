@{
	# Script module or binary module file associated with this manifest
	RootModule = 'SccmAM.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.22061'
	
	# ID used to uniquely identify this module
	GUID = 'ac26a7ab-84ec-483d-8ef3-770d154b8db1'
	
	# Author of this module
	Author = 'github/trondr'
	
	# Company or vendor of this module
	CompanyName = 'github/trondr'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2022 github/trondr'
	
	# Description of the functionality provided by this module
	Description = 'PowerShell cmdlets creating Sccm Applications from custom PackageDefinition.sms and DetectionMethod.ps1'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Modules that must be imported into the global environment prior to importing this module
	# RequiredModules = @(@{ ModuleName='PSFramework'; ModuleVersion='1.6.214' })
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\SccmAM.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# Expensive for import time, no more than one should be used.
	# TypesToProcess = @('xml\SccmAM.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module.
	# Expensive for import time, no more than one should be used.
	FormatsToProcess = @('SccmAM.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'Assert-SAMFileExists'
		,'Assert-SAMCmManagerConsoleIsInstalled'
		,'Assert-SAMCmClientIsInstalled'
		,'Connect-SAMCmSite'
		,'Get-SAMCmAssignedSite'
		,'Get-SAMCmCurrentManagementPoint'
		,'Import-SAMPackageDefinitionSms'
		,'Assert-SAMStringIsNotNullOrWhiteSpace'
		,'New-SAMCmApplicationFromPackageDefinitionSms'
		,'Test-SAMCmApplicationExists'
		,'Assert-SAMIsNotNull'
		,'Assert-SAMFileIsNotEmpty'
	)
	
	# Cmdlets to export from this module
	CmdletsToExport = @()
	
	# Variables to export from this module
	VariablesToExport = @()
	
	# Aliases to export from this module
	AliasesToExport = @()
	
	# List of all files packaged with this module
	FileList = @('')
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @(
				,'Sccm'
				,'SccmAM'
				,'Connect-SAMCmSite'
				,'Get-SAMCmAssignedSite'
				,'Get-SAMCmCurrentManagementPoint'
			)
			
			# A URL to the license for this module.
			LicenseUri = 'https://github.com/trondr/SccmAM/blob/master/LICENSE'
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/trondr/SccmAM'
			
			# A URL to an icon representing this module.
			IconUri = 'https://raw.githubusercontent.com/trondr/SccmAM/master/src/graphics/SccmAM.png'
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}