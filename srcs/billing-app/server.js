require('dotenv').config();
const amqplib = require('amqplib');
const { Order, sequelize } = require('./app/models/order.model');

// Start a consumer that listens to `billing_queue`.
// Whenever a message arrives, parse it and store in the `orders` table.

async function consumeMessages() {
    try {
        // e.g. 'amqp://guest:guest@localhost:5672'
        const connection = await amqplib.connect(`amqp://${process.env.RABBITMQ_USER}:${process.env.RABBITMQ_PASS}@${process.env.RABBITMQ_HOST}:${process.env.RABBITMQ_PORT}`);
        const channel = await connection.createChannel();

        await channel.assertQueue(process.env.RABBITMQ_BILLING_QUEUE);

        // Callback for each message
        channel.consume(process.env.RABBITMQ_BILLING_QUEUE, async (msg) => {
            if (msg !== null) {
                try {
                    const content = JSON.parse(msg.content.toString());
                    // Insert into DB
                    await Order.create(content);
                    console.log("Billing API saved order:", content);
                    channel.ack(msg);
                } catch (err) {
                    console.error("Error parsing or saving order:", err);
                    // Optionally channel.nack(msg) or dead-letter
                }
            }
        });
        console.log("Billing API is consuming messages from the queue...");
    } catch (error) {
        console.error("Error connecting to RabbitMQ:", error);
    }
}

// Sync DB and start listening
sequelize.sync().then(() => {
    console.log("Billing DB synced");
    consumeMessages();
}).catch(err => console.error("Sync error:", err));

// code for health checks
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Billing API is running, but only processes RabbitMQ messages.');
});

const PORT = process.env.BILLING_PORT || 8081;
app.listen(PORT, () => {
    console.log(`Billing API running on port ${PORT}`);
});
