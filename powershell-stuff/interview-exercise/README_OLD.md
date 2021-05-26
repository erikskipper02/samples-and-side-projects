# technical-exercise
Some stuff for a thing

## Getting Started

My goal is to use PowerShell for task 1-3 and Go for the bonus task.

Tools may be subject to change.

### Prerequisites

* [.NET Core 3.0](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-6)
    1. Download installer
    2. Run installer
    3. Verify installation - Open Terminal and run `dotnet`
* [PowerShell Core on macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-6)
    1. Open Terminal and run `dotnet tool install --global PowerShell`
    2. Invoke the tool using the following command: `pwsh`
* [Go](https://golang.org/doc/install#install) - Go's "Getting Started" documentation does a good job of getting one up and running with Go
* `directory.csv` and `inventory.csv` - These files should be located in the root of this project

## Executing the Scripts

### taskOne.ps1

1. `cd` into the root of this project
2. Run `.\taskOne.ps1`

Result:
* `names_list.csv` - Outputs the employees that do not have a registered computer to a CSV file
* `employees.txt` - Outputs the employees that do not have a registered computer to a TXT file

### taskTwo.ps1

1. `cd` into the root of this project
2. Run `.\taskTwo.ps1`

Result: 
* `computers_list.csv` - Outputs the computers that have not checked in in 3+ weeks to a CSV file
* `computers.txt` - Outputs the computers that have not checked in in 3+ weeks to a TXT file

### taskThree.ps1

1. `cd` into the root of this project
2. Copy Slack Incoming WebHook URL in line `19` and `30`
3. Run `.\taskThree.ps1`

Result: 
* `computers_list.csv` and `name_list.csv` - Stored as variables and converted to strings
* POST'd to Slack channel via Incoming WebHook

### main.go (Bonus Task)

1. `cd` into the root of this project
2. Run `go run main.go`

Result: 
* Fires up a web server that listens on port 3000
* Responds to POST requests via http://localhost:3000/get

## Bookmarks

The websites that I used/visited to complete these exercises can be imported into Chrome using the HTML files in [bookmarks/](bookmarks/).

For more info on importing bookmarks, see [this article](https://support.google.com/chrome/answer/96816?hl=en).

## Built With

* [PowerShell](https://github.com/PowerShell/PowerShell) - Used for task 1-3
* [Go](https://github.com/golang/go) - Used for bonus task

## Authors

* **The Buzzword Engineer**

## License

This project is licensed under the Mozilla Public License 2.0 - see the [LICENSE](LICENSE) file for details.
