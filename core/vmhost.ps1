[CmdletBinding()]
param(
    [System.IO.FileInfo]
    [Parameter()]
    [ValidateScript({ Test-Path $_ })]
    $VMDrive = (Get-Item (Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "ProfilesDirectory")).PSDrive.root
)


#Requires -RunAsAdministrator


$VMPath = Join-Path -Path $VMDrive -ChildPath "private\vm\Hyper-V"
$VHDPath = Join-Path -Path $VMDrive -ChildPath "private\vm\Hyper-V\Drives"


MD -Path $VMPath,$VHDPath -ErrorAction 0


Set-VMHost -VirtualHardDiskPath $VHDPath -VirtualMachinePath $VMPath


Get-VMHost | Format-List | Out-String | Write-Host
