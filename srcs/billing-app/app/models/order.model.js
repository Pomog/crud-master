const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize(
    process.env.ORDERS_DB,
    process.env.POSTGRES_USER,
    process.env.POSTGRES_PASSWORD,
    {
        host: process.env.POSTGRES_HOST,
        dialect: 'postgres'
    }
);

const Order = sequelize.define('Order', {
    user_id: { type: DataTypes.STRING, allowNull: false },
    number_of_items: { type: DataTypes.STRING, allowNull: false },
    total_amount: { type: DataTypes.STRING, allowNull: false },
});

module.exports = { Order, sequelize };