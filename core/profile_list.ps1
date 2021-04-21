[CmdletBinding()]
param(
    [System.IO.FileInfo]
    [Parameter(Mandatory=$true)]
    [ValidateScript(
         {
             if( -Not ($_ | Test-Path) )
             {
                 throw "File or folder does not exist: $_"
             }
             return $true
         })]
    $DataDrive,

    [System.IO.FileInfo]
    $DebugDir = (New-Item -ItemType Directory -Path $DataDrive -Name "Bootstrap_Debug" -Force).FullName
)


#Requires -RunAsAdministrator


$ErrorActionPreference = "Stop"


#


New-Variable -Name ProfileListRegKey -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
New-Variable -Name ProfileListRegKey_Default_Value -Value (Join-Path $DataDrive -ChildPath "\Users\Default")
New-Variable -Name ProfileListRegKey_ProfilesDirectory_Value -Value (Join-Path $DataDrive -ChildPath "\Users")
New-Variable -Name ProfileListRegKey_ProgramData_Value -Value (Join-Path $DataDrive -ChildPath "\ProgramData")
New-Variable -Name ProfileListRegKey_Public_Value -Value (Join-Path $DataDrive -ChildPath "\Users\Public")


Function Export-ProfileList()
{
    Write-Host "*** ProfileList Original"
    Get-Item $ProfileListRegKey
    reg export (Convert-Path $ProfileListRegKey) "$DebugDir\ProfileList.reg" /y
}


Export-ProfileList


Write-Host "*** ProfileList Modification"
New-ItemProperty -Path $ProfileListRegKey -Name "Default" -PropertyType ExpandString -Force -Value $ProfileListRegKey_Default_Value | Out-Null
New-ItemProperty -Path $ProfileListRegKey -Name "ProfilesDirectory" -PropertyType ExpandString -Force -Value $ProfileListRegKey_ProfilesDirectory_Value | Out-Null
New-ItemProperty -Path $ProfileListRegKey -Name "ProgramData" -PropertyType ExpandString -Force -Value $ProfileListRegKey_ProgramData_Value | Out-Null
New-ItemProperty -Path $ProfileListRegKey -Name "Public" -PropertyType ExpandString -Force -Value $ProfileListRegKey_Public_Value | Out-Null


Write-Host "*** ProfileList Changed"
Get-Item $ProfileListRegKey | Out-String | Write-Host


$dateSuffix = (Get-Date).toString("yyyy-MM-dd")
if (Test-Path $ProfileListRegKey_ProfilesDirectory_Value)
{
    mv $ProfileListRegKey_ProfilesDirectory_Value "$ProfileListRegKey_ProfilesDirectory_Value.$dateSuffix"
}
if (Test-Path $ProfileListRegKey_ProgramData_Value)
{
    mv $ProfileListRegKey_ProgramData_Value "$ProfileListRegKey_ProgramData_Value.$dateSuffix"
}
New-Item -ItemType directory -Path (Get-ItemPropertyValue $ProfileListRegKey -Name "ProfilesDirectory") -Force
New-Item -ItemType directory -Path (Get-ItemPropertyValue $ProfileListRegKey -Name "ProgramData") -Force
robocopy "$env:SystemDrive\Users" (Get-ItemPropertyValue $ProfileListRegKey -Name "ProfilesDirectory") /mt:10 /e /copyall /xj /r:0 /LOG+:"$DebugDir\ProfileList.Users.robocopy.txt"
robocopy "$env:SystemDrive\ProgramData" (Get-ItemPropertyValue $ProfileListRegKey -Name "ProgramData") /mt:10 /e /copyall /xj /r:0 /LOG+:"$DebugDir\ProfileList.ProgramData.robocopy.txt"
