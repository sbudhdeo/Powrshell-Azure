<#
---------------------------------------------------------------------------------
 Description: Create a visualzied graphical image for resources in a Azure
			  Resource Group
 Author: Samir Budhdeo 
 Created: 2023-02-24
---------------------------------------------------------------------------------
 Required Modules
 - Install-Module -Name Az
 GraphViz is also required
---------------------------------------------------------------------------------
 Runtime Varibles for out files, email and sendmail prep 
---------------------------------------------------------------------------------
#>

# Connect to your Azure account
Connect-AzAccount

#Set the Azure subscription
Set-AzContext -SubscriptionId <your id>

# Set the resource group name
$resourceGroupName = "yourRGname"

# Get the servers in the resource group
$servers = Get-AzSqlServer -ResourceGroupName $resourceGroupName

# Create the graphviz script
$graphvizScript = "graph {"

# Loop through each server and add it to the script
foreach ($server in $servers) {
    $serverName = $server.ServerName
    $graphvizScript += "`"$serverName`";"
    
    # Get the databases for the server
    $databases = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName
    
    # Loop through each database and add it to the script
    foreach ($database in $databases) {
        $databaseName = $database.DatabaseName
        $graphvizScript += "`"$databaseName`" -> `"$serverName`";"
    }
}

$graphvizScript += "}"

# Convert the graphviz script to a PNG image
Invoke-Expression "dot -Tpng -ograph.png" $graphvizScript

# Open the image
Invoke-Item "graph.png"
