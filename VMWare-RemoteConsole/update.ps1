param([switch] $force, [switch] $push)

$packageDir = $PSScriptRoot

. (Join-Path $PSScriptRoot '..\Scripts\update.onchange.begin.ps1')

function global:au_GetLatest {
    $fileName32 = 'VMware-VMRC-9.0.0-4288332.msi'
    $version = '9.0'

    if ($force) {
        $global:au_Version = $version
    }

    return @{ Version = $version; FileName32 = $fileName32; }
}

function global:au_SearchReplace {
    return @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

. (Join-Path $PSScriptRoot '..\Scripts\update.end.ps1')