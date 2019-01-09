function Set-FormProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-BoolProperty $properties "Is Tracking Enabled" "trackingEnabled" $element $true
  Add-BoolProperty $properties "Is Ajax" "isAjax" $element $true
  Add-BoolProperty $properties "Is Template" "isTemplate" $element $false

  Add-StringProperty $properties "Scripts" "scripts" $element
  Add-StringProperty $properties "Styles" "styles" $element
}