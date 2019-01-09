function Set-SelectionProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-BoolProperty $properties "Is Dynamic" "isDynamic" $data $false

  Add-StringProperty $properties "Display Field Name" "displayFieldName" $data
  Add-StringProperty $properties "Value Field Name" "valueFieldName" $data
  Add-StringProperty $properties "Default Selection" "defaultSelection" $data
  Add-StringProperty $properties "Datasource" "datasource" $data
}