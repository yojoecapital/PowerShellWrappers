function ProcessDestination {
    param (
        [String]$source,

        [String]$destination,

        [ValidateSet('Leaf', 'Container')]
        [String]$sourceType
    )
    
    process {
        # Process the source
        $base = $name = [System.IO.Path]::GetFileName($source)
        $index = $source.LastIndexOf('.')
        if ($index -gt -1)
        {
            $extension = $source.Substring($index)
            $base = $source.Substring(0, $index)
        }
        
        # Process each part in the destination
        $separator = [System.IO.Path]::DirectorySeparatorChar
        $parts = $destination -split [regex]::Escape($separator)
        $processedParts = [string[]]$parts | ForEach-Object {
            $part = $_.Replace('*.*', $name).Replace('*.', $base + '.').Replace('.*', $extension).Replace('*', $name)
            return $part
        }
        $destination = [System.IO.Path]::Combine([string[]]$processedParts)

        # Test the destination
        if (-not (Test-Path $destination -IsValid))
        {
            throw "Destination '$destination' is not valid."
        }
        if ((Test-Path $destination -PathType 'Container') -and ($sourceType -eq 'Leaf'))
        {
            throw "Path '$source' is a leaf while destintion '$destination' is a container."
        }
        if ((Test-Path $destination -PathType 'Leaf') -and ($sourceType -eq 'Container'))
        {
            throw "Path '$source' is a container while destintion '$destination' is a leaf."
        }
        return $destination
    }
}

function NormalizePath {
    param (
        [String]$path
    )
    
    process {
        $seperator = [System.IO.Path]::DirectorySeparatorChar
        $wd = (Get-Location).Path
        if (-not [System.IO.Path]::IsPathRooted($path))
        {
            $path = Join-Path $wd $path
        }
        $path = [System.IO.Path]::GetRelativePath($wd, $path)
        if ($path.EndsWith($seperator))
        {
            $path = $path.Substring(0, $path.Length - 1)
        }
        return $path
    }
}

function PairOperations {
    [CmdletBinding()]
    param (
        [String[]]$path,

        [String]$destination,

        [String[]]$include,
        
        [String[]]$exclude,

        [String]$filter,

        [switch]$recurse,

        [UInt32]$depth,

        [switch]$force,

        [string[]]$literalPath
    )

    process {
        $params = @{
            Include = $include
            Exclude = $exclude
            Filter = $filter
            Force = $force
            ErrorAction = 'Stop'
        }
        if ($literalPath)
        {
            $params.Add('LiteralPath', $literalPath)
        }
        $seperator = [System.IO.Path]::DirectorySeparatorChar
        $destination = NormalizePath $destination
        $items = Get-Item @params -Path $path 
        $params.Add('Recurse', $recurse)
        $params.Add('File', $true)
        if ($depth)
        {
            $params.Add('Depth', $depth)
        }
        $leafOperations = @()
        $containerOperations = @()
        foreach ($item in $items)
        {
            $item = NormalizePath $item.FullName
            if (Test-Path $item -PathType 'Container')
            {
                if ($filter -or $include -or $exclude)
                {
                    # A directory with filtering
                    $nestedItems = Get-ChildItem @params -Path $item
                    foreach ($nestedItem in $nestedItems)
                    {
                        $join = $nestedItem.Name
                        $nestedItem = NormalizePath $nestedItem.FullName
                        $finish = ProcessDestination $item $destination -sourceType 'Container'
                        $leafOperations += [PSCustomObject]@{
                            Source = $nestedItem
                            Destination = (Join-Path $finish $join)
                        }
                    }
                }
                else
                {
                    # A directory
                    $finish = ProcessDestination $item $destination -sourceType 'Container'
                    $containerOperations += [PSCustomObject]@{
                        Source = $item + $seperator
                        Destination = $finish + $seperator
                    }
                }
            }
            else
            {
                if (Test-Path $item -PathType 'Leaf')
                {
                    # A leaf
                    $finish = ProcessDestination $item $destination -sourceType 'Leaf'
                    $leafOperations += [PSCustomObject]@{
                        Source = $item
                        Destination = $finish
                    }
                }
                else
                {
                    throw "Cannot find path '$item' because it does not exist."
                }
            }
        }
        return [PSCustomObject]@{
            leaf = $leafOperations
            container = $containerOperations
        }
    }
}

function SingleOperations {
    [CmdletBinding()]
    param (
        [String[]]$path,

        [String[]]$include,
        
        [String[]]$exclude,

        [String]$filter,

        [switch]$recurse,

        [UInt32]$depth,

        [switch]$force,

        [string[]]$literalPath
    )

    process {
        $params = @{
            Include = $include
            Exclude = $exclude
            Filter = $filter
            Force = $force
            ErrorAction = 'Stop'
        }
        if ($literalPath)
        {
            $params.Add('LiteralPath', $literalPath)
        }
        $seperator = [System.IO.Path]::DirectorySeparatorChar
        $items = Get-Item @params -Path $path 
        $params.Add('Recurse', $recurse)
        $params.Add('File', $true)
        if ($depth)
        {
            $params.Add('Depth', $depth)
        }
        $leafOperations = @()
        $containerOperations = @()
        foreach ($item in $items)
        {
            $item = NormalizePath $item.FullName
            if (Test-Path $item -PathType 'Container')
            {
                if ($filter -or $include -or $exclude)
                {
                    # A directory with filtering
                    $nestedItems = Get-ChildItem @params -Path $item
                    foreach ($nestedItem in $nestedItems)
                    {
                        $nestedItem = NormalizePath $nestedItem.FullName
                        $leafOperations += $nestedItem
                    }
                }
                else
                {
                    # A directory
                    $containerOperations += ($item + $seperator)
                }
            }
            else
            {
                if (Test-Path $item -PathType 'Leaf')
                {
                    # A leaf
                    $leafOperations += $item
                }
                else
                {
                    throw "Cannot find path '$item' because it does not exist."
                }
            }
        }
        return [PSCustomObject]@{
            leaf = $leafOperations
            container = $containerOperations
        }
    }
}