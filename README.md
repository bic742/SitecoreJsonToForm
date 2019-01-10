# Sitecore - Json To Form Converter

Sitecore 9 Forms is a powerful upgrade from WFFM. It provides a simple interface that allows the user to easily create forms on demand, and collect information from their visitors. For longer forms, the creation process can be a bit tedious and repetitive. This prompted me to leverage Sitecore PowerShell to create a script that will parse a JSON file and generate a form. Now the repetitive stuff can be managed via copy/paste.

 
## How It Works

1. Download and install the package from the repository (TODO: Add Link)
	* PowerShell Scripts for parsing JSON
	* JSON Item Template
2. Create a new item based on the installed JSON Item Template
3. Add your JSON to the new item (see below for reference guide)
4. Execute Script
	* Invoke-Script -Path "/sitecore/system/Modules/PowerShell/Script Library/SPE/Tools/Json To Form/Main/JsonToForm"
5. The script will prompt for the path to your JSON Item (TODO: Add screenshot)
6. Watch the magic

 ## Sample JSON

```
{
  "name": "Meeting Proposal Test",
  "fieldTemplate": "Form",
  "elements": [
    {
      "name": "Page",
      "fieldTemplate": "Page",
      "elements": [
      {
        "name": "OrganizerText",
        "fieldTemplate": "Text",
        "text": "Organizer",
        "htmlTag": "h2"
      },
      {
        "name": "Form Group - ProposalDate",
        "fieldTemplate": "Section",
        "cssClass": "form-group",
        "elements": [
          {
            "name": "ProposalDate",
            "fieldTemplate": "Date",
            "title": "When do you need the proposal by?",
            "cssClass": "form-control",
            "required": true,
            "validations": []
          }
        ]
      },
      {
        "name": "Form Group - FirstName",
        "fieldTemplate": "Section",
        "cssClass": "form-group",
        "elements": [
          {
            "name": "firstname",
            "fieldTemplate": "Input",
            "title": "First Name",
            "placeholderText": "First Name",
            "cssClass": "form-control",
            "required": true,
            "validations": []
          }
        ]
      },
      {
        "name": "Form Group - LastName",
        "fieldTemplate": "Section",
        "cssClass": "form-group",
        "elements": [
            {
              "name": "lastname",
              "fieldTemplate": "Input",
              "title": "Last Name",
              "placeholderText": "Last Name",
              "cssClass": "form-control",
              "required": true,
              "validations": []
            }
          ]
        }
      ]
    }
  ]
}
```

## TODO
1. Add support for validations