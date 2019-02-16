$ErrorActionPreference = "Stop"


Function Set-RegistryValue()
{
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    Param($key, $name, $value, $type="Dword")
    if ((Test-Path -Path $key) -eq $false)
    {
        New-Item -ItemType directory -Path $key | Out-Null
    }
    If ($pscmdlet.ShouldProcess($value))
    {
       Set-ItemProperty -Path $key -Name $name -Value $value -Type $type
    }
}


# * Reset policy registry


Set-RegistryValue -Key "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
Set-RegistryValue -Key "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
Set-RegistryValue -Key "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1


# * Report policy


Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate"
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring"
