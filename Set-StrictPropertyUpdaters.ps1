function Set-ItemProperties(
    [hashtable]$properties,
    [object]$element
) {

    $ignoreProperties = 'elements', 'name', 'fieldType', 'validations', 'settings', 'submitActions'

    $element.PSObject.Properties | ForEach-Object {
        if (!($_.Name -in $ignoreProperties)) {
            $sitecorePropertyName = Get-SitecorePropertyName $_.Name
      
            $propertyValue = $_.Value
            $propertyType = $propertyValue.GetType().Name
      
            switch ($propertyType) {
                "Boolean" { 
                    Set-BoolProperty $properties $sitecorePropertyName $propertyValue
                    break;
                }
                "Int32" { }
                "String" {
                    Set-StringProperty $properties $sitecorePropertyName $propertyValue
                }
                default {
                    Write-Host "Property Type Not Supported: $propertyType"
                }
            }
        }
    }
}

function Get-SitecorePropertyName (
    [string]$propertyName
) {
    $sitecorePropertyName = $propertyName -creplace '.(?=[^a-z])', '$& '
    return $sitecorePropertyName
}

function Set-StringProperty (
    [hashtable]$properties,
    [string]$itemPropertyName,
    [string]$value
) {
  
    # test string as a date
    $result = Get-Date
    $success = [datetime]::TryParseExact(
        $value,
        "mm/dd/yyyy",
        [system.Globalization.DateTimeFormatInfo]::InvariantInfo,
        [system.Globalization.DateTimeStyles]::None,
        [ref]$result
    )

    if ($success) {
        Set-DateProperty $properties $itemPropertyName $result
        return
    }
  
    $properties.Add($itemPropertyName, $value)
}

function Set-BoolProperty (
    [hashtable]$properties,
    [string]$itemPropertyName,
    [bool]$value
) {

    $dataValue = [System.Convert]::ToBoolean($value)

    $dataSitecoreValue = if ($dataValue) { "1" } else { "0" }

    $properties.Add($itemPropertyName, $dataSitecoreValue)
}

function Set-DateProperty (
    [hashtable]$properties,
    [string]$itemPropertyName,
    [DateTime]$date
) {
    $resultString = $date.ToString("yyyymmdd")

    $properties.Add($itemPropertyName, $resultString)
}

function Update-NewItem (
    [Sitecore.Data.Items.Item]$item,
    [hashtable]$properties
) {
    $item.Editing.BeginEdit()
    $properties.Keys | % { $item[$_] = $properties[$_] }
    $item.Editing.EndEdit() | Out-Null
}