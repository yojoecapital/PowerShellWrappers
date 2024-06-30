function Set-Aliases {
    process {
        Set-Alias -Name "mv" -Value "Move-ItemWrapper" -Option AllScope -Scope Global
        Set-Alias -Name "rm" -Value "Remove-ItemWrapper" -Option AllScope -Scope Global
        Set-Alias -Name "cp" -Value "Copy-ItemWrapper" -Option AllScope -Scope Global
    }
}