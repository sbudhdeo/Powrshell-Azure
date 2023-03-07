<#
---------------------------------------------------------------------------------
 Description: Create a public IP in Azure
 Author: Samir Budhdeo 
 Created: 2023-03-07
---------------------------------------------------------------------------------
 Required Modules
 - Install-Module -Name Az
---------------------------------------------------------------------------------
 Runtime Varibles for out files, email and sendmail prep 
---------------------------------------------------------------------------------
#>

#Set the Azure subscription
Set-AzContext -SubscriptionId <your id>

# Define variables for the resource group name and public IP address name
$resourceGroupName = "yourRGname"
$publicIpName = "nameofPublicIP"
$smtpServer = "smtp.server.com"
$sender = "noreply@server.com"
$recipient = "admin@server.com"

# Create a new public IP address object with default settings
$publicIp = New-AzPublicIpAddress `
  -ResourceGroupName $resourceGroupName `
  -Name $publicIpName `
  -AllocationMethod Static `
  -Location 'West US 2'`
  -Sku Standard

# Check if the public IP address creation was successful
if ($publicIp.ProvisioningState -eq "Succeeded") {
    # Format the JSON output of the public IP address
    $publicIpJson = ConvertTo-Json $publicIp -Depth 100

    # Define variables for the email parameters
    $subject = "New Public IP Address Created in $resourceGroupName"
    $body = "A new public IP address has been created in $resourceGroupName. Details of the public IP address are as follows:`r`n`r`n$publicIpJson`r`n`r`nThe creation of the public IP address was successful."
} else {
    # Define variables for the email parameters
    $subject = "Error Creating Public IP Address in $resourceGroupName"
    $body = "An error occurred while creating the public IP address in $resourceGroupName. The error message is as follows:`r`n`r`n$($publicIp.Error.Message)`r`n`r`nPlease check the Azure portal for more information about the error."
}

# Send the email notification
Send-MailMessage `
  -SmtpServer $smtpServer `
  -From $sender `
  -To $recipient `
  -Subject $subject `
  -Body $body `
  -BodyAsHtml
