<#
.SYNOPSIS
Adds a bookmark to the active Bookmark Directory.

.DESCRIPTION
The Bookmark Directory contains a user-managed Dictionary of short names and directories for quicker navigation throughout the filesystem.  The Add-Bookmark function adds a name and directory object to the active Bookmark Directory.  

.PARAMETER Name
The short name to be mapped to an associated directory.

.PARAMETER Path
The path to the directory being bookmarked for quick access.

.EXAMPLE
PS C:\> Add-Bookmark -Name docs -Path 'C:\Users\ExampleUser\Documents'

.EXAMPLE
PS C:\> Add-Bookmark docs 'C:\Users\ExampleUser\Documents'

.EXAMPLE
PS C:\> abm docs 'C:\Users\ExampleUser\Documents'
#>
function Add-Bookmark {
    Param(
        # The name of the bookmark to add
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $Name,

        # The path of the target location
        [Parameter(Mandatory = $true, Position = 1)]
        [String]
        $Path
    )

    $bookmarks = [BookmarkDirectory]::GetInstance()
    $location = Get-Item -Path $Path
    $bookmarks.Bookmarks.Add($Name, $location)
}
