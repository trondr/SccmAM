class ProgramSms
{
    [ValidateLength(1,50)]
    [string]$Name
    [ValidateLength(1,127)]
    [string]$CommandLine
    [ValidateLength(1,127)]
    [string]$Comment
    [string]$Icon

    ProgramSms([string]$Name,[string]$CommandLine,[string]$Comment,[string]$Icon)
    {
        try {
            $this.Name = $Name
            $this.CommandLine = $CommandLine
            $this.Comment = $Comment
            $this.Icon = $Icon
        }
        catch {
            Write-Error "Failed to construct ProgramSms object due to: $($_.Exception.Message) (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))" -ErrorAction Stop
        }
    }
}
#TEST
#[ProgramSms]::New("50505050505050505050505050505050505050505050505050","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127")
#[ProgramSms]::New("5050505050505050505050505050505050505050505050505052","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127")
#[ProgramSms]::New("50505050505050505050505050505050505050505050505050","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127TooLong","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127")
#[ProgramSms]::New("50505050505050505050505050505050505050505050505050","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127ToLoong")

class PackageDefinitionSms
{
    [ValidateLength(1,50)]
    [string]$Name
    [ValidateLength(1,32)]
    [string]$Version    
    [ValidateLength(1,32)]
    [string]$Publisher
    [ValidateLength(1,127)]
    [string]$Comment
    [ValidateLength(1,32)]
    [string]$Language
    [ProgramSms[]]$Programs
    [string]$Icon

    PackageDefinitionSms([string]$Name,[string]$Version,[string]$Publisher,[string]$Comment,[string]$Language,[ProgramSms[]]$Programs,[string]$Icon)
    {
        try {
            $this.Name = $Name
            $this.Version = $Version
            $this.Publisher = $Publisher
            $this.Comment = $Comment
            $this.Language = $Language
            $this.Programs = $Programs
            $this.Icon = $Icon
        }
        catch {
            Write-Error "Failed to construct PackageDefinitionSms object due to: $($_.Exception.Message) (Line: $($_.InvocationInfo.ScriptLineNumber))(Script: $($_.InvocationInfo.ScriptName))" -ErrorAction Stop
        }        
    }
}
#TEST
#[PackageDefinitionSms]::New("50505050505050505050505050505050505050505050505050","32323232323232323232323232323232","32323232323232323232323232323232","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","32323232323232323232323232323232",@())
#[PackageDefinitionSms]::New("5252525252525252525252525252525252525252525252525252","32323232323232323232323232323232","32323232323232323232323232323232","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","32323232323232323232323232323232",@())
#[PackageDefinitionSms]::New("50505050505050505050505050505050505050505050505050","3434343434343434343434343434343434","32323232323232323232323232323232","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","32323232323232323232323232323232",@())
#[PackageDefinitionSms]::New("50505050505050505050505050505050505050505050505050","32323232323232323232323232323232","3232323232323232323232323232323234","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","32323232323232323232323232323232",@())
#[PackageDefinitionSms]::New("50505050505050505050505050505050505050505050505050","32323232323232323232323232323232","32323232323232323232323232323232","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","32323232323232323232323232323232",@())
#[PackageDefinitionSms]::New("50505050505050505050505050505050505050505050505050","32323232323232323232323232323232","32323232323232323232323232323232","127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127127","3232323232323232323232323232323234",@())