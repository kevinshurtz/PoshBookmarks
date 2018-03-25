<#
.SYNOPSIS
Gets the directory associated with a bookmark or a Dictionary of all bookmarks.

.DESCRIPTION
The Bookmark Directory contains a user-managed Dictionary of short names and directories for quicker navigation throughout the filesystem.  The Get-Bookmark function returns a directory associated with a bookmark name.  If no name is specified, it returns a Dictionary of all bookmark names and directories.

.PARAMETER Name
The short name to be mapped to an associated directory.

.EXAMPLE
PS C:\> Get-Bookmark -Name docs


    Directory: C:\Users\ExampleUser


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-r---        3/15/2018   7:06 AM                Documents

.EXAMPLE
PS C:\> Get-Bookmark

Key     Value
---     -----
proj    C:\Users\ExampleUser\Google Drive\Personal\Projects\
code    C:\Users\ExampleUser\Google Drive\Personal\Code\
desk    C:\Users\ExampleUser\Desktop\
down    C:\Users\ExampleUser\Downloads
modules C:\Users\ExampleUser\Documents\WindowsPowerShell\Modules\
docs    C:\Users\ExampleUser\Documents\

.EXAMPLE
gbm docs


    Directory: C:\Users\ExampleUser


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-r---        3/15/2018   7:06 AM                Documents

.NOTES
This function supports tab completion for all bookmark names in the active Bookmark Direcory.
#>
function Get-Bookmark {
    [CmdletBinding()]
    Param()

    DynamicParam {
        $parameterName = 'Name'
        $runtimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        
        # Create paramter attributes
        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        $parameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $parameterAttribute.Mandatory = $false
        $parameterAttribute.Position = 0

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
        $bookmarks = [BookmarkDirectory]::GetInstance()
    }

    Process {
        # Return either the set of all bookmarks, or an individual bookmark
        if ($PSBoundParameters.ContainsKey('Name')) {
            return $bookmarks.Bookmarks[$Name]
        }
        else {
            return $bookmarks.Bookmarks
        }
    }
}
