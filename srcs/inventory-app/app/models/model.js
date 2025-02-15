const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize(process.env.MOVIES_DB, process.env.POSTGRES_USER, process.env.POSTGRES_PASSWORD, {
    host: process.env.POSTGRES_HOST,
    dialect: 'postgres'
});

const Movie = sequelize.define('Movie', {
    title: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.TEXT, allowNull: false },
});

module.exports = { Movie, sequelize };