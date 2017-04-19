﻿$packageChecksum            = '925A23BDB5E1ED93885AB54DFD66CCC8FFAF4AFC02CD939C95BCDE57FAE629E7E977B7D0383B27F266E17E1C33436FD91BF416B68DBFFA0C28BF39FEC21D05CC93D5F0AFED372F17602ECF87536C218942032A9A9679C77841A3F189827DCB93EF8C3303376C608FBA2DEE931735C0D43A15F75A90F6EB0644529F528EBC40C1'
$defaultConfigurationFile   = Join-Path (Get-ParentDirectory $script) 'Configuration.ini'
$packageName                = 'MSSQLServer2014Express'
$installer                  = Join-Path (Get-ParentDirectory $script) 'SQLEXPR.exe'
$parameters                 = Get-Parameters $env:chocolateyPackageParameters
$configurationFile          = Get-ConfigurationFile $parameters['ConfigurationFile'] $defaultConfigurationFile
$silentArgs                 = "/IAcceptSQLServerLicenseTerms /ConfigurationFile=""$($configurationFile)"""
$os                         = if (IsSystem32Bit) { "x86" } else { "x64" }

if (!$parameters.ContainsKey['sqlsysadminaccounts']) {
    $silentArgs = $silentArgs + " /SQLSYSADMINACCOUNTS=""$(whoami)"""
}

$arguments          = @{
    file            = "SQLEXPR_$os_ENU.exe"
    url             = "https://download.microsoft.com/download/2/A/5/2A5260C3-4143-47D8-9823-E91BB0121F94/SQLEXPR_x86_ENU.exe"
    url64           = "https://download.microsoft.com/download/2/A/5/2A5260C3-4143-47D8-9823-E91BB0121F94/SQLEXPR_x64_ENU.exe"
    checksum        = '0eff1354916410437c829e98989e5910d9605b2df31977bc33ca492405a0a9ab'
    checksum64      = 'cc35e94030a24093a62e333e900c2e3c8f1eb253a5d73230a9f5527f1046825b'
    silentArgs      = "/Q /x:`"$env:Temp\MSSQLServer2014Express\SQLEXPR`""
    validExitCodes  = @(2147781575, 2147205120)
}

$installerPath = Get-Installer $parameters
$userInstallerPath = $parameters['installer']

if (!([System.IO.File]::Exists($installerPath))) {
    # Download and run the pre-installer
    Install-ChocolateyPackage @arguments

    # Set the path to the extracted setup
    $arguments['file'] = "$env:Temp\$packageName\SQLEXPR\Setup.exe"
}
elseif (([System.IO.File]::Exists($userInstallerPath))) {
    # Installer was specified and it exists

    # Run the pre-installer
    $arguments['file'] = $userInstallerPath
    Install-ChocolateyInstallPackage @arguments

    # Set the path to the extracted setup
    $arguments['file'] = "$env:Temp\$packageName\SQLEXPR\Setup.exe"
}

# Run the extracted setup
$arguments['packageName'] = $packageName
$arguments['silentArgs'] = $silentArgs

Install-Package $arguments

if (Test-Path "$env:Temp\$packageName") {
    Remove-Item -Recurse "$env:Temp\$packageName"
}