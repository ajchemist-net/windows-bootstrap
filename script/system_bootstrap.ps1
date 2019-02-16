[System.Environment]::OSVersion


$ErrorActionPreference = "Stop"


$selfdir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$parentdir = (Get-Item $selfdir).parent


$DataDrive = Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru
$DebugDir = (New-Item -ItemType directory -Path $DataDrive -Name "\system_bootstrap" -Force).FullName


Import-Module "$parentdir\core\profile_list.ps1"
Import-Module "$parentdir\core\policies.ps1"
