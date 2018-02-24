function Use-Bookmark {
    Param(
        # The name of the bookmark to navigate to
        [Parameter(Mandatory=$false, Position=1)]
        [String]
        $Name
    )

    # Get the desired bookmark and navigate to it
    Set-Location (Get-Bookmark $Name)
}
