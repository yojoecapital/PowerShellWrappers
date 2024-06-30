function Reset-Aliases {
    process {
        Set-Alias -Name "mv" -Value "Move-Item" -Option AllScope -Scope Global
        Set-Alias -Name "rm" -Value "Remove-Item" -Option AllScope -Scope Global
        Set-Alias -Name "cp" -Value "Copy-Item" -Option AllScope -Scope Global
    }
}