function Set-NumberProperties(
  [hashtable]$properties,
  [object]$data
) {
  Set-InputProperties $properties $data
  
  Add-StringProperty $properties "Step" "step" $data
}