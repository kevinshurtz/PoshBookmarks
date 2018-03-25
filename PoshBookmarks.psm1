#Requires -Version 5

# Ensure best practices throughout module
Set-StrictMode -Version 'Latest'

# Determine module root
$moduleRoot = $null

if ($MyInvocation.MyCommand.Path) {
    $moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path
}
else {
    $moduleRoot = $PWD.Path
}

# Dot-source all source files, starting with any classes
"$moduleRoot\Classes\*.ps1" | Resolve-Path | ForEach-Object { . $PSItem.ProviderPath }
"$moduleRoot\Public\*.ps1" | Resolve-Path | ForEach-Object { . $PSItem.ProviderPath }

# Create aliases for interacting with bookmarks
New-Alias -Name 'gbm' -Value 'Get-Bookmark'
New-Alias -Name 'abm' -Value 'Add-Bookmark'
New-Alias -Name 'sbm' -Value 'Set-Bookmark'
New-Alias -Name 'rbm' -Value 'Remove-Bookmark'
New-Alias -Name 'ipbm' -Value 'Import-Bookmark'
New-Alias -Name 'epbm' -Value 'Export-Bookmark'
New-Alias -Name 'ubm' -Value 'Use-Bookmark'
New-Alias -Name 'glsd' -Value 'Get-LastSessionDirectory'

# Export public functions
Export-ModuleMember -Function 'Get-Bookmark'
Export-ModuleMember -Function 'Add-Bookmark'
Export-ModuleMember -Function 'Set-Bookmark'
Export-ModuleMember -Function 'Remove-Bookmark'
Export-ModuleMember -Function 'Import-Bookmark'
Export-ModuleMember -Function 'Export-Bookmark'
Export-ModuleMember -Function 'Use-Bookmark'
Export-ModuleMember -Function 'Get-LastSessionDirectory'

# Export public aliases
Export-ModuleMember -Alias 'gbm'
Export-ModuleMember -Alias 'abm'
Export-ModuleMember -Alias 'sbm'
Export-ModuleMember -Alias 'rbm'
Export-ModuleMember -Alias 'ipbm'
Export-ModuleMember -Alias 'epbm'
Export-ModuleMember -Alias 'ubm'
Export-ModuleMember -Alias 'glsd'
