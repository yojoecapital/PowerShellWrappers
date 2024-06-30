. "$PSScriptRoot\Helpers.ps1"

function Copy-ItemWrapper {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [String[]]$path,

        [Parameter(Mandatory = $true, Position = 1)]
        [String]$destination,

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
                destination = $destination
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
            $operations = PairOperations @params
            $allOperations = $operations.leaf + $operations.container
            $display = $allOperations | Out-String
            if (
                ($allOperations.Count -gt 0) -and 
                ($PSCmdlet.ShouldProcess(
                    "$($allOperations.Count) item(s)`":`n$display`"Files: $($operations.leaf.Count), Directories: $($operations.container.Count)", 
                    "Copy Items"
                ))
            ) {
                $argItems = $allOperations | ForEach-Object {
                    return "`"$($_.Source)`" `"$($_.Destination)`""
                }
                $argsString = $argItems -join " "
                Invoke-Expression ". `"$PSScriptRoot\engine.exe`" `"COPY`" $argsString"
            }
        }
        catch 
        {
            Write-Error $_.Exception.Message
        }
    }
}