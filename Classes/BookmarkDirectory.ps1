# Create singleon bookmark directory class
Class BookmarkDirectory {
    [System.Collections.Generic.Dictionary[String, System.IO.DirectoryInfo]] $Bookmarks;
    [System.IO.DirectoryInfo] $LastSessionDirectory;
    [Int32] $EventSubscriberId;
    
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
            [BookmarkDirectory]::singleBookmarkDir = [BookmarkDirectory]::new([BookmarkDirectory]::defaultSaveLocation)
        }

        return [BookmarkDirectory]::singleBookmarkDir;
    }

    static [BookmarkDirectory] GetCustomInstance([String] $customLocation) {
        if ([BookmarkDirectory]::singleBookmarkDir -eq $null) {
            [BookmarkDirectory]::singleBookmarkDir = [BookmarkDirectory]::new($customLocation)
        }

        return [BookmarkDirectory]::singleBookmarkDir;
    }

    # Update the "last session directory" property, typically invoked before exit
    [void] UpdateLastSessionDirectory([String] $path) {
        $this.LastSessionDirectory = $path;
    }

    [void] UpdateLastSessionDirectory() {
        $this.LastSessionDirectory = (Get-Location).Path;
    }

    # Write bookmark data to disk, typically invoked before exit
    [void] SaveBookmarkDirectory([String] $path) {
        try {
            Export-Clixml -Path $path -InputObject $this;
        }
        catch [System.IO.DirectoryNotFoundException] {
            Write-Information "Specfied directory does not exist.  Creating path...";
            New-Item -ItemType 'File' -Force -Name $path
            Write-Information "New location created."
        }
    }

    [void] SaveBookmarkDirectory() {
        try {
            Export-Clixml -Path ([BookmarkDirectory]::defaultSaveLocation) -InputObject $this;
        }
        catch [System.IO.DirectoryNotFoundException] {
            Write-Information "Specfied directory does not exist.  Creating path...";
            New-Item -ItemType 'File' -Force -Name ;
            Write-Information "New location created."
        }
    }

    # Load previous bookmark data, typically at the beginning of a session
    [void] LoadBookmarkDirectory([String] $path) {
        try {
            # PSObject with bookmark directory properties from prior session
            $deserializedBookmarks = Import-Clixml $path;
            
            # The Bookmarks property in the CLIXML file cannot be deserialized directly into a Dictionary
            foreach ($bookmarkKey in $deserializedBookmarks.Bookmarks.Keys) {
                [System.IO.DirectoryInfo] $bookmarkValue =
                    [System.IO.DirectoryInfo]::new(
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
}
