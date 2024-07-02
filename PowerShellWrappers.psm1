$files = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1

foreach ($file in $files) {
    . "$($file.FullName)"
}

Export-ModuleMember 'Remove-ItemWrapper'
Export-ModuleMember 'Move-ItemWrapper'
Export-ModuleMember 'Copy-ItemWrapper'
Export-ModuleMember 'Set-Aliases'
Export-ModuleMember 'Reset-Aliases'