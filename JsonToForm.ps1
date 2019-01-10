Import-Function -Name Set-PropertyUpdaters
Import-Function -Name Set-ButtonProperties
Import-Function -Name Set-CheckboxProperties
Import-Function -Name Set-DateProperties
Import-Function -Name Set-FormFieldProperties
Import-Function -Name Set-FormProperties
Import-Function -Name Set-InputProperties
Import-Function -Name Set-ListProperties
Import-Function -Name Set-MultipleLineProperties
Import-Function -Name Set-NumberProperties
Import-Function -Name Set-SelectionProperties
Import-Function -Name Set-TextProperties
Import-Function -Name Set-PasswordProperties
Import-Function -Name Set-ConfirmPasswordProperties

#region Declarations

$fieldTemplates = @{
  Form = '{6ABEE1F2-4AB4-47F0-AD8B-BDB36F37F64C}';
  Button = '{94A46D66-B1B8-405D-AAE4-7B5A9CD61C5E}';
  Checkbox = '{2F07293C-077F-456C-B715-FDB791ACB367}';
  Date = '{5AC7621E-9F18-4569-BCEC-F5BF8BA1F4D7}';
  DropdownList = '{9121D435-48B8-4649-9D13-03D680474FAD}';
  Email = '{886ADEC1-ABF8-40E1-9926-D9189C4E8E1B}';
  Field = '{84ED565A-BEC9-46D4-9603-6E0516580832}';
  List = '{5B672865-55D2-413E-B699-FDFC7E732CCF}';
  ListBox = '{81FE389A-FDC7-4ECA-A5A9-4BE3ACA0C69A}';
  MultipleLineText = '{D8386D04-C1E3-4CD3-9227-9E9F86EF3C88}';
  Number = '{E8D5A5A3-6430-4701-BAAD-1DB1947616CC}';
  Password = '{05D71800-56BE-4A53-AFAB-3819DA817A4A}';
  PasswordConfirmation = '{52FEC879-7D8D-46D3-BBB2-131293957709}';
  Text = '{FC18F915-EAC6-460A-8777-6E1376A9EA09}';
  Page = '{CFEE7B51-8505-45CE-B843-9358F827DF87}';
  Section = '{8CDDB194-F456-4A75-89B7-346F8F39F95C}';
  Input = '{0908030B-4564-42EA-A6FA-C7A5A2D921A8}';
}

$submitActions = @{
  TriggerGoal = '{106587B9-1B9C-4DDB-AE96-BAC8416C21B5}';
  TriggerCampaignActivity = '{4A937D74-7986-4E19-9D8E-EC14675B17F0}';
  TriggerOutcome = '{6958E765-5244-46D9-8C81-2487E52EBDD5}';
  SendEmailCampaignMessage = '{7B576A74-8FD4-49AB-956A-16AEFB95CC6D}';
  RedirectToPage = '{3F3E2093-9DEA-4199-86CA-44FC69EF624D}';
  SaveData = '{0C61EAB3-A61E-47B8-AE0B-B6EBA0D6EB1B}';
}

$folderTemplateId = '{A87A00B1-E6DB-45AB-8B54-636FEC3B5523}'
$extendedListItemTemplateId = '{B3BDFE59-6667-4432-B261-05D0E3F7FDF6}'
$submitActionDefinitionTemplateId = '{05FE45D4-B9C7-40DE-B767-7C5ABE7119F9}'

#endregion

#region Field Processors

function CreateListOptions (
  [Sitecore.Data.Items.Item]$item,
  [object]$data
) {
  $isDynamic = $false

  $exists = [bool]($data.PSObject.Properties.name -match "isDynamic")
  
  if ($exists) {
    $isDynamic = [System.Convert]::ToBoolean($data.isDynamic)

    if ($isDynamic) { return }
  }
  
  $settingsItem = New-Item -Path "master:$($item.Paths.FullPath)\Settings" -ItemType $folderTemplateId
  $datasourceItem = New-Item -Path "master:$($settingsItem.Paths.FullPath)\Datasource" -ItemType $folderTemplateId 

  foreach($option in $data.settings.datasource) 
  {
    $name = $option.value
    $value = $option.value

    $hasName = [bool]($option.PSObject.Properties.name -match "name")

    if ($hasName) {
      $name = $option.name
    }

    $optionItem = New-Item -Path "master:$($datasourceItem.Paths.FullPath)\$($name)" -ItemType $extendedListItemTemplateId 

    $optionItem.Editing.BeginEdit()
    $optionItem["Value"] = $value
    $optionItem.Editing.EndEdit() | Out-Null
  }
}

function CreateSubmitActions( 
  [Sitecore.Data.Items.Item]$item,
  [object]$data
) { 
  $submitActionsItem = New-Item -Path "master:$($item.Paths.FullPath)\SubmitActions" -ItemType $folderTemplateId

  foreach($option in $data.submitActions) {
    $saveAction = New-Item -Path "master:$($submitActionsItem.Paths.FullPath)\$($option.name)" -ItemType $submitActionDefinitionTemplateId

    $saveActionTypeId = $submitActions.$($option.submitAction)

    $saveProperties = @{ "Submit Action" = $saveActionTypeId; }
    Add-StringProperty $saveProperties "Parameters" "parameters" $option

    Update-NewItem $saveAction $saveProperties
  }
}

#endregion

function Invoke-ProcessElements(
  [array]$elements,
  [string]$rootPath
) {

  $sortOrder = 0

  foreach($element in $elements) {
    $templateTypeId = $fieldTemplates.$($element.fieldTemplate)

    $newItem = New-Item -Path "master:$($rootPath)\$($element.Name)" -ItemType $templateTypeId

    $itemProperties = @{ }

    $isFormField = $false

	switch($element.fieldTemplate) {
	  "Form" {
	    Set-FormProperties $itemProperties $element
	    break;
	  }
	  "Button" {
        Set-ButtonProperties $itemProperties $element
        CreateSubmitActions $newItem $element
	    break;
	  }
	  "Checkbox" {
        Set-CheckboxProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "DrowdownList" {
        Set-DropDownListProperties $itemProperties $element
        CreateListOptions $newItem $element
        $isFormField = $true
	    break;
	  }
	  "Email" {
        # Email is just an input with an Email Validator on it
        Set-EmailProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "Field" {
	    break;
	  }
	  "List" {
        Set-SelectionProperties $itemProperties $element
        CreateListOptions $newItem $element       
        $isFormField = $true
	    break;
	  }
	  "ListBox" {
	    break;
	  }
	  "MultipleLineText" {
        Set-InputProperties $itemProperties $element
        Set-MultipleLineProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "Number" {
        Set-NumberProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "Password" {
        Set-PasswordProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "PasswordConfirmation" {
        Set-PasswordProperties $itemProperties $element
        Set-ConfirmPasswordProperties $itemProperties $element
        $isFormField = $true
	    break;
	  }
	  "Text" {
	    Set-TextProperties $itemProperties $element
	    break;
	  }
	  "Date" {
	    Set-DateProperties $itemProperties $element
        $isFormField = $true
        break;
	  }
	  "Input" {
	    Set-InputProperties $itemProperties $element
        $isFormField = $true
        break;
	  }
	}

    Add-StringProperty $itemProperties "Css Class" "cssClass" $element
    Add-FieldTypeProperty $itemProperties $element

    $itemProperties.Add("__Sortorder", $sortOrder)
    $sortOrder += 100

    if ($isFormField) {
      Set-FormFieldProperties $itemProperties $element
    }

    Update-NewItem $newItem $itemProperties

	if ($element.elements.count -gt 0) {
	  Invoke-ProcessElements $element.elements $newItem.Paths.FullPath
	}
  }
}

$formDataFilePath = Read-Host "Enter path to form data configuration file: "

# $formDataFilePath = "/sitecore/content/Shared Datasources/SampleForm"

$formDataItem = Get-Item -Path master:$($formDataFilePath)
$formJson = $formDataItem.Json
$formData = ConvertFrom-Json $formJson

$formItem = New-Item -Path "master:\sitecore\Forms\$($formData.Name)" -ItemType $($fieldTemplates.Form)
$formItemPath = $formItem.Paths.FullPath

$formProperties = @{ }
Set-FormProperties $formProperties $formData
Update-NewItem $formItem $formProperties
Invoke-ProcessElements $formData.elements $formItemPath 