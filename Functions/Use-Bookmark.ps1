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
