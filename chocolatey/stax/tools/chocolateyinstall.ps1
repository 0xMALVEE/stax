﻿$toolsDir = "$( Split-Path -parent $MyInvocation.MyCommand.Definition )"

$repoZipFile = "$toolsDir\repo.zip"
Get-ChocolateyWebFile -PackageName 'stax' -FileFullPath $repoZipFile -Url 'https://github.com/TarasMazepa/stax/archive/master.zip'
Get-ChocolateyUnzip -FileFullPath $repoZipFile -Destination $toolsDir

& dart pub --directory="$toolsDir\stax-main\cli" get
& dart compile exe "$toolsDir\stax-main\cli\bin\cli.dart" -o "$toolsDir\stax.exe"

Install-BinFile -Name stax -Path "$toolsDir\stax.exe"
