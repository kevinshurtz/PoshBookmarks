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
