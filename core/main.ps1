#Requires -RunAsAdministrator


<#
[System.Environment]::OSVersion
#>


$ErrorActionPreference = "Stop"


$self = $PSCommandPath
$selfdir = $PSScriptRoot
$parentdir = (Get-Item $selfdir).parent.fullName


Write-Host "Choose DATA Drive..."


$DataDrive = (Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru).root
$DebugDir = (New-Item -ItemType Directory -Path $DataDrive -Name "Bootstrap_Debug" -Force).FullName


# * Registry Import
reg import "$parentdir\core\capslock_ctrl.reg"


# * Run subscript
& "$parentdir\core\profile_list.ps1" -DataDrive $DataDrive 2>&1 | Out-String
& "$parentdir\core\vmhost.ps1" -VMDrive $DataDrive
