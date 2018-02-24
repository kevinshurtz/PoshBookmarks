function Add-Bookmark {
    Param(
        # The name of the bookmark to add
        [Parameter(Mandatory = $true, Position = 1)]
        [String]
        $Name,

        # The path of the target location
        [Parameter(Mandatory = $true, Position = 2)]
        [String]
        $Path
    )

    $bookmarks = [BookmarkDirectory]::GetInstance()
    $location = Get-Item -Path $Path
    $bookmarks.Bookmarks.Add($Name, $location)
}
