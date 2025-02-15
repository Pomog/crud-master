const express = require('express');
const router = express.Router();
const controller = require('../controllers/controller');

// CREATE
router.post('/', controller.createMovie);

// READ ALL
router.get('/', controller.findAllMovies);

// SEARCH by title
// This is usually a subset of "findAllMovies" if a title query param is present
// We'll handle it in findAllMovies or with a separate route if you prefer.

// DELETE ALL
router.delete('/', controller.deleteAllMovies);

// READ ONE
router.get('/:id', controller.findMovieById);

// UPDATE
router.put('/:id', controller.updateMovie);

// DELETE ONE
router.delete('/:id', controller.deleteMovie);

module.exports = router;