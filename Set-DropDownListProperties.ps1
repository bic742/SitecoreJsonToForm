function Set-DropDownListProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-BoolProperty $properties "Show Empty Item" "showEmptyItem" $data $true

  Set-SelectionProperties $properties $data
}