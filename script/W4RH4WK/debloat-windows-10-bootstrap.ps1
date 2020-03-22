[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$ref = "ae78e9c8547c65cff314348b78e3066e7cd5b150"
$url = "https://codeload.github.com/W4RH4WK/Debloat-Windows-10/zip/$ref"
$fileName = Join-Path $env:TEMP "Debloat-Windows-10.zip"


Invoke-RestMethod $url -OutFile $fileName
Expand-Archive $fileName -DestinationPath $env:TEMP -Force


cd "$env:TEMP\Debloat-Windows-10-$ref"


iex ".\scripts\optimize-windows-update.ps1"
iex ".\scripts\remove-onedrive.ps1"
iex ".\scripts\remove-default-apps.ps1"
