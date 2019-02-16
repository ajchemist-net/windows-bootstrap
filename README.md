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
$uri = "https://github.com/ajchemist-net/windows-bootstrap/archive/master.zip"
$target = "${env:TMPDIR}\windows-bootstrap"
wget $uri -UseBasicParsing -OutFile "$target.zip"
Expand-Archive "$target.zip" -DestinationPath $target
cd $target\windows-bootstrap-master
.\scripts\system_bootstrap.ps1
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
