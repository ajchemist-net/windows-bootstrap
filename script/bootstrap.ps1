[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$uri = "https://codeload.github.com/ajchemist-net/windows-bootstrap/zip/master"
$target = Join-Path $env:TEMP "windows-bootstrap.zip"
Invoke-RestMethod $uri -OutFile $target
Expand-Archive $target -DestinationPath $env:TEMP -Force
cd "$env:TEMP\windows-bootstrap-master"


iex ".\script\core.ps1"
