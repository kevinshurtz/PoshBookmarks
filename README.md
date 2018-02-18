# Bookmark Module
This module was created to make navigation around the filesystem easier
in PowerShell. The bookmark module keeps a list of short names to 
locations in the filesystem. They can be added, removed, and updated
like any other resource.  When the user closes a PowerShell session, his/her 
bookmarks are saved for the next session.

The module also stores the "last session directory", which can be retrieved at 
any time.

## Commands
| Command                    | Definition                                                              |
|----------------------------|-------------------------------------------------------------------------|
| `Get-Bookmark`             | Gets a single directory if given a string, or the list of all bookmarks |
| `Add-Bookmark`             | Associates a string with a directory                                    |
| `Set-Bookmark`             | Sets a new directory for a bookmark string                              |
| `Remove-Bookmark`          | Disassociates a string from a directory                                 |
| `Get-LastSessionDirectory` | Gets the last directory from the last closed PowerShell session         |
| `Enable-Bookmarks`         | Loads previous bookmarks, saves bookmarks on exit                       |
| `Disable-Bookmarks`        | Disables "save on exit" functionality                                   |

## Aliases
| Alias  | Command                    |
|--------|----------------------------|
| `gbm`  | `Get-Bookmark`             |
| `abm`  | `Get-Bookmark`             |
| `sbm`  | `Get-Bookmark`             |
| `rbm`  | `Get-Bookmark`             |
| `glsd` | `Get-LastSessionDirectory` |

## Notes
This is a very early version of the module.  Currently, `Enable-Bookmarks` and 
`Disable-Bookmarks` don't really work as the user would naturally expect. 
Future versions will ensure that the other functions do not perform any 
operations unless the functionality truly has been "enabled".  

Nonetheless, to properly use the module, simply install it and add
`Enable-Bookmarks` to your `profile.ps1` file.  

Additionally, there is some underlying support for specifying multiple 
"bookmark directories", such that users can share bookmarks with each other. 
Again, this has not yet been implemented, but may be in the future.  

Lastly, help and documentation is currently spotty to non-existant. 
This will be an item of future attention.  

## Examples
```
Kevin> # Adding and using a bookmark
Kevin> Add-Bookmark 'goog' 'C:\Users\Kevin\Google Drive\'
Kevin> Set-Location (Get-Bookmark goog)
Google Drive>
```
```
Kevin> # Adding and using a bookmark with aliases
Kevin> abm 'goog' 'C:\Users\Kevin\Google Drive\'
Kevin> sl (gbm goog) # Alternatively: gbm goog | sl
Google Drive>
```
```
Kevin> # Removing a bookmark
Kevin> Remove-Bookmark 'goog' 'C:\Users\Kevin\Google Drive\'
```
```
Kevin> # Removing a bookmark with aliases
Kevin> Remove-Bookmark 'goog' 'C:\Users\Kevin\Google Drive\'
```


