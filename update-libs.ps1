
function Expand-ZIPFile($file, $destination)
{
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items())
  {
    $shell.Namespace($destination).copyhere($item)
  }
}

New-Item -ItemType Directory -Force -Path "$PSScriptRoot\temp\"

$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/libs/n64/latest/libmikmod.zip"
$output = "$PSScriptRoot\temp\libmikmod.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-ZIPFile –File $output –Destination “$PSScriptRoot\”


$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/libs/n64/latest/libmad.zip"
$output = "$PSScriptRoot\temp\libmad.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-ZIPFile –File $output –Destination “$PSScriptRoot\”


$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/libs/n64/latest/libyaml.zip"
$output = "$PSScriptRoot\temp\libyaml.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-ZIPFile –File $output –Destination “$PSScriptRoot\”


Remove-Item -LiteralPath "$PSScriptRoot\temp\" -Force -Recurse
