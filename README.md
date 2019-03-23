---
title: Windows Bootstrap
author: ajchemist
description: Windows Bootstrap
---


# Windows Bootstrap #


<!-- https://github.com/ajchemist-net/windows-bootstrap/archive/firstshot.zip -->


- `Shift-F10`: Launch cmd.exe in OOBE


```powershell
start powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
```


```powershell
iex (irm 'bit.ly/ajchemist-net-windows-bootstrap-master')
.\script\W4RH4WK\debloat-windows-10-bootstrap.ps1
```


## Storage


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
