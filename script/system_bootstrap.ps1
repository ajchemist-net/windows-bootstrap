[System.Environment]::OSVersion


$ErrorActionPreference = "Stop"


$selfdir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$moduledir = (Get-Item $selfdir).parent.parent


$DataDrive = Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru
$DebugDir = (New-Item -ItemType directory -Path $DataDrive -Name "\system_bootstrap" -Force).FullName


Import-Module "$moduledir\core\profile_list.ps1"
Import-Module "$moduledir\core\policies.ps1"
