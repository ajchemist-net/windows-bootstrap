Function Set-RegistryValue()
{
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    Param(
        [string]
        $key,

        [string]
        $name,

        $value,

        $type="Dword"
    )
    if ((Test-Path -Path $key) -eq $false)
    {
        New-Item -ItemType directory -Path $key -Force | Out-Null
    }
    If ($pscmdlet.ShouldProcess($value))
    {
       Set-ItemProperty -Path $key -Name $name -Value $value -Type $type
    }
}


Set-RegistryValue -Key "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -Value 0
Set-RegistryValue -Key "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1


Get-NetFirewallRule -Name "RemoteDesktop*" | Enable-NetFirewallRule


Test-NetConnection localhost -CommonTCPPort rdp
