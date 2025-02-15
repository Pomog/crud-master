Vagrant.configure("2") do |config|
  # Import environment variables from .env
  env_variables = {}
  File.readlines(".env").each do |line|
    key, value = line.strip.split("=", 2)
    env_variables[key] = value if key && value
  end

  # Gateway VM
  config.vm.define "gateway-vm" do |gateway|
    gateway.vm.box = "ubuntu/focal64"
    gateway.vm.network "private_network", ip: "192.168.56.10"
    gateway.vm.hostname = "gateway-vm"

    gateway.vm.provision "shell", path: "scripts/gateway-setup.sh", env: env_variables
  end

  # Inventory VM
  config.vm.define "inventory-vm" do |inventory|
    inventory.vm.box = "ubuntu/focal64"
    inventory.vm.network "private_network", ip: "192.168.56.11"
    inventory.vm.hostname = "inventory-vm"

    inventory.vm.provision "shell", path: "scripts/inventory-setup.sh", env: env_variables
  end

  # Billing VM
  config.vm.define "billing-vm" do |billing|
    billing.vm.box = "ubuntu/focal64"
    billing.vm.network "private_network", ip: "192.168.56.12"
    billing.vm.hostname = "billing-vm"

    billing.vm.provision "shell", path: "scripts/billing-setup.sh", env: env_variables
  end
end