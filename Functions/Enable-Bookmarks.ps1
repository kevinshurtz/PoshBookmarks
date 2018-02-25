function Enable-Bookmarks {
    Param(
        # Optional custom load/save location
        [Parameter(Mandatory = $false, Position = 0)]
        [String]
        $CustomLocation
    )
    
    # Add a bookmark to the the bookmark directory
    if ($PSBoundParameters.ContainsKey('CustomLocation')) {
        # Create single bookmark directory
        [BookmarkDirectory]::new($CustomLocation) | Out-Null
        $bookmarks = [BookmarkDirectory]::GetInstance()
        
        # Save bookmarks on exit - note: do not use $bookmarks in Action; it will not work
        $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
            [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory($CustomLocation)
            [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory($CustomLocation)
        }

        # Store the event subscriber ID for later removal
        $bookmarks.EventSubscriberId = $saveBookmarksEventSubscriber.Id
    }
    else {
        # Create single bookmark directory
        [BookmarkDirectory]::new() | Out-Null
        $bookmarks = [BookmarkDirectory]::GetInstance()

        # Save bookmarks on exit - note: do not use $bookmarks in Action; it will not work
        $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
            [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory()
            [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory()
        }

        # Store the event subscriber ID for later removal
        $bookmarks.EventSubscriberId = $saveBookmarksEventSubscriber.Id
    }
}
