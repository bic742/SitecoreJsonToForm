function Set-InputProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-StringProperty $properties "Confirm Password Label" "confirmPasswordLabel" $data
  Add-StringProperty $properties "Confirm Password Placeholder" "confirmPasswordPlaceholder" $data
}