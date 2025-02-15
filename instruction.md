## 1. Install the Required Software
### Using Windows and PowerShall and virtualbox
### 1.1 Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
```powershell
New-Item -ItemType Directory -Path "F:\V1"
icacls "F:\V1" /reset /t /c
icacls "F:\V1" /inheritance:d /t /c
icacls "F:\V1" /grant "*S-1-5-32-545:(OI)(CI)(RX)"
icacls "F:\V1" /deny  "*S-1-5-32-545:(DE,WD,AD,WEA,WA)"
icacls "F:\V1" /grant "*S-1-5-11:(OI)(CI)(RX)"
icacls "F:\V1" /deny  "*S-1-5-11:(DE,WD,AD,WEA,WA)"
```
- icacls is a Windows command-line tool used to display or modify the access control lists (ACLs) of files and directories.
- S-1-5-32-545: This SID for the built-in Users group
- S-1-5-11: This SID represents the Authenticated Users group
- F:\V1 is reset to a clean, default state
- Inheritance from parent folders is disabled
- The Users and Authenticated Users groups are given safe permissions to read and execute files, while being prevented from making any changes that could compromise security

```powershall
& "F:\V1\VBoxManage.exe" --version
```
### 1.2 Install VMware Workstation [VMware](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)
```powershall
vctl.exe version
```

### 1.3 Install [Vagrant](https://developer.hashicorp.com/vagrant/downloads) (supports VirtualBox by default and expects to interact with VirtualBox’s command-line tool)

### 1.4 Install Node.js Postman Git
```powershall
node -v
npm -v
git -v
```

### 2. CRUD Master Project

This project is structured as follows:
```
├── README.md
├── .env
├── Vagrantfile
├── scripts/
│   ├── gateway-setup.sh
│   ├── inventory-setup.sh
│   ├── billing-setup.sh
│   └── ...
├── srcs/
│   ├── api-gateway/
│   │   ├── package.json
│   │   ├── server.js
│   │   ├── proxy.js
│   │   ├── routes.js
│   │   └── ...
│   ├── inventory-app/
│   │   ├── package.json
│   │   ├── server.js
│   │   └── app/
│   │       ├── config/
│   │       ├── controllers/
│   │       ├── models/
│   │       └── routes/
│   └── billing-app/
│       ├── package.json
│       ├── server.js
│       └── app/
│           ├── config/
│           ├── controllers/
│           ├── models/
│           └── ...
```

PowerShell script creates the folders and empty files for project tree:
```powershell
.\setup.ps1
```

### 3. Set Up Environment Variables

### 4. Write Vagrantfile
- Each VM is isolated and can be started or stopped independently.
- Can be started all together with vagrant up

### 5. Create Provisioning Scripts

#### 5.1  gateway-setup.sh
Install Node.js and PM2.
Copy (or git clone) the api-gateway code into the VM directory.
Install dependencies (npm install).
Export environment variables from Vagrant (already passed in).
Start the application with PM2 (pm2 start server.js --name gateway_app).

#### 5.2 inventory-setup.sh
Install Node.js and PM2.
Install PostgreSQL (if you want the DB on the same VM).
Initialize the movies database and create tables (movies table with id, title, description).
Copy (or git clone) the inventory-app code into the VM directory.
npm install.
Start the Inventory API with PM2 (pm2 start server.js --name inventory_app).

#### 5.3 billing-setup.sh
Install Node.js and PM2.
Install PostgreSQL.
Install RabbitMQ.
Initialize the orders DB and create orders table (id, user_id, number_of_items, total_amount).
Copy (or git clone) the billing-app code into the VM directory.
npm install.
Start the Billing API with PM2 (pm2 start server.js --name billing_app).

### 6. Develop the Inventory API
- Install Express and Sequelize
- In inventory-app/, run 
```powershell
npm init
npm install express sequelize pg pg-hstore
```
- Create a models directory containing a movie.model.js
- Create a controllers movie.controller.js, implementing CRUD

### 7. Develop the Billing API
- Install amqplib (for RabbitMQ):
```powershell
npm install express sequelize pg pg-hstore amqplib
```
- Set up Express in server.js

### 8. Develop the API Gateway
- Install http-proxy-middleware:
```powershell
npm install express http-proxy-middleware amqplib
```
- Set up Express in server.js

### 9. Run and Test Everything with Vagrant
```powershell
vagrant up
vagrant status
```
```powershell
vagrant ssh gateway-vm
vagrant ssh inventory-vm
vagrant ssh billing-vm
```
```powershell
sudo pm2 list
```

### 10. Functional Tests with Postman
```bash
POST http://192.168.56.10:3000/api/movies
```
```json
{
  "title": "A new movie",
  "description": "Very short description"
}
```
```bash
POST http://192.168.56.10:3000/api/billing
```
```json
{
  "user_id": "20",
  "number_of_items": "99",
  "total_amount": "250"
}
```

### 11. Check the Databases via SSH
- Inventory DB
```bash
vagrant ssh inventory-vm
sudo -i -u postgres
psql
\l               # List databases
\c movies        # Switch to movies db
TABLE movies;    # Should see the data with the "A new movie" entry
```
- Billing DB
```bash
vagrant ssh billing-vm
sudo -i -u postgres
psql
\l               # List databases
\c orders        # Switch to orders db
TABLE orders;    # Should see rows inserted from the queue
```

### 12. Validate Queue Resilience with PM2
- Stop the Billing API:
```bash
vagrant ssh billing-vm
sudo pm2 stop billing_app
sudo pm2 list  # verify billing_app is stopped
```

- Send a new order from Postman:
```json
{
  "user_id": "22",
  "number_of_items": "10",
  "total_amount": "50"
}
```
- Check the orders table: Should not show user_id = 22 yet.
- Start the Billing API again:
```bash
sudo pm2 start billing_app
```
- Check the orders table again: Now it should list the user_id = 22 entry after the billing_app processes the stuck messages in the queue.