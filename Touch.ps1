function Touch {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [string[]]$path
    )
    
    process {
        foreach ($item in $path) {
            if (Test-Path $path -PathType 'Leaf') 
            {
                (Get-Item $path).LastWriteTime = Get-Date
            } 
            else 
            {
                if (Test-Path $path -PathType 'Container')
                {
                    throw "Access to the path '$path' is denied."
                }
                else
                {
                    if ($args.Contains(("Confirm")))
                    {
                        New-Item -Path $path -ItemType 'File' -Confirm
                    }
                    else
                    {
                        New-Item -Path $path -ItemType 'File'
                    }
                }
            }
        }
    }
}