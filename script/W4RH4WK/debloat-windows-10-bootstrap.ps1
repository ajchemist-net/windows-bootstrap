[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$ref = "081e7a78560781b8f3579573fc5a8e4416cae85e"
$url = "https://codeload.github.com/W4RH4WK/Debloat-Windows-10/zip/$ref"
$fileName = Join-Path $env:TEMP "Debloat-Windows-10.zip"


Invoke-RestMethod $url -OutFile $fileName
Expand-Archive $fileName -DestinationPath $env:TEMP -Force


cd "$env:TEMP\Debloat-Windows-10-$ref"


iex ".\scripts\optimize-windows-update.ps1"
iex ".\scripts\remove-onedrive.ps1"
iex ".\scripts\remove-default-apps.ps1"
