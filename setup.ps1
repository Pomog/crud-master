# Create root-level files
# New-Item -Path .\README.md -ItemType File -Force
# New-Item -Path .\.env -ItemType File -Force
New-Item -Path .\Vagrantfile -ItemType File -Force
New-Item -Path .\config.yaml -ItemType File -Force

# Create scripts directory (add your script files later as needed)
New-Item -Path .\scripts -ItemType Directory -Force

# Create the srcs directory
New-Item -Path .\srcs -ItemType Directory -Force

# -----------------------------
# Create api-gateway structure
# -----------------------------
$apiGatewayPath = ".\srcs\api-gateway"
New-Item -Path $apiGatewayPath -ItemType Directory -Force
New-Item -Path "$apiGatewayPath\package.json" -ItemType File -Force
New-Item -Path "$apiGatewayPath\proxy.js" -ItemType File -Force
New-Item -Path "$apiGatewayPath\routes.js" -ItemType File -Force
New-Item -Path "$apiGatewayPath\server.js" -ItemType File -Force

# -----------------------------
# Create billing-app structure
# -----------------------------
$billingAppPath = ".\srcs\billing-app"
New-Item -Path $billingAppPath -ItemType Directory -Force
New-Item -Path "$billingAppPath\package.json" -ItemType File -Force
New-Item -Path "$billingAppPath\server.js" -ItemType File -Force

# Create the app directory and its subdirectories for billing-app
$billingAppAppPath = "$billingAppPath\app"
New-Item -Path $billingAppAppPath -ItemType Directory -Force
New-Item -Path "$billingAppAppPath\config" -ItemType Directory -Force
New-Item -Path "$billingAppAppPath\controllers" -ItemType Directory -Force
New-Item -Path "$billingAppAppPath\models" -ItemType Directory -Force

# -----------------------------
# Create inventory-app structure
# -----------------------------
$inventoryAppPath = ".\srcs\inventory-app"
New-Item -Path $inventoryAppPath -ItemType Directory -Force
New-Item -Path "$inventoryAppPath\package.json" -ItemType File -Force
New-Item -Path "$inventoryAppPath\server.js" -ItemType File -Force

# Create the app directory and its subdirectories for inventory-app
$inventoryAppAppPath = "$inventoryAppPath\app"
New-Item -Path $inventoryAppAppPath -ItemType Directory -Force
New-Item -Path "$inventoryAppAppPath\config" -ItemType Directory -Force
New-Item -Path "$inventoryAppAppPath\controllers" -ItemType Directory -Force
New-Item -Path "$inventoryAppAppPath\models" -ItemType Directory -Force
New-Item -Path "$inventoryAppAppPath\routes" -ItemType Directory -Force

Write-Host "Project structure created successfully."
