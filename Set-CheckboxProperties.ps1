function Set-CheckboxProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-BoolProperty $properties "Default Value" "defaultValue" $data $false
}