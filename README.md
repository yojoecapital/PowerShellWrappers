# PowerShell Wrappers Module

## Overview

This repository contains a PowerShell module that provides wrapper functions for common file operations: `Remove-Item`, `Move-Item`, and `Copy-Item`. These wrappers utilize a C# program (a .NET Console App) that employs the `SHFileOperation` function to interact with the Windows API, ensuring that file operations are undoable through File Explorer and that `Remove-Item` uses the recycling bin.

## Installation

Check the releases for the build.
### Optional: Add Module Import to PowerShell Profile

To automatically import the module whenever you start PowerShell, add the import command to your PowerShell profile.

1. Open your PowerShell profile script:
   ```powershell
   notepad $PROFILE
   ```

2. Add the following line to the profile script:
   ```powershell
   Import-Module "path\to\PowerShellWrappers.psm1"
   ```

3. Save and close the profile script.

## Usage

### `Copy-ItemWrapper`

Use this function to copy files or directories:
```powershell
Copy-ItemWrapper -Path "source" -Destination "destination"
```

### `Move-ItemWrapper`

Use this function to move files or directories:
```powershell
Move-ItemWrapper -Path "source" -Destination "destination"
```

### `Remove-ItemWrapper`

Use this function to remove files or directories, sending them to the recycling bin:
```powershell
Remove-ItemWrapper -Path "target"
```

### `Aliases`

Set aliases for the wrapper functions. These include `cp`, `mv`, and `rm`:
```powershell
Set-Aliases
```

Reset aliases to their original state:
```powershell
Reset-Aliases
```
