class ProgramSms
{
    [string]$Name
    [string]$CommandLine
    [string]$Comment

    ProgramSms([string]$Name,[string]$CommandLine,[string]$Comment)
    {
        $this.Name = $Name
        $this.CommandLine = $CommandLine
        $this.Comment = $Comment
    }
}

class PackageDefinitionSms
{
    [string]$Name
    [string]$Version    
    [string]$Publisher
    [string]$Comment
    [ProgramSms[]]$Programs

    PackageDefinitionSms([string]$Name,[string]$Version,[string]$Publisher,[string]$Comment,[ProgramSms[]]$Programs)
    {
        $this.Name = $Name
        $this.Version = $Version
        $this.Comment = $Comment
        $this.Programs = $Programs
    }
}
