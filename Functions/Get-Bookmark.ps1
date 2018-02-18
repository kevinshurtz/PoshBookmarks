function Get-Bookmark {
    Param(
        # The name of the bookmark to return
        [Parameter(Mandatory=$false, Position=1)]
        [String]
        $Name
    )

    $bookmarks = [BookmarkDirectory]::GetInstance()

    # Return either the set of all bookmarks, or an individual bookmark
    if ($PSBoundParameters.ContainsKey('Name')) {
        return $bookmarks.Bookmarks[$Name]
    }
    else {
        return $bookmarks.Bookmarks
    }
}
