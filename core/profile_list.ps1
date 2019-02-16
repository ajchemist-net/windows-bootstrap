$ErrorActionPreference = "Stop"


#


Write-Host "Choose DATA Drive..."


$DataDrive = @({Get-PSDrive -PSProvider FileSystem | Out-GridView -PassThru},$DataDrive)[!($DataDrive -eq $null)]


if (Test-Path $DataDrive.root)
{
    Write-Error "No Such Drive: $($DataDrive.root)"
}


#


New-Variable -Name ProfileListRegKey -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"


Function Export-ProfileList()
{
    Write-Host "*** ProfileList Original"
    Get-Item $ProfileListRegKey
    reg export (Convert-Path $ProfileListRegKey) "$DebugDir\ProfileList.reg"
}


Export-ProfileList


Write-Host "*** ProfileList Modification"
New-ItemProperty -Path $ProfileListRegKey -Name "Default" -PropertyType ExpandString -Value (Join-Path $DataDrive.root -ChildPath "\Users\Default")  -Force
New-ItemProperty -Path $ProfileListRegKey -Name "ProfilesDirectory" -PropertyType ExpandString -Value (Join-Path $DataDrive.root -ChildPath "\Users") -Force
New-ItemProperty -Path $ProfileListRegKey -Name "ProgramData" -PropertyType ExpandString -Value (Join-Path $DataDrive.root -ChildPath "\ProgramData") -Force
New-ItemProperty -Path $ProfileListRegKey -Name "Public" -PropertyType ExpandString -Value (Join-Path $DataDrive.root -ChildPath "\Users\Public") -Force


Write-Host "*** ProfileList Changed"
Get-Item $ProfileListRegKey


Remove-Item (Get-ItemPropertyValue $ProfileListRegKey -Name "ProfilesDirectory") -Recurse -Force
Remove-Item (Get-ItemPropertyValue $ProfileListRegKey -Name "ProgramData") -Recurse -Force
New-Item -ItemType directory -Path (Get-ItemPropertyValue $ProfileListRegKey -Name "ProfilesDirectory")
New-Item -ItemType directory -Path (Get-ItemPropertyValue $ProfileListRegKey -Name "ProgramData")
robocopy "$env:SystemDrive\Users" (Get-ItemPropertyValue $ProfileListRegKey -Name "ProfilesDirectory") /mt:10 /e /copyall /xj /r:0 /LOG+:"$DebugDir\ProfileList.Users.robocopy.txt"
robocopy "$env:SystemDrive\ProgramData" (Get-ItemPropertyValue $ProfileListRegKey -Name "ProgramData") /mt:10 /e /copyall /xj /r:0 /LOG+:"$DebugDir\ProfileList.ProgramData.robocopy.txt"
Remove-Item "$env:SystemDrive\Users" -Recurse -Force
Remove-Item "$env:SystemDrive\ProgramData" -Recurse -Force


#


Export-ModuleMember -Function Export-ProfileList
