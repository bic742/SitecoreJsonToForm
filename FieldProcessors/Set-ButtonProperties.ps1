function Set-ButtonProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-StringProperty $properties "Label Css Class" "labelCssClass" $data
  Add-StringProperty $properties "Title" "title" $data
  Add-StringProperty $properties "Navigation Step" "navigationStep" $data
}