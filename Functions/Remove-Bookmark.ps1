function Remove-Bookmark {
    Param(
        # The name of the bookmark to remove
        [Parameter(Mandatory=$true, Position=1)]
        [String]
        $Name
    )

    $bookmarks = [BookmarkDirectory]::GetInstance()
    $bookmarks.Bookmarks.Remove($Name) | Out-Null
}
