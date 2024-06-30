. "$PSScriptRoot\Helpers.ps1"

function Move-ItemWrapper {
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
            $count = $operations.leaf.Count + $operations.container.Count
            $display = $operations.leaf + $operations.container | Out-String
            if (
                ($count -gt 0) -and 
                ($PSCmdlet.ShouldProcess(
                    "$count item(s)`":`n$display`"Files: $($operations.leaf.Count), Directories: $($operations.container.Count)", 
                    "Move Items"
                ))
            ) {

            }
        }
        catch 
        {
            Write-Error $_.Exception.Message
        }
    }
}