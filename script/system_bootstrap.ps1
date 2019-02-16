[System.Environment]::OSVersion


$ErrorActionPreference = "Stop"


$selfdir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)


$DataDrive = Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru
$DebugDir = (New-Item -ItemType directory -Path $DataDrive -Name "\system_bootstrap" -Force).FullName


Import-Module "$selfdir\core\profile_list.ps1"
Import-Module "$selfdir\core\policies.ps1"
