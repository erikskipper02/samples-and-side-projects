<#
.Synopsis
   taskThree.ps1 posts the results to a Slack channel
.DESCRIPTION
   taskThree.ps1 does the following:

    * Posts the results of Task 1 to a Slack channel
    * Posts the results of Task 2 to a Slack channel
.NOTES
  Author:         The Buzzword Engineer
  Creation Date:  11/28/19
#>

# function ConvertCsvToJson {
#     $computerListCsv = ".\computers_list.csv"
#     $computerListJson = "computers_list.json"
#     $nameListCsv = ".\names_list.csv"
#     $nameListJson = "names_list.json"
#     Import-Csv $computerListCsv | ConvertTo-Json | Add-Content -Path $computerListJson
#     Import-Csv $nameListCsv | ConvertTo-Json | Add-Content -Path $nameListJson
# }

# ConvertCsvToJson

function SendComputerListToSlack {
    $a = Import-Csv -Path .\computers_list.csv | Out-String
    $url = ""
    $text = @{
        text=$a
    }
    $json = $text | ConvertTo-Json
    Invoke-RestMethod $url -Method Post -Body $json -ContentType 'application/json'
}

# SendComputerListToSlack

function SendNameListToSlack {
    $b = Import-Csv -Path .\names_list.csv | Out-String
    $url = ""
    $text = @{
        text=$b
    }
    $json = $text | ConvertTo-Json
    Invoke-RestMethod $url -Method Post -Body $json -ContentType 'application/json'
}

# SendNameListToSlack

function doAllTheThings {
    SendComputerListToSlack
    SendNameListToSlack
}

doAllTheThings
