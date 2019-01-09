function Set-DateProperties(
    [hashtable]$properties,
    [object]$data
) {
    Add-DateProperty $properties "Min" "min" $element
    Add-DateProperty $properties "Max" "max" $element
    Add-DateProperty $properties "Default Value" "defaultValue" $element
}