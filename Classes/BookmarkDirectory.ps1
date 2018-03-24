# Create singleon bookmark directory class
Class BookmarkDirectory {
    [System.Collections.Generic.Dictionary[String, System.IO.DirectoryInfo]] $Bookmarks;
    [System.IO.DirectoryInfo] $LastSessionDirectory;

    [Int32] $eventSubscriberId;
    [DateTime] $saveLocationLastUpdate;
    
    static [String] $defaultSaveLocation = "$env:HOMEPATH\Documents\WindowsPowerShell\SessionData\SessionBookmarks.clixml";
    static [BookmarkDirectory] $singleBookmarkDir;
    
    # Load bookmark data from default location, unless othewise specified
    BookmarkDirectory([String] $path) {
        $this.Bookmarks = [System.Collections.Generic.Dictionary[String, System.IO.DirectoryInfo]]::new()
        $this.LoadBookmarkDirectory($path);
    }

    # Default constructor without loading preferable when using Import-Clixml
    BookmarkDirectory() {
        $this.Bookmarks = [System.Collections.Generic.Dictionary[String, System.IO.DirectoryInfo]]::new()
    }

    static [BookmarkDirectory] GetInstance() {
        if ([BookmarkDirectory]::singleBookmarkDir -eq $null) {
            [BookmarkDirectory]::singleBookmarkDir = [BookmarkDirectory]::new([BookmarkDirectory]::defaultSaveLocation);

            # Save bookmarks on exit
            $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
                [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory((Get-Location).Path);
                [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory([BookmarkDirectory]::defaultSaveLocation);
            }

            # Save event subscriber ID for potential later deregistration
            $[BookmarkDirectory]::singleBookmarkDir.eventSubscriberId = $saveBookmarksEventSubscriber.Id;
        }

        return [BookmarkDirectory]::singleBookmarkDir;
    }

    static [BookmarkDirectory] GetCustomInstance([String] $customLocation) {
        if ([BookmarkDirectory]::singleBookmarkDir -eq $null) {
            [BookmarkDirectory]::singleBookmarkDir = [BookmarkDirectory]::new($customLocation);

            # Save bookmarks on exit
            $saveBookmarksEventSubscriber = Register-EngineEvent PowerShell.Exiting -Action {
                [BookmarkDirectory]::GetInstance().UpdateLastSessionDirectory((Get-Location).Path);
                [BookmarkDirectory]::GetInstance().SaveBookmarkDirectory($customLocation);
            }

            # Save event subscriber ID for potential later deregistration
            $[BookmarkDirectory]::singleBookmarkDir.eventSubscriberId = $saveBookmarksEventSubscriber.Id;
        }

        return [BookmarkDirectory]::singleBookmarkDir;
    }

    # Update the "last session directory" property, typically invoked before exit
    [void] UpdateLastSessionDirectory([String] $path) {
        $this.LastSessionDirectory = $path;
    }

    # Write bookmark data to disk, typically invoked before exit
    [void] SaveBookmarkDirectory([String] $path) {
        try {
            if ($this.promptOverwriteConfiguration()) {
                Export-Clixml -Path $path -InputObject $this;
            }
        }
        catch [System.IO.DirectoryNotFoundException] {
            Write-Information "Specfied directory does not exist.  Creating path...";
            New-Item -ItemType 'File' -Force -Name $path;
            Write-Information "New location created.";
        }
    }

    # Load previous bookmark data, typically at the beginning of a session
    [void] LoadBookmarkDirectory([String] $path) {
        try {
            # Save the last write time of the file
            $this.saveLocationLastUpdate = (Get-Item -Path $path).LastWriteTime;

            # PSObject with bookmark directory properties from prior session
            $deserializedBookmarks = Import-Clixml $path;
            
            # The Bookmarks property in the CLIXML file cannot be deserialized directly into a Dictionary
            foreach ($bookmarkKey in $deserializedBookmarks.Bookmarks.Keys) {
                [System.IO.DirectoryInfo] $bookmarkValue = [System.IO.DirectoryInfo]::new(
                    $deserializedBookmarks.Bookmarks[$bookmarkKey].FullName);
                $this.Bookmarks.Add($bookmarkKey, $bookmarkValue);
            }

            # If Bookmark has never been enabled, then "last session directory" may be null
            if ($deserializedBookmarks.LastSessionDirectory -ne $null) {
                $this.LastSessionDirectory = [System.IO.DirectoryInfo]::new($deserializedBookmarks.LastSessionDirectory.FullName);
            }
        }
        catch [System.IO.DirectoryNotFoundException] {
            Write-Warning "Specifed directory does not exist.  No bookmark data loaded.";
        }
        catch [System.IO.FileNotFoundException] {
            Write-Warning "Specifed file does not exist.  No bookmark data loaded.";
        }
    }

    [void] DisableSaveOnExit() {
        # Unregister the event to save bookmark data
        Get-EventSubscriber `
        |   Where-Object Id -eq [BookmarkDirectory]::singleBookmarkDir.eventSubscriberId `
        |   Unregister-Event;
    }

    # Prompt the user to overwrite the bookmark configuratino, default to $true
    [bool] promptOverwriteConfiguration() {
        $title = "Override Bookmark Configuration";
        $message = "
            Another PowerShell session has updated your Bookmark configuration.
            Would you like to overwrite this update with the Bookmark configuration
            from this session?";
        
        $yes = [System.Management.Automation.Host.ChoiceDescription]::new(
            "&Yes", "Overwrites the PowerShell Bookmark configuration updated from another session");

        $no = [System.Management.Automation.Host.ChoiceDescription]::new(
            "&No", "Keeps the existing PowerShell Bookmark configuration updated from another session");

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no);

        $result = $(Get-Host).UI.PromptForChoice($title, $message, $options, 0);

        # Return $true if the user approves of overwriting the updated configuration
        switch ($result)
        {
            0 { return $true }
            1 { return $false }
        }

        # Return $true by default
        return $true;
    }
}
