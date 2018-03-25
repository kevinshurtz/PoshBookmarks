function Enable-Bookmarks {
    Param(
        # Optional custom load/save location
        [Parameter(Mandatory = $false, Position = 0)]
        [String]
        $CustomLocation
    )

    # Create single bookmark directory
    $bookmarks = [BookmarkDirectory]::GetInstance()

    # Add a bookmark to the the bookmark directory
    if ($PSBoundParameters.ContainsKey('CustomLocation')) {
        # Save bookmarks on exit - note: do not use $bookmarks in Action; it will not work
        $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
            [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory($CustomLocation)
            [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory($CustomLocation)
        }
    }
    else {
        # Save bookmarks on exit - note: do not use $bookmarks in Action; it will not work
        $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
            [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory()
            [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory()
        }
    }

    # Store the event subscriber ID for later removal
    $bookmarks.EventSubscriberId = $saveBookmarksEventSubscriber.Id
}
