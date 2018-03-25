function Disable-Bookmarks {
    # Unregister the event to save bookmark data
    $bookmarks = [BookmarkDirectory]::GetInstance()
    Get-EventSubscriber | Where-Object Id -eq $bookmarks.EventSubscriberId | Unregister-Event
}
