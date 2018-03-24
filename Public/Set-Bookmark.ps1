function Set-Bookmark {
    [CmdletBinding()]
    Param()

    DynamicParam {
        $runtimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        
        # Create name parameter attributes
        $nameParameterName = 'Name'
        $nameAttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        $nameParameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $nameParameterAttribute.Mandatory = $true
        $nameParameterAttribute.Position = 0

        $nameAttributeCollection.Add($nameParameterAttribute)

        # Add proper bookmark validation set to parameter
        $bookmarks = [BookmarkDirectory]::GetInstance()

        $bookmarkOpts = $bookmarks.Bookmarks.Keys
        $validateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($bookmarkOpts)
        $nameAttributeCollection.Add($validateSetAttribute)

        # Create name parameter
        $nameParameter = [System.Management.Automation.RuntimeDefinedParameter]::new($nameParameterName, [String], $nameAttributeCollection)
        $runtimeParameterDictionary.Add($nameParameterName, $nameParameter)

        # Create target parameter attributes
        $targetParameterName = 'Target'
        $targetAttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        $targetParameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $targetParameterAttribute.Mandatory = $true
        $targetParameterAttribute.Position = 1

        $targetAttributeCollection.Add($targetParameterAttribute)

        # Create target parameter
        $targetParameter = [System.Management.Automation.RuntimeDefinedParameter]::new($targetParameterName, [String], $targetAttributeCollection)
        $runtimeparameterDictionary.Add($targetParameterName, $targetParameter)
        
        return $runtimeParameterDictionary
    }

    Begin {
        $Name = $PSBoundParameters[$nameParameterName]
        $Target = $PSBoundParameters[$targetParameterName]
        $bookmarks = [BookmarkDirectory]::GetInstance()
    }

    Process {
        $location = Get-Item -Path $Target
        $bookmarks.Bookmarks[$Name] = $location
    }
}
