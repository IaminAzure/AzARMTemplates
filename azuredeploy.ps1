Connect-AzAccount -Tenant ''

Select-AzSubscription -Subscription ''

$clientCode = "irs"
$devRg = "azrg-irs-dev-eastus-001"
$stgRg = "azrg-irs-stg-eastus-001"
$prdRg = "azrg-irs-prd-eastus-001"
$location ='East US'

# SQL Deployment
$resourceGroup = New-AzResourceGroup -Name $devRg -Location $location
$suffix = Get-Random -Maximum 1000
$deploymentName = $clientCode + "-sql-deployment-stg" + $suffix
New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName $resourceGroup.ResourceGroupName `
-TemplateFile .\sqldatabase.json `
-TemplateParameterFile .\sqldatabase.parameters.json


# Dev ADF Deployment
$resourceGroup = New-AzResourceGroup -Name $devRg -Location $location -Force
$suffix = Get-Random -Maximum 1000
$deploymentName = $clientCode + "-adf-deployment-dev" + $suffix
New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName $resourceGroup.ResourceGroupName `
-TemplateFile .\azuredatafactory.json `
-TemplateParameterFile .\azuredatafactory.dev-parameters.json


# Stg ADF Deployment
$resourceGroup = New-AzResourceGroup -Name $stgRg -Location $location
$suffix = Get-Random -Maximum 1000
$deploymentName = $clientCode + "-adf-deployment-stg" + $suffix
New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName $resourceGroup.ResourceGroupName `
-TemplateFile .\azuredatafactory.json `
-TemplateParameterFile .\azuredatafactory.stg-parameters.json



# Prod ADF Deployment
$resourceGroup = New-AzResourceGroup -Name $prdRg -Location $location
$suffix = Get-Random -Maximum 1000
$deploymentName = $clientCode + "-adf-deployment-prd" + $suffix
New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName $resourceGroup.ResourceGroupName `
-TemplateFile .\azuredatafactory.json `
-TemplateParameterFile .\azuredatafactory.prd-parameters.json