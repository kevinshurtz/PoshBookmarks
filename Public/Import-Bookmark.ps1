function Import-Bookmark {
    Param(
        # The path of the target location
        [Parameter(Mandatory = $false, Position = 1)]
        [String]
        $Path
    )

    # Create new BookmarkDirectory if a $Path is given, otherwise use the default path
    if ($PSBoundParameters.ContainsKey('Path')) {
        $bookmarks = [BookmarkDirectory]::GetInstance($Path)
    }
    else {
        $bookmarks = [BookmarkDirectory]::GetInstance()
    }
}
