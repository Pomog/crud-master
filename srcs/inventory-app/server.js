require('dotenv').config(); // if you want to load local .env in dev
const express = require('express');
const { sequelize } = require('./app/models/model');
const moviesRoutes = require('./app/routes/movies.routes');

const app = express();
app.use(express.json());

// (Optional) Sync with the database on startup (only do this if you want to auto-create tables)
sequelize.sync()
    .then(() => {
        console.log("Database synced successfully.");
    })
    .catch((err) => {
        console.error("Unable to sync DB:", err);
    });

// Use the routes
app.use('/api/movies', moviesRoutes);

// Start server
const PORT = process.env.INVENTORY_PORT || 8080;
app.listen(PORT, () => {
    console.log(`Inventory API running on port ${PORT}`);
});