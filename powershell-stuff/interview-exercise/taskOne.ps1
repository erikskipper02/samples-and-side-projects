<#
.Synopsis
   taskOne.ps1 determines which employees do not have a registered computer.
.DESCRIPTION
   taskOne.ps1 does the following:

    * Combines columns in the employee directory
    * Determines which employees do not have a registered computer and outputs it to a CSV
    * Converts the CSV to a TXT file
    * Cleans up the TXT file
    * Cleans up the white space in the TXT file
    * Deletes some extraneous TXT files
    * Renames a TXT file
.NOTES
  Author:         The Buzzword Engineer
  Creation Date:  11/28/19
#>

function CombineColumnsInEmployeeDirectory {
    $employeeDirectory = ".\directory.csv"
    $newEmployeeDirectory = ".\directory_new.csv"
    Import-Csv $employeeDirectory |
        Select-Object @{
            Name='Name';
            Expression={
                $_.first_name,$_.last_name -join " "
            }
        } |
        Export-Csv $newEmployeeDirectory -NoTypeInformation 
}

# CombineColumnsInEmployeeDirectory

function DetermineEmployeesWithUnregisteredComputer {
    $directoryUnderscoreNewDotCsv = ".\directory_new.csv"
    $inventoryDotCsv = ".\inventory.csv"
    $fileOneToCompare = Import-Csv -Path $directoryUnderscoreNewDotCsv 
    $fileTwoToCompare = Import-Csv -Path $inventoryDotCsv
    $propertyToCompare = "Name"
    $pathOfTextFile = ".\names_list.csv"
    Compare-Object -ReferenceObject $fileOneToCompare -DifferenceObject $fileTwoToCompare -Property $propertyToCompare -PassThru | 
    # Out-File -FilePath $pathOfTextFile
    Export-Csv $pathOfTextFile -NoTypeInformation 
}

# DetermineEmployeesWithUnregisteredComputer

function convertNamesUnderscoreListToTextFile {
    $csvToImport = ".\names_list.csv"
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
    $fileThreeToDelete = ".\directory_new.csv"
    # Remove-Item -Path $fileOneToDelete $fileTwoToDelete $fileThreeToDelete -Force
    Remove-Item -Path $fileOneToDelete -Force
    Remove-Item -Path $fileTwoToDelete -Force
    Remove-Item -Path $fileThreeToDelete -Force
}

# DeleteAllUneededFiles

function renameFile {
    $fileToBeRenamed = ".\three.txt"
    $newFileName = ".\employees.txt"
    Rename-Item -Path $fileToBeRenamed -NewName $newFileName
}

# renameFile

function doAllTheThings {
    CombineColumnsInEmployeeDirectory
    DetermineEmployeesWithUnregisteredComputer
    convertNamesUnderscoreListToTextFile
    cleanUpTextFile
    cleanUpWhiteSpaceInTextFile
    DeleteAllUneededFiles
    renameFile
}

doAllTheThings