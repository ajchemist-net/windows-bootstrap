[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$ref = "master"
$uri = "https://codeload.github.com/ajchemist-net/windows-bootstrap/zip/$ref"
$target = Join-Path $env:TEMP "windows-bootstrap.zip"
Invoke-RestMethod $uri -OutFile $target
Expand-Archive $target -DestinationPath $env:TEMP -Force
cd "$env:TEMP\windows-bootstrap-$ref"


iex ".\script\core.ps1"
