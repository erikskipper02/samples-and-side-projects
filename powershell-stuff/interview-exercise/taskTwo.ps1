<#
.Synopsis
   taskTwo.ps1 identifies computers that have not checked in in 21+ days
.DESCRIPTION
   taskTwo.ps1 does the following:
   
    * Identifies computers that have not checked in in 21+ days
    * Adds a header to a CSV
    * Converts the CSV to a TXT file
    * Cleans up the TXT file
    * Cleans up the white space in the TXT file
    * Deletes some extraneous TXT files
    * Renames a TXT file
.NOTES
  Author:         The Buzzword Engineer
  Creation Date:  11/28/19
#>

function IdentifyComputersThatHaveNotCheckedIn {
    $numberOfDaysAgo = "-21"
    $getDateTwentyOneDaysAgo = (Get-Date).AddDays($numberOfDaysAgo)
    
    $inventoryDotCsv = ".\inventory.csv"
    $header = "Last Check-in"

    $computersList = ".\computers_list.csv"
    
    Import-Csv $inventoryDotCsv | ForEach-Object {
        if ( (Get-Date $_.$header) -lt $getDateTwentyOneDaysAgo ) {
            Write-Output $_.'Name' >> $computersList
        }
    } 
}

# IdentifyComputersThatHaveNotCheckedIn

function AddHeaderToCsv {
    $file = ".\computers_list.csv"
    $headerName = "Name"
    $filedata = import-csv $file -Header $headerName
    $filedata | export-csv $file -NoTypeInformation
}

# AddHeaderToCsv

function convertComputersUnderscoreListToTextFile {
    $csvToImport = ".\computers_list.csv"
    $listOne = ".\one.txt"
    $importCsv = Import-Csv -Path $csvToImport |
    Select-Object @{
        Name='Name';
        Expression={
            $_.Name
        }
    } |
    Out-File -FilePath $listOne
}

# convertNamesUnderscoreListToTextFile

function cleanUpTextFile {
    $textFileToCleanUp = ".\one.txt"
    $listTwo = ".\two.txt"
    Get-Content $textFileToCleanUp |
        ForEach-Object {
            $_ -replace "Name", "" `
               -replace "----", "" `
        } |
            Out-File $listTwo
}

# cleanUpTextFile

function cleanUpWhiteSpaceInTextFile {
    $textFileToCleanUpSomeMore = ".\two.txt"
    $listThree = ".\three.txt"
    Get-Content $textFileToCleanUpSomeMore |
        ? {$_.trim() -ne ""} |
            Set-Content $listThree 
}

# cleanUpWhiteSpaceInTextFile

function DeleteAllUneededFiles {
    $fileOneToDelete = ".\one.txt"
    $fileTwoToDelete = ".\two.txt"
    Remove-Item -Path $fileOneToDelete -Force
    Remove-Item -Path $fileTwoToDelete -Force
}

# DeleteAllUneededFiles

function renameFile {
    $fileToBeRenamed = ".\three.txt"
    $newFileName = ".\computers.txt"
    Rename-Item -Path $fileToBeRenamed -NewName $newFileName
}

# renameFile

function doAllTheThings {
    IdentifyComputersThatHaveNotCheckedIn
    AddHeaderToCsv
    convertComputersUnderscoreListToTextFile
    cleanUpTextFile
    cleanUpWhiteSpaceInTextFile
    DeleteAllUneededFiles
    renameFile
}

doAllTheThings
