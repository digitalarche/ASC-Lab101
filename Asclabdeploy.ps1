
function Show-Disclosure {
      Write-host ""
      Write-Host "    ___   _____ ______   __    ___    ____ " -ForegroundColor Green
      Write-Host "   /   | / ___// ____/  / /   /   |  / __ )" -ForegroundColor Green
      Write-Host "  / /| | \__ \/ /      / /   / /| | / __  |" -ForegroundColor Green
      Write-Host " / ___ |___/ / /___   / /___/ ___ |/ /_/ / " -ForegroundColor Green
      Write-Host "/_/  |_/____/\____/  /_____/_/  |_/_____/  vs 1.0" -ForegroundColor Green
      Write-Host "ASC LAB 101 - A journey to the heart of Cloud security " -ForegroundColor Cyan
      Write-Host "[RTFM - always before!]" -ForegroundColor Red
      Write-host ""
  }

Show-Disclosure
# Get-AzComputeResourceSku | where {$_.Locations -icontains "centralus"}
$location = 'canadacentral'
$resourceGroupName = (New-AzResourceGroup -name AscLab101 -Location $location).ResourceGroupName

Wait-event -Timeout 2
Write-Host -ForegroundColor Cyan "Resource Group $resourceGroupName created... in Location $location"

$PwdSecureString = Read-Host -assecurestring "Please enter the password as you want for your ASC-Lab101 ;)  "
$decodePwdSecureString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PwdSecureString))

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $decodePwdSecureString
$PasswordProfile.ForceChangePasswordNextLogin = "False"
$tenant = (Get-AzureADTenantDetail).verifiedDomains.name

$UPN = "John.Wick@" + $tenant
New-AzureADUser -DisplayName "John Wick" -PasswordProfile $PasswordProfile -UserPrincipalName $UPN -AccountEnabled $true -MailNickName "JWick" -UsageLocation "CA"
$UPN = "Robert.McCall@" + $tenant
New-AzureADUser -DisplayName "Robert McCall" -PasswordProfile $PasswordProfile -UserPrincipalName $UPN -AccountEnabled $true -MailNickName "RMcCall" -UsageLocation "CA"

Write-Host ""
Write-Host -ForegroundColor Cyan "Users were created as well ..."
Wait-event -Timeout 3

Write-Host ""
Write-Host -ForegroundColor Magenta "Deployment started (Take a moment almost 20-30mn) ..."

$outputs = (New-AzResourceGroupDeployment `
      -Name asclab101 `
      -ResourceGroupName $resourceGroupName `
      -TemplateUri https://asclab101.blob.core.windows.net/azuredeploy/azuredeploy-core.json `
      -SecretName $PwdSecureString `
      ).Outputs

Write-Host ""
Write-Host -ForegroundColor Magenta "Deployment finished - copy blob storage in your lab ..."
      
$sourceStorageAccount = 'asclab101'
# Until 30 June 2019 19h45
$sasToken = '?sv=2018-03-28&ss=bf&srt=sco&sp=rl&se=2019-06-30T23:45:07Z&st=2019-02-07T16:45:07Z&spr=https,http&sig=AzZ5PQtUVaQ9Ss0TOdDKLG12JEBvBEJG8%2BIwawCx5Ig%3D'
$sourceStorageContext = New-AzStorageContext –StorageAccountName $sourceStorageAccount -SasToken $sasToken

$sourceStorageContainer = 'labfiles'
$blobs = (Get-AzStorageBlob -Context $sourceStorageContext -Container $sourceStorageContainer)

$destStorageAccount = $outputs.storageAccountName.Value
Write-Host ""
Write-Host "The name of you storage account: " -ForegroundColor Cyan -NoNewline 
Write-Host $outputs.storageAccountName.Value -ForegroundColor Green 

$destStorageKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $destStorageAccount).value[0]
$destStorageContext = New-AzStorageContext –StorageAccountName $destStorageAccount -StorageAccountKey $destStorageKey

$destStorageContainer = (New-AzStorageContainer -Name labfiles -permission Container -context $destStorageContext).name

foreach ($blob in $blobs) {
      Write-Host "Copy $blob.Name" -ForegroundColor Yellow
      Start-AzStorageBlobCopy `
            -Context $sourceStorageContext `
            -SrcContainer $sourceStorageContainer `
            -SrcBlob $blob.name `
            -DestContext $destStorageContext `
            -DestContainer $destStorageContainer `
            -DestBlob $blob.name
}

Write-Host ""
Write-Host "***** ASC-Lab 101 infrastructure is ready ;-) *****" -ForegroundColor Green
Write-Host "Let's Play to go now ... " -ForegroundColor Green
Write-Host ""
Write-Host ""