function Get-Config {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)][string] $configFile,
        [Parameter(Position = 1, Mandatory = $false)][string] $environment = '',
        [Parameter(Position = 2)][string] $baseDir = (Split-Path -Parent $configFile)
    )

    $config = Get-Content $configFile | ConvertFrom-Json
    $configFileDir = Split-Path -Path $configFile
    $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile)
    $configFileExt = [System.IO.Path]::GetExtension($configFile)
    $envConfigFileString = '$configFileDir\$configFileName.$environment$configFileExt'

    # If the environment is specifiefd
    if ($environment) {
        # Construct the name of the environment file and read it
        $envConfigFile = $ExecutionContext.InvokeCommand.ExpandString($envConfigFileString)
        $envConfig = Get-Content $envConfigFile | ConvertFrom-Json

        # For each property you find in the environment file,
        # replace the property in the base configuration
        $envConfig | ForEach-Object { ($_ | Get-Member -MemberType *Property).Name } | `
            ForEach-Object {
            $config.$_ = $envConfig.$_
        }
    }

    # Process all properties ending with "Path" and if they are not rooted
    # Resolve them based on the baseDir
    $config | ForEach-Object { ($_ | Get-Member -MemberType *Property).Name } | Where-Object { $_ -match 'Path' } | `
        ForEach-Object {
        if (-not [System.IO.Path]::IsPathRooted($config.$_)) {
            $config.$_ = Join-Path $baseDir $config.$_
        }
    }

    return $config
}