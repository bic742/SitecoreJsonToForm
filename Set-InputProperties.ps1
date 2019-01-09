function Set-InputProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-StringProperty $properties "Min Length" "minLength" $data
  Add-StringProperty $properties "Max Length" "maxLength" $data
  Add-StringProperty $properties "Placeholder Text" "placholderText" $data

  Add-StringProperty $properties "Default Value" "defaultValue" $data
}