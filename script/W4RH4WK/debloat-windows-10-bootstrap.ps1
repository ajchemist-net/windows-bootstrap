[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$ref = "5381fcb3d446932e8072ed6c579c7f53afc7406b"
$url = "https://codeload.github.com/W4RH4WK/Debloat-Windows-10/zip/$ref"
$fileName = Join-Path $env:TEMP "Debloat-Windows-10.zip"


Invoke-RestMethod $url -OutFile $fileName
Expand-Archive $fileName -DestinationPath $env:TEMP -Force


cd "$env:TEMP\Debloat-Windows-10-$ref"


iex ".\scripts\remove-onedrive.ps1"
iex ".\scripts\disable-windows-defender.ps1"
iex ".\scripts\optimize-windows-update.ps1"
# iex ".\scripts\remove-default-apps.ps1"
