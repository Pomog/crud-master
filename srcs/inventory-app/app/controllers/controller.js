const { Movie } = require('../models/model');

// CREATE
exports.createMovie = async (req, res) => {
    try {
        const { title, description } = req.body;
        if (!title || !description) {
            return res.status(400).json({ message: "title and description are required" });
        }
        const newMovie = await Movie.create({ title, description });
        return res.status(201).json(newMovie);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// READ ALL (and optional search by title)
exports.findAllMovies = async (req, res) => {
    try {
        const { title } = req.query;
        let condition = {};
        if (title) {
            // Use Sequelize operators, or simple substring matching
            condition = {
                where: {
                    title: {
                        [require('sequelize').Op.iLike]: `%${title}%`
                    }
                }
            };
        }
        const movies = await Movie.findAll(condition);
        return res.status(200).json(movies);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// READ ONE
exports.findMovieById = async (req, res) => {
    try {
        const { id } = req.params;
        const movie = await Movie.findByPk(id);
        if (!movie) {
            return res.status(404).json({ message: "Movie not found" });
        }
        return res.status(200).json(movie);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// UPDATE
exports.updateMovie = async (req, res) => {
    try {
        const { id } = req.params;
        const { title, description } = req.body;
        const movie = await Movie.findByPk(id);
        if (!movie) {
            return res.status(404).json({ message: "Movie not found" });
        }
        movie.title = title || movie.title;
        movie.description = description || movie.description;
        await movie.save();
        return res.status(200).json(movie);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// DELETE ONE
exports.deleteMovie = async (req, res) => {
    try {
        const { id } = req.params;
        const deleted = await Movie.destroy({ where: { id } });
        if (!deleted) {
            return res.status(404).json({ message: "Movie not found" });
        }
        return res.status(200).json({ message: "Movie deleted successfully" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// DELETE ALL
exports.deleteAllMovies = async (req, res) => {
    try {
        await Movie.destroy({ where: {} });
        return res.status(200).json({ message: "All movies deleted successfully" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};