$fieldTypes = @{
    Text = '{983BFA5F-C6B6-4AEE-A3BB-46B95D52E7DF}';
    SingleLineText = '{4EE89EA7-CEFE-4C8E-8532-467EF64591FC}';
    MultipleLineText = '{A296A1C1-0DA0-4493-A92E-B8191F43AEC6}';
    Number = '{5B153FC0-FC3F-474F-8CB8-233FB1BEF292}';
    Email = '{04C39CAC-8976-4910-BE0D-879ED3368429}';
    Telephone = '{DF74F55B-47E6-4D1C-92F8-B0D46A7B2704}';
    Checkbox = '{4DA85E8A-3B48-4BC6-9565-8C1F5F36DD1B}';
    Date = '{38137D30-7B2A-47D5-BBD8-133252C01B28}';
    OptGroupDropDownList = '{E5B02A7D-FDE7-4F01-ABD2-04D97822079D}';
    DropDownList = '{E0CFADEE-1AC0-471D-A820-2E70D1547B4B}';
    ListBox = '{222A2121-D370-4C6F-80A3-03C930B718BF}';
    CheckboxList = '{D86A361A-D4FF-46B2-9E97-A37FC5B1FE1A}';
    RadioButtonList = '{EDBD38A8-1AE9-42EC-8CCD-F5B0E2998B4F}';
    Password = '{668A1C37-9D6B-483B-B7C1-340C92D04BA4}';
    PasswordConfirmation = '{6293530F-36A1-4CA6-A2E6-C59C9343F096}';
    Section = '{447AA745-6D29-4B65-A5A3-8173AA8AF548}';
    Page = '{D819B43E-C136-4392-9393-8BE7FCE32F5E}';
    SubmitButton = '{7CE25CAB-EF3A-4F73-AB13-D33BDC1E4EE2}';
    Form = '{3A4DF9C0-7C82-4415-90C3-25440257756D}';
}

function Add-StringProperty( 
  [hashtable]$properties,
  [string]$itemPropertyName,
  [string]$dataPropertyName,
  [object]$data
) {
  
  if (Get-PropertyExists $data $dataPropertyName) {
      $properties.Add($itemPropertyName, $data.$dataPropertyName)
  }
}

function Add-BoolProperty(
    [hashTable]$properties,
    [string]$itemPropertyName,
    [string]$dataPropertyName,
    [object]$data,
    [bool]$standardValue
) {
  if (!(Get-PropertyExists $data $dataPropertyName)) { return }

  $dataValue = [System.Convert]::ToBoolean($data.$dataPropertyName)

  if ($dataValue -eq $standardValue) { return }

  $dataSitecoreValue = if ($dataValue) { "1" } else { "0" }

  $properties.Add($itemPropertyName, $dataSitecoreValue)
}

function Add-DateProperty(
    [hashtable]$properties,
    [string]$itemPropertyName,
    [string]$dataPropertyName,
    [object]$data
) {
    if(!(Get-PropertyExists $data $dataPropertyName)) { return }

    $result = Get-Date
    $success = [datetime]::TryParseExact(
        $value, 
        "mm/dd/yyyy", 
        [System.Globalization.DateTimeFormatInfo]::InvariantInfo,
        [System.Globalization.DateTimeStyles]::None,
        [ref]$result
    )

    if ($success) {
        $resultString = $result.ToString("yyyymmdd")

        $properties.Add($itemPropertyName, $resultString)
    }
}

function Add-FieldTypeProperty(
    [hashtable]$properties,
    [object]$data
) {
    if (!(Get-PropertyExists $data "fieldType")) { return }

    $fieldTypeId = $fieldTypes.$($element.fieldType)

    $properties.Add("Field Type", $fieldTypeId)
}

function Get-PropertyExists(
    [object]$data,
    [string]$propertyName
) {
    $exists = [bool]($data.PSObject.Properties.name -match $propertyName)

    return $exists
}

function Update-NewItem (
  [Sitecore.Data.Items.Item]$item,
  [hashtable]$properties
) {
  $item.Editing.BeginEdit()
  $properties.Keys | % { $item[$_] = $properties[$_] }
  $item.Editing.EndEdit() | Out-Null
}