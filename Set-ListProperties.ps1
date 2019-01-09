function Set-ListProperties(
  [hashtable]$properties,
  [object]$data
) {
  Set-SelectionProperties $properties $data
}