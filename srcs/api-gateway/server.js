require('dotenv').config();
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const amqplib = require('amqplib');

const app = express();
app.use(express.json());

// Forwards /api/movies to the Inventory VM
app.use('/api/movies', createProxyMiddleware({
    target: `http://192.168.56.11:${process.env.INVENTORY_PORT}`, // inventory-vm IP + port
    changeOrigin: true
}));

// RabbitMQ connection for Billing
app.post('/api/billing', async (req, res) => {
    try {
        const connection = await amqplib.connect(`amqp://${process.env.RABBITMQ_USER}:${process.env.RABBITMQ_PASS}@192.168.56.12:${process.env.RABBITMQ_PORT}`);
        const channel = await connection.createChannel();
        await channel.assertQueue(process.env.RABBITMQ_BILLING_QUEUE);
        await channel.sendToQueue(process.env.RABBITMQ_BILLING_QUEUE, Buffer.from(JSON.stringify(req.body)));
        await channel.close();
        await connection.close();
        res.status(200).json({ message: 'Order sent to billing queue' });
    } catch (error) {
        console.error('Error sending to queue:', error);
        res.status(500).json({ error: 'Cannot send to queue' });
    }
});

const PORT = process.env.GATEWAY_PORT || 3000;
app.listen(PORT, () => {
    console.log(`API Gateway listening on port ${PORT}`);
});