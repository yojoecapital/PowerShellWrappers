. "$PSScriptRoot\Helpers.ps1"

function Remove-ItemWrapper {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [String[]]$path,

        [Parameter(Mandatory = $false)]
        [String[]]$include,
        
        [Parameter(Mandatory = $false)]
        [String[]]$exclude,

        [Parameter(Mandatory = $false)]
        [String]$filter,

        [Parameter(Mandatory = $false)]
        [switch]$recurse,

        [Parameter(Mandatory = $false)]
        [UInt32]$depth,

        [Parameter(Mandatory = $false)]
        [switch]$force,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('PSPath', 'LP')]
        [string[]]$literalPath
    )

    process {
        try 
        {
            $params = @{
                path = $path
                include = $include
                exclude = $exclude
                filter = $filter
                recurse = $recurse
                force = $force
            }
            if ($literalPath)
            {
                $params.Add('literalPath', $literalPath)
            }
            if ($depth)
            {
                $params.Add('depth', $depth)
            }
            if ($force)
            {
                Remove-Item @params
                return
            }
            $operations = SingleOperations @params
            $allOperations = $operations.leaf + $operations.container
            $display = $allOperations | Out-String
            if (
                ($allOperations.Count -gt 0) -and 
                ($PSCmdlet.ShouldProcess(
                    "$($allOperations.Count) item(s)`":`n$display`"Files: $($operations.leaf.Count), Directories: $($operations.container.Count)", 
                    "Recycle Items"
                ))
            ) {
                $argItems = $allOperations | ForEach-Object {
                    return "`"$_`""
                }
                $argsString = $argItems -join " "
                Invoke-Expression ". `"$PSScriptRoot\engine.exe`" `"DELETE`" $argsString"
            }
        }
        catch 
        {
            Write-Error $_.Exception.Message
        }
    }
}