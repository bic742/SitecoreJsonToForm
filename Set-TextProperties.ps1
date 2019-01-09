function Set-TextProperties(
    [hashtable]$properties,
    [object]$data
) {
    Add-StringProperty $properties "Html Tag" "htmlTag" $element
    Add-StringProperty $properties "Text" "text" $element
}