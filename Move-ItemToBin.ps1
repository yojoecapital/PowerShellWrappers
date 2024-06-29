function Move-ItemToBin {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [String[]]$Path,

        [Parameter(Mandatory = $false)]
        [String[]]$Exclude,

        [Parameter(Mandatory = $false)]
        [String[]]$Include,

        [Parameter(Mandatory = $false)]
        [String]$Filter
    )

    process {
        $params = @{
            Path = $Path
            Exclude = $Exclude
            Include = $Include
            Filter = $Filter
        }
        try 
        {
            $items = Get-Item @params -ErrorAction "Stop"
            $shell = New-Object -ComObject Shell.Application
            foreach ($item in $items) {
                if (Test-Path $item.ResolvedTarget -PathType "Container")
                {
                    $operation = "Recycle Directory"
                }
                else
                {
                    if  (Test-Path $item.ResolvedTarget -PathType "Leaf")
                    {
                        $operation = "Recycle File"
                    }
                    else
                    {
                        throw "Cannot find path '$($item.ResolvedTarget)' because it does not exist."
                    }
                }
                if ($PSCmdlet.ShouldProcess($item, $operation))
                {
                    $shellItem = $shell.NameSpace(0).ParseName($item.ResolvedTarget)
                    $shellItem.InvokeVerb("delete")
                    Write-Verbose "Performing the operation `"$operation`" on target `"$($item.ResolvedTarget)`"."
                }
            }   
        }
        catch 
        {
            Write-Error $_.Exception.Message
        }
    }
}