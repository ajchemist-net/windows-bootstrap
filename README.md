---
title: Windows Bootstrap
author: ajchemist
description: Windows Bootstrap
---


# Windows Bootstrap #


- `Shift-F10`: Launch cmd.exe in OOBE


```powershell
start powershell
Set-ExecutionPolicy RemoteSigned
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
```


스토리지 점검
``` powershell
Get-Disk
Get-Volume

# DATA 볼륨 드라이브 문자 할당
Get-Partition -DiskNumber 1 | Set-Partition -NewDriveLetter D
```


기본적으로 사용할 optional feature를 미리 점검한다.


```powershell
Enable-WindowsOptionalFeature -Online -FeatureName "netfx3" -All -LimitAccess
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-All" -All
Get-WindowsOptionalFeature -Online
```


```powershell
iex (irm 'rebrand.ly/ajchemist-net-windows-bootstrap-master')
.\script\W4RH4WK\debloat-windows-10-bootstrap.ps1
```


- `rebrand.ly` 링크가 정상작동하지 않을 시, `bit.ly/ajchemist-net-windows-bootstrap-master` 이용


## Storage


### System Drive Configuration


```powershell
$GUID_EFI_SYSTEM_PARTITION = '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'


get-disk
$disk = get-disk 0
$disk `
    | Clear-Disk -RemoveData -Passthru `
    | Initialize-Disk -PartitionStyle GPT -PassThru `
    | New-Partition -GptType $GUID_EFI_SYSTEM_PARTITION -Size 200MB -DriveLetter S `
    | Format-Volume -FileSystem FAT32 -NewFileSystemLabel ESP -confirm:$false
$disk `
    | New-Partition -UseMaximumSize -DriveLetter W `
    | Format-Volume -FileSystem NTFS -NewFileSystemLabel WINNT -confirm:$false
```


### Data Drive Configuration


```powershell
get-disk
$disk = get-disk 1
$disk `
    | Clear-Disk -RemoveData -Passthru `
    | Initialize-Disk -PartitionStyle GPT -PassThru `
    | New-Partition -UseMaximumSize -AssignDriveLetter `
    | Format-Volume -FileSystem NTFS -NewFileSystemLabel DATA -confirm:$false
```


### diskpart


``` batchfile
diskpart
lis dis
sel dis 0
clean
convert gpt
cre par efi size=200
format quick fs=fat32 label=ESP
assign
cre par pri
format quick fs=ntfs label=WINNT
assign
list vol
exit
```


``` batchfile
diskpart
lis dis
sel dis 1
clean
convert gpt
cre par pri
format fs=ntfs quick label=DATA
assign letter=D
exit
```


## Deploy



``` powershell
New-PSDrive -Name Z -Root \\host\share -PSProvider FileSystem
pushd D:
Get-WIndowsImage -ImagePath winntx.wim
Expand-WindowsImage -ImagePath winntx.wim -Index 5 -ApplyPath W:
# Add-WindowsDriver -Path W: -Driver $env:TEMP\drivers -Recurse -ForceUnsigned
bcdboot W:\Windows /s S: /l ko-kr /f UEFI /v
```


``` batchfile
dism /get-wiminfo /wimfile:winntx.wim
dism /apply-image /imagefile:winntx.wim /index:5 /applydir:W:
```


## BitLocker


### Enable BitLocker on data drive


``` powershell
.\scripts\bitlocker-data-drive.ps1
```


`gpedit.msc`


`로컬 컴퓨터 정책\컴퓨터 구성\Windows 설정\스크립트\시작프로그램` 파워셀 스크립트 `unlock_bitlocker_data_drive.ps1` 등록


### Enable BitLocker on system drive


`gpedit.msc`


`로컬 컴퓨터 정책\컴퓨터 구성\관리 템플릿\Windows\BitLocker 드라이브 암호화\운영 체제 드라이브\시작 시 추가 인증 요구` -> 사용, 호환 TPM이 없는 BitLocker 허용 체크


``` powershell
$system_drive_pw = Read-Host "Password" -AsSecureString
Enable-BitLocker $env:SystemDrive -UsedSpaceOnly -PasswordProtector -Password $system_drive_pw
Add-BitLockerKeyProtector $env:SystemDrive -RecoveryPasswordProtector
```


## Scenario


### 1


1. [시스템 드라이브 구성](#system-drive-configuration)
2. [Deploy](#deploy)


## Others


- https://github.com/W4RH4WK/Debloat-Windows-10
- https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-onedrive.ps1
