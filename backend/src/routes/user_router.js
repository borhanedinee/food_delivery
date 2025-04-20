const express = require('express');

const userRouter = express.Router();

const { getUser, createUser, updateUser, deleteUser } = require('../controllers/user_controller');

// Define the routes for user operations
userRouter.get('/', getUser); // Get all users
userRouter.post('/', createUser); // Create a new user
userRouter.put('/:id', updateUser); // Update a user by ID
userRouter.delete('/:id', deleteUser); // Delete a user by ID

// Export the user router to be used in the main app
module.exports = userRouter;

