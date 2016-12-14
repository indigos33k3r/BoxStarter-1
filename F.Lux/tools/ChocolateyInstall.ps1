$script           = $MyInvocation.MyCommand.Definition
$packageArgs      = @{
  packageName     = 'F.Lux'
  unzipLocation   = (Get-CurrentDirectory $script)
  fileType        = 'exe'
  file            = Join-Path (Get-ParentDirectory $script) 'flux-setup.exe'
  url             = 'http://stereopsis.com/flux/flux-setup.exe'
  softwareName    = 'Dropbox*'
  checksum        = '2696C35394CA9125098458FC080461B6C841D6D8FD263B40270D21A8823C65B0'
  checksumType    = 'sha256'
  silentArgs      = '/S'
  validExitCodes  = @(0, 3010, 1641)
}

Install-LocalOrRemote $packageArgs

Start-Sleep -s 5

if (Get-Process -Name MicrosoftEdge) {
  Stop-Process -processname MicrosoftEdge
}

if (Get-Process -Name flux) {
  Stop-Process -processname flux
}