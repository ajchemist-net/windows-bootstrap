#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"


Import-Module -DisableNameChecking $PSScriptRoot\..\lib\read-password.psm1


Write-Host "BitLocker data volume..."
$DataDrive = Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru
$data_drive_pw = Read-Password
Enable-BitLocker $DataDrive.root -UsedSpaceOnly -PasswordProtector -Password $data_drive_pw
$data_volume = Add-BitLockerKeyProtector $DataDrive.root -RecoveryPasswordProtector
$data_recovery_pw = $data_volume.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" } | Select-Object -ExpandProperty RecoveryPassword
$startScriptContent = [string]::Format("Unlock-BitLocker {0} -RecoveryPassword {1}", $DataDrive.root, $data_recovery_pw)
mkdir -p $env:SystemRoot\System32\GroupPolicy\Machine\Scripts\Startup
Add-Content -Path "$env:SystemRoot\System32\GroupPolicy\Machine\Scripts\Startup\unlock_bitlocker_data_drive.ps1" -Value $startScriptContent


<#
gpedit.msc
Unlock-BitLocker -MountPoint $DataDrive.root -RecoveryPassword $SecureString
#>


<#
$system_drive_pw = Read-Password
Enable-BitLocker $env:SystemDrive -UsedSpaceOnly -PasswordProtector -Password $system_drive_pw
Add-BitLockerKeyProtector $env:SystemDrive -RecoveryPasswordProtector
#>


Get-BitLockerVolume
