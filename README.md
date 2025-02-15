# crud-master
gateway, inventory, billing

For detailed installation and setup instructions, please refer to the [Instruction Manual](instruction.md).

## Technologies Used
Node.js, Express, PostgreSQL, RabbitMQ, PM2, Vagrant, VirtualBox.

## How to Run
- **Prerequisites:** Vagrant, VirtualBox, Postman.
- Run the following commands from the project root:
  ```powershell
  vagrant up
  vagrant status
  ```
  
## Project Structure
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

## Setup Instructions
1. Set Up Environment Variables:
- Create a .env file at the root with all necessary credentials (e.g., database names, user credentials, ports).

2. Configure Vagrant:
- The Vagrantfile defines three VMs:
- gateway-vm for the API Gateway
- inventory-vm for the Inventory API and movies database
- billing-vm for the Billing API, orders database, and RabbitMQ
3. Provisioning Scripts:
- The scripts/ folder contains:
- gateway-setup.sh: Installs Node.js, PM2, and sets up the API Gateway.
- inventory-setup.sh: Installs Node.js, PM2, PostgreSQL, and sets up the Inventory API.
- billing-setup.sh: Installs Node.js, PM2, PostgreSQL, RabbitMQ, and sets up the Billing API.
4. Develop and Run Services:
- Inventory API: Implements CRUD operations for movies.
- Billing API: Consumes RabbitMQ messages to process billing orders.
- API Gateway: Proxies requests to the Inventory API and sends billing orders to RabbitMQ.
5. Functional Testing:
- Use Postman to test the endpoints:
```
POST http://192.168.56.10:3000/api/movies to add a movie.
GET http://192.168.56.10:3000/api/movies to retrieve movies.
POST http://192.168.56.10:3000/api/billing to send a billing order.
```
6. Database Verification:
- SSH into the VMs and use psql to check the movies and orders databases.
7. Queue Resilience Testing:
- Stop the Billing API with PM2, send a billing order, then restart the Billing API to verify that queued messages are processed.
