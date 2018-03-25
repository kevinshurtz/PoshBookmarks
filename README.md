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
| `Use-Bookmark`             | Navigates to the directory associated with a given string               |
| `Import-Bookmark`          | Import a bookmarks from an XML file created by a Bookmark Directory     |
| `Export-Bookmark`          | Export bookmarks to an XML file from the active Bookmark Directory      |
| `Get-LastSessionDirectory` | Gets the last directory from the last closed PowerShell session         |

## Aliases
| Alias  | Command                    |
|--------|----------------------------|
| `gbm`  | `Get-Bookmark`             |
| `abm`  | `Add-Bookmark`             |
| `sbm`  | `Set-Bookmark`             |
| `rbm`  | `Remove-Bookmark`          |
| `ubm`  | `Use-Bookmark`             |
| `ipbm` | `Import-Bookmark`          |
| `epbm` | `Export-Bookmark`          |
| `glsd` | `Get-LastSessionDirectory` |

## Notes
While help for the modules functions has improved, it is still incomplete.  Currently, only
`Add-Bookmark`, `Get-Bookmark`, and `Use-Bookmark` have fleshed-out help files, and even those
files are imperfect.  In time, however, all functions will be given their own help files, and the
existing files should improve.  

Additionally, the module currently has no tests.  Hopefully, I will add Pester tests when time 
avails itself.  

## Simple Examples
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
Kevin> # Navigating directly to a bookmark with 'use-bookmark'
Kevin> add-bookmark 'goog' 'c:\users\kevin\google drive\'
Kevin> use-bookmark goog
google drive>
```
```
Kevin> # Using the 'ubm' alias
Kevin> abm 'goog' 'C:\Users\Kevin\Google Drive\'
Kevin> ubm goog
Google Drive>
```
```
Kevin> # Removing a bookmark
Kevin> Remove-Bookmark 'goog' 'C:\Users\Kevin\Google Drive\'
```
```
Kevin> # Removing a bookmark with aliases
Kevin> rbm 'goog' 'C:\Users\Kevin\Google Drive\'
```


