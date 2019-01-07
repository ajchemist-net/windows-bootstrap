---
title: Windows Bootstrap
author: ajchemist
description: Windows Bootstrap
---


# Windows Bootstrap #


<!-- https://github.com/ajchemist-net/windows-bootstrap/archive/firstshot.zip -->


```powershell
start powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$uri = "https://github.com/ajchemist-net/windows-bootstrap/archive/master.zip"
$target = "${env:TMPDIR}\windows-bootstrap"
wget $uri -UseBasicParsing -OutFile "$target.zip"
Expand-Archive "$target.zip" -DestinationPath $target
```
