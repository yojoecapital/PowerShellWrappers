$files = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1

foreach ($file in $files) {
    . "$($file.FullName)"
}

# Export all functions defined in the module
$functions = Get-Command -CommandType Function | Where-Object { $_.ScriptBlock.File -in $files.FullName }
foreach ($function in $functions) {
    Export-ModuleMember -Function $function.Name
}