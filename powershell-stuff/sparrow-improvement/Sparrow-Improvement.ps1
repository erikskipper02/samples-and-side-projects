[cmdletbinding()]Param(
    [Parameter()]
    [string] $AzureEnvironment,
    [Parameter()]
    [string] $ExchangeEnvironment,
    [Parameter()]
    [datetime] $StartDate = [DateTime]::UtcNow.AddYears(-1).AddMinutes(10),
    [Parameter()]
    [datetime] $EndDate = [DateTime]::UtcNow,
    [Parameter()]
    [string] $ExportDir = (Join-Path ([Environment]::GetFolderPath("Desktop")) 'ExportDir')
)

Function Import-PSModules{

    [cmdletbinding()]Param(
        [Parameter(Mandatory=$true)]
        [string] $ExportDir
        )

    $ModuleArray = @("ExchangeOnlineManagement","AzureAD","MSOnline")

    ForEach ($ReqModule in $ModuleArray){
        If ($null -eq (Get-Module $ReqModule -ListAvailable -ErrorAction SilentlyContinue)){
            Write-Verbose "Required module, $ReqModule, is not installed on the system."
            Write-Verbose "Installing $ReqModule from default repository"
            Install-Module -Name $ReqModule -Force
            Write-Verbose "Importing $ReqModule"
            Import-Module -Name $ReqModule
        } ElseIf ($null -eq (Get-Module $ReqModule -ErrorAction SilentlyContinue)){
            Write-Verbose "Importing $ReqModule"
            Import-Module -Name $ReqModule
        }
    }

    #If you want to change the default export directory, please change the $ExportDir value.
    #Otherwise, the default export is the user's home directory, Desktop folder, and ExportDir folder.
    If (!(Test-Path $ExportDir)){
        New-Item -Path $ExportDir -ItemType "Directory" -Force
    }
}

Function Get-AzureEnvironments() {

    [cmdletbinding()]Param(
        [Parameter()]
        [string] $AzureEnvironment, 
        [Parameter()]
        [string] $ExchangeEnvironment
        )

    $AzureEnvironments = [Microsoft.Open.Azure.AD.CommonLibrary.AzureEnvironment]::PublicEnvironments.Keys
    While ($AzureEnvironments -cnotcontains $AzureEnvironment -or [string]::IsNullOrWhiteSpace($AzureEnvironment)) {
        Write-Host 'Azure Environments'
        Write-Host '------------------'
        $AzureEnvironments | ForEach-Object { Write-Host $_ }
        $AzureEnvironment = Read-Host 'Choose your Azure Environment [AzureCloud]'
        If ([string]::IsNullOrWhiteSpace($AzureEnvironment)) { $AzureEnvironment = 'AzureCloud' }
    }

    $ExchangeEnvironments = [System.Enum]::GetNames([Microsoft.Exchange.Management.RestApiClient.ExchangeEnvironment])
    While ($ExchangeEnvironments -cnotcontains $ExchangeEnvironment -or [string]::IsNullOrWhiteSpace($ExchangeEnvironment)) {
        Write-Host 'Exchange Environments'
        Write-Host '---------------------'
        $ExchangeEnvironments | ForEach-Object { Write-Host $_ }
        $ExchangeEnvironment = Read-Host 'Choose your Exchange Environment [O365Default]'
        If ([string]::IsNullOrWhiteSpace($ExchangeEnvironment)) { $ExchangeEnvironment = 'O365Default' }
    }

    Return ($AzureEnvironment, $ExchangeEnvironment)
}

Function Get-AzureAdPermissions{
    # Connect-MsolService -AzureEnvironment $AzureEnvironment
    Connect-AzureAD -AzureEnvironment $AzureEnvironment
    $RolesCollection = @()
    # $Roles = Get-MsolRole
    $Roles = Get-AzureADDirectoryRole
    ForEach ($i In $Roles){
        # $Members = Get-MsolRoleMember -RoleObjectId $Role.ObjectId
        $Members = Get-AzureADDirectoryRoleMember -ObjectId $i.ObjectId
        ForEach ($j In $Members) {
            $obj = [PSCustomObject]@{
                # RoleName = $Role.Name
                RoleName = $i.DisplayName
                MemberName = $j.DisplayName
                # MemberType = $Member.RoleMemberType
                MemberType = $j.UserType
            }
            $RolesCollection += $obj
        }
    }
Return $RolesCollection
}

Function Compare-AzureAdPermissions{
    $Output = Get-AzureAdPermissions -AzureEnvironment $AzureEnvironment
    $CurrentSessionInfo = Get-AzureADCurrentSessionInfo
    $EmailAddress = $CurrentSessionInfo.Account.Id
    $AdUser = Get-AzureADUser -ObjectId $EmailAddress
    $Filter = $Output | Where-Object MemberName -eq $AdUser.DisplayName

    $Roles = @('Compliance Administrator','Security Reader')
    # $roles = @('Fake Role One','Fake Role Two')

    foreach ($i in $Roles) {
         $CheckIfUserHasRoles = $Filter.RoleName.Contains($i)
         if ($CheckIfUserHasRoles) {
             Write-Host "Your account has the" $i "role." -ForegroundColor Cyan 
         } else {
             Write-Host "Your account doesn't have the" $i "role. Please contact your administrator for the" $i "role." -ForegroundColor Red
         }
     }
}

Function Get-ExchangePermissions{

    Connect-ExchangeOnline -ExchangeEnvironment $ExchangeEnvironment -ShowBanner:$false -ShowProgress $false

    $RolesCollection = @()
    $RoleGroupObj = Get-RoleGroup

    foreach ($i in $RoleGroupObj) {
        $obj = [PSCustomObject]@{
            Name = $i.Name
            Roles = $i.Roles
            Members = $i.Members
            }
            $RolesCollection += $obj
         }
        Return $RolesCollection
}

Function Compare-ExchangePermissions{
    $Output = Get-ExchangePermissions
    $CurrentSessionInfo = Get-AzureADCurrentSessionInfo
    $EmailAddress = $CurrentSessionInfo.Account.Id
    $EmailAddressNoDomain = $EmailAddress.Split("@")[0]
    $Filter = $Output | Where-Object Members -eq $EmailAddressNoDomain

    $Roles = [System.Collections.ArrayList]@("Mail Recipients","Security Group Creation and Membership","User Options","View-Only Audit Logs","View-Only Configuration","View-Only Recipients")

    foreach ($i in $Roles) {
         $CheckIfUserHasRoles = $Filter.Roles.Contains($i)
         if ($CheckIfUserHasRoles) {
             Write-Host "Your account has the" $i "role." -ForegroundColor Cyan 
         } else {
             Write-Host "Your account doesn't have the" $i "role. Please contact your administrator for the" $i "role." -ForegroundColor Red
         }
     }
}

Import-PSModules -ExportDir $ExportDir -Verbose
($AzureEnvironment, $ExchangeEnvironment) = Get-AzureEnvironments -AzureEnvironment $AzureEnvironment -ExchangeEnvironment $ExchangeEnvironment
Compare-AzureAdPermissions
Compare-ExchangePermissions