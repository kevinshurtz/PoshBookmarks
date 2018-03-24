function Export-Bookmark {
    Param(
        # The path of the target location
        [Parameter(Mandatory = $false, Position = 1)]
        [String]
        $Path
    )

    $bookmarks = [BookmarkDirectory]::GetInstance()

    # Save BookmarkDirectory configuration file
    if ($PSBoundParameters.ContainsKey('Path')) {
        $bookmarks.SaveBookmarkDirectory($Path)
    }
    else {
        $bookmarks.SaveBookmarkDirectory((Get-Location).Path)
    }
}
