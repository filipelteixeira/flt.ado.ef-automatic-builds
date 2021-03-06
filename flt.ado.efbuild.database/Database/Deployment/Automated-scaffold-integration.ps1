## Parameters
param ($connectionString, $targetGitRepo)

Write-Output "[TRACE] Initiating Automated Scaffold Integration Script"

if (($connectionString -eq "") -or ($connectionString -eq $null))
{
    throw "Invalid Connection String"
}
if (($targetGitRepo -eq "") -or ($targetGitRepo -eq $null))
{
    throw "Invalid Repo Target"
}

## Variables
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$teamProjectPath = [uri]::EscapeDataString($env:SYSTEM_TEAMPROJECT)
$projectUrl = $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI + "DefaultCollection/" + $teamProjectPath
$apisUrl = $projectUrl + "/_apis/git/repositories/" + $targetGitRepo
$adoGitProject = $projectUrl + "/_git/" + $targetGitRepo
$adoGitBranchName = "automated/efcore-scaffold-" + $timestamp
$adoGitEmail = "automated-ado"
$adoGitName = "Automated ADO"
$apiVersion = "6.0"

Write-Output "[TRACE] Set values:"
Write-Output "[TRACE] - Value adoGitEmail: $adoGitEmail"
Write-Output "[TRACE] - Value adoGitName: $adoGitName"
Write-Output "[TRACE] - Value Timestamp: $timestamp"
Write-Output "[TRACE] - Value adoGitProject: $adoGitProject"
Write-Output "[TRACE] - Value adoGitBranchName: $adoGitBranchName"
Write-Output "[TRACE] - Value apisUrl: $apisUrl"

## Clonning and updating git repo

git config --global user.email "$adoGitEmail"
git config --global user.name "$adoGitName"

Write-Output "[TRACE] Git cloning project to local folder temp"

mkdir temp
cd temp

git -c http.extraHeader="Authorization: Bearer $env:SYSTEM_ACCESSTOKEN" clone $adoGitProject -q

if (!(Test-Path -Path $targetGitRepo)) {
    throw "Project folder was not created"
}

cd flt.ado.efbuild.entities

Write-Output "[TRACE] Creating branch $adoGitBranchName"

git -c http.extraHeader="Authorization: Bearer $env:SYSTEM_ACCESSTOKEN" checkout -b $adoGitBranchName -q

Write-Output "[TRACE] Validating install for EF Core Tools"

dotnet tool update --global dotnet-ef

Write-Output "[TRACE] Running Scaffolding commands"

dotnet ef dbcontext scaffold $connectionString Microsoft.EntityFrameworkCore.SqlServer --project flt.ado.efbuild.entities\flt.ado.efbuild.entities.csproj --startup-project flt.ado.efbuild.entities\flt.ado.efbuild.entities.csproj --data-annotations --use-database-names --force --context DatabaseContext --context-dir Data --output-dir Models --no-onconfiguring

Write-Output "[TRACE] Adding and commiting files to git branch $adoGitBranchName"

git -c http.extraHeader="Authorization: Bearer $env:SYSTEM_ACCESSTOKEN" add *
git -c http.extraHeader="Authorization: Bearer $env:SYSTEM_ACCESSTOKEN" commit -m "Added new scaffolding from database"
git -c http.extraHeader="Authorization: Bearer $env:SYSTEM_ACCESSTOKEN" push -u origin head -q

Write-Output "[TRACE] Finished creating new branch with code changes"
Write-Output "[TRACE] Deleting temporary folder"

cd ..\..

Remove-Item -LiteralPath "temp" -Force -Recurse

# Pull Request Creation and update
# create common headers
$headers = @{}
$headers.Add("Authorization", "Bearer $env:SYSTEM_ACCESSTOKEN")
$headers.Add("Content-Type", "application/json")

Write-Output "[TRACE] Creating Pull Request"

# Create a Pull Request
$pullRequestUrl = $apisUrl + "/pullrequests?api-version=" + $apiVersion
$pullRequest = @{
        "sourceRefName" = "refs/heads/$adoGitBranchName"
        "targetRefName" = "refs/heads/dev"
        "title" = "Automatic Pull Request: Update EF Core Scaffolding"
        "description" = ""
    }

$pullRequestJson = ($pullRequest | ConvertTo-Json -Depth 5)

Write-Output "[TRACE] Sending a REST call to create a new pull request from $adoGitBranchName to dev"

# REST call to create a Pull Request
$pullRequestResult = Invoke-RestMethod -Method POST -Headers $headers -Body $pullRequestJson -Uri $pullRequestUrl;
$pullRequestId = $pullRequestResult.pullRequestId

Write-Output "[TRACE] Pull request created. Pull Request Id: $pullRequestId"

# Set PR to auto-complete
$setCompleteOptions = @{
    "autoCompleteSetBy" = @{
        "id" = $pullRequestResult.createdBy.id
    }
    "completionOptions" = @{       
        "deleteSourceBranch" = $True
        "bypassPolicy" = $False
        "mergeStrategy" = "rebase"
    }
}

$setCompleteOptionsJson = ($setCompleteOptions | ConvertTo-Json -Depth 5)

Write-Output "[TRACE] Sending a REST call to set auto-complete on the newly created pull request"

# REST call to set auto-complete on Pull Request
$pullRequestUpdateUrl = ($apisUrl + "/pullRequests/" + $pullRequestId + "?api-version=" + $apiVersion)

Write-Output "[TRACE] URL: $pullRequestUpdateUrl"

$setCompleteOptionsResult = Invoke-RestMethod -Method PATCH -Headers $headers -Body $setCompleteOptionsJson -Uri $pullRequestUpdateUrl

Write-Output "[TRACE] Pull request autocompletion added"
Write-Output "[TRACE] Script finished, exiting..."
