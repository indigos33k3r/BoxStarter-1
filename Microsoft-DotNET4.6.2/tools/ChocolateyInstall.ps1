﻿$arguments = @{
    url        = 'https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe'
    checksum   = '28886593E3B32F018241A4C0B745E564526DBB3295CB2635944E3A393F4278D4'
    silentArgs = "/q /NoRestart /Log ""${Env:TEMP}\${packageName}.log"""
}

Install-Package $arguments
