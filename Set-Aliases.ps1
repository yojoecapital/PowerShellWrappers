function Set-Aliases {
    process {
        Remove-Item -Path Alias:"rm" -ErrorAction SilentlyContinue
        Remove-Item -Path Alias:"mv" -ErrorAction SilentlyContinue
        Remove-Item -Path Alias:"cp" -ErrorAction SilentlyContinue
        New-Alias -Name "mv" -Value "Move-ItemWrapper" -Option AllScope -Scope Global
        New-Alias -Name "rm" -Value "Remove-ItemWrapper" -Option AllScope -Scope Global
    }
}