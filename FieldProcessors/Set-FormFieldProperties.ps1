function Set-FormFieldProperties(
  [hashtable]$properties,
  [object]$data
) {
  Add-StringProperty $properties "Label Css Class" "labelCssClass" $data	
  Add-StringProperty $properties "Title" "title" $data	

  Add-BoolProperty $properties "Is Tracking Enabled" trackingEnabled $data $true	
  Add-BoolProperty $properties "Required" "required" $data $false	
  Add-BoolProperty $properties "Allow Save" "allowSave" $data $true
}