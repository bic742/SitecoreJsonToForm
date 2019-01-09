function Set-MultipleLineProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-StringProperty $properties "Rows" "rows" $data
}