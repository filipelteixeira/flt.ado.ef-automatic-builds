
## Parameters
param ($connectionString, $pat)


if (($connectionString -eq "") -or ($connectionString -eq $null))
{
    throw "Invalid Connection String"
}

## Variables

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$adoGitProject = 'https://filipelteixeira.visualstudio.com/DefaultCollection/Blog%20Post%20-%20Automatic%20EF%20Core%20Builds/_git/flt.ado.efbuild.entities'
$adoGitBranchName = 'automated/efcore-scaffold-' + $timestamp
$adoGitEmail = 'filipelteixeira@gmail.com'
$adoGitName = 'Filipe Teixeira'
$concatenatedPat = $adoGitEmail + ":" + $pat
$B64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$concatenatedPat"))

Write-Output "Outputting set values:"
Write-Output "- Value adoGitEmail: $adoGitEmail"
Write-Output "- Value adoGitName: $adoGitName"
Write-Output "- Value Timestamp: $timestamp"
Write-Output "- Value adoGitProject: $adoGitProject"
Write-Output "- Value adoGitBranchName: $adoGitBranchName"

## Clonning and updating git repo

git config --global user.email "$adoGitEmail"
git config --global user.name "$adoGitName"

Write-Output "Downloading project to local folder"

mkdir temp
cd temp

git -c http.extraHeader="Authorization: Basic $B64Pat" clone $adoGitProject -q

if (!(Test-Path -Path 'flt.ado.efbuild.entities')) {
    throw "Project folder was not created"
}

cd flt.ado.efbuild.entities

Write-Output "Creating branch $adoGitBranchName"

git -c http.extraHeader="Authorization: Basic $B64Pat" checkout -b $adoGitBranchName -q

Write-Output "Validating install for EF Core Tools"

dotnet tool update --global dotnet-ef

Write-Output "Running Scaffolding commands"

dotnet ef dbcontext scaffold $connectionString Microsoft.EntityFrameworkCore.SqlServer --project flt.ado.efbuild.entities\flt.ado.efbuild.entities.csproj --startup-project flt.ado.efbuild.entities\flt.ado.efbuild.entities.csproj --data-annotations --use-database-names --force --context DatabaseContext --context-dir Data --output-dir Models

Write-Output "Adding and commiting files to git branch $adoGitBranchName"

git -c http.extraHeader="Authorization: Basic $B64Pat" add *
git -c http.extraHeader="Authorization: Basic $B64Pat" commit -m "Added new scaffolding from database"
git -c http.extraHeader="Authorization: Basic $B64Pat" push -u origin head -q

Write-Output "Finished creating new branch with code changes"
Write-Output "Deleting temporary folder"

cd ..\..

Remove-Item -LiteralPath "temp" -Force -Recurse

# construct base URLs
$apisUrl = "https://filipelteixeira.visualstudio.com/DefaultCollection/Blog%20Post%20-%20Automatic%20EF%20Core%20Builds/_apis"
$projectUrl = "$apisUrl/git/repositories/flt.ado.efbuild.entities"

# create common headers
$headers = @{}
$headers.Add("Authorization", "Basic $B64Pat")
$headers.Add("Content-Type", "application/json")

# Create a Pull Request
$pullRequestUrl = "$projectUrl/pullrequests?api-version=5.1"
$pullRequest = @{
        "sourceRefName" = "refs/heads/$adoGitBranchName"
        "targetRefName" = "refs/heads/dev"
        "title" = "Pull from develop to master"
        "description" = ""
    }

$pullRequestJson = ($pullRequest | ConvertTo-Json -Depth 5)

Write-Output "Sending a REST call to create a new pull request from develop to master"

# REST call to create a Pull Request
$pullRequestResult = Invoke-RestMethod -Method POST -Headers $headers -Body $pullRequestJson -Uri $pullRequestUrl;


Write-Output "Pull request created. Pull Request: $pullRequestResult"

$pullRequestId = $pullRequestResult.pullRequestId

Write-Output "Pull request created. Pull Request Id: $pullRequestId"

# Set PR to auto-complete
$setAutoComplete = @{
    "autoCompleteSetBy" = @{
        "id" = $pullRequestResult.createdBy.id
    }
    "completionOptions" = @{       
        "deleteSourceBranch" = $False
        "bypassPolicy" = $False
    }
}

$setAutoCompleteJson = ($setAutoComplete | ConvertTo-Json -Depth 5)

Write-Output "Sending a REST call to set auto-complete on the newly created pull request"

# REST call to set auto-complete on Pull Request
$pullRequestUpdateUrl = ($projectUrl + '/pullRequests/' + $pullRequestId + '?api-version=5.1')

#$setAutoCompleteResult = Invoke-RestMethod -Method PATCH -Headers $headers -Body $setAutoCompleteJson -Uri $pullRequestUpdateUrl

Write-Output "Pull request set to auto-complete"
