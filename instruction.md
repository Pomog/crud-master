## 1. Install the Required Software
### Using Windows and PowerShall
virtualbox
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

### 3. Set Up Environment Variables
