<#
.SYNOPSIS
Gets and navigates to the directory associated with a bookmark.

.DESCRIPTION
The Bookmark Directory contains a user-managed Dictionary of short names and directories for quicker navigation throughout the filesystem.  The Use-Bookmark function accesses a directory associated with a bookmark name and immediately navigates to it.

.PARAMETER Name
The short name to be mapped to an associated directory.

.PARAMETER Path
The path to the directory being bookmarked for quick access.

.EXAMPLE
PS C:\> Use-Bookmark -Name docs -Path 'C:\Users\ExampleUser\Documents'

.EXAMPLE
PS C:\> Use-Bookmark docs 'C:\Users\ExampleUser\Documents'

.EXAMPLE
PS C:\> ubm docs 'C:\Users\ExampleUser\Documents'

.NOTES
This function supports tab completion for all bookmark names in the active Bookmark Direcory.
#>
function Use-Bookmark {
    [CmdletBinding()]
    Param()

    DynamicParam {
        $parameterName = 'Name'
        $runtimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        
        # Create paramter attributes
        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        $parameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $parameterAttribute.Mandatory = $true
        $parameterAttribute.Position = 0
        $parameterAttribute.ValueFromPipeline = $true
        $parameterAttribute.ValueFromPipelineByPropertyName = $true

        $attributeCollection.Add($ParameterAttribute)

        # Add proper bookmark validation set to parameter
        $bookmarks = [BookmarkDirectory]::GetInstance()

        $bookmarkOpts = $bookmarks.Bookmarks.Keys
        $validateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($bookmarkOpts)
        $attributeCollection.Add($validateSetAttribute)

        # Create dynamic parameter
        $runtimeParameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [String], $attributeCollection)
        $runtimeParameterDictionary.Add($parameterName, $runtimeParameter)
        return $runtimeParameterDictionary
    }

    Begin {
        $Name = $PSBoundParameters[$parameterName]
    }

    Process {
        # Get the desired bookmark and navigate to it
        Set-Location (Get-Bookmark $Name)
    }
}
