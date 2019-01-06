---
title: Windows Bootstrap
author: ajchemist
description: Windows Bootstrap
---


# Windows Bootstrap #


```powershell
start powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
wget https://gitlab.com/api/v4/projects/10227287/repository/files/README.md/raw?ref=master -Headers @{ "PRIVATE-TOKEN" = "6qKeJzbhPzBa7xqr6GN6" } -UseBasicParsing
```
