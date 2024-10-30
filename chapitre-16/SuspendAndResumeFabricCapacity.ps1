Param(
    [string]$ResourceID, # e.g. "/subscriptions/12345678-1234-1234-1234-123a12b12d1c/resourceGroups/fabric-rg/providers/Microsoft.Fabric/capacities/myf2capacity"
    [string]$operation # "suspend" or "resume"
)

#$ResourceID = "/subscriptions/12345678-1234-1234-1234-123a12b12d1c/resourceGroups/fabric-rg/providers/Microsoft.Fabric/capacities/myf2capacity"
#$operation = "suspend" 
#$operation = "resume"

Connect-AzAccount -Identity

$tokenObject = Get-AzAccessToken -ResourceUrl "https://management.azure.com/"
$token = $tokenObject.Token

$azContext = Get-AzContext
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$tokenObject = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
$token = $tokenObject.AccessToken

$url = "https://management.azure.com$ResourceID/$operation" + "?api-version=2022-07-01-preview"
Write-Output $url

$headers = @{
    'Content-Type' = 'application/json'
    'Authorization' = "Bearer $token"
}

$response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers

$response