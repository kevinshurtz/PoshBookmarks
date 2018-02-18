function Get-LastSessionDirectory {
    $bookmarks = [BookmarkDirectory]::GetInstance()
    return $bookmarks.LastSessionDirectory
}
