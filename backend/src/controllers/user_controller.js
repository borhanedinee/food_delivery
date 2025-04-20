const db = require('../db_conf.js');

// Get all users
const getUser = (req, res) => {
    try {
        db.query('SELECT * FROM user', (err, results) => {
            if (err) {
                console.error('Error fetching users:', err);
                res.status(500).json({ error: 'Internal server error' });
                return;
            }
            res.json(results);
        });
    } catch (error) {
        res.status(500).json({ error: 'Unexpected server error' });
    }
}

// Create a new user
const createUser = (req, res) => {
    const { user_fullname, user_phone, user_email, user_password } = req.body;

    if (!user_fullname || !user_phone || !user_email || !user_password) {
        res.status(400).json({ error: 'Missing required fields' });
        return;
    }

    const sql = 'INSERT INTO user (user_fullname, user_phone, user_email, user_password) VALUES (?, ?, ?, ?)';
    db.query(sql, [user_fullname, user_phone, user_email, user_password], (err, result) => {
        if (err) {
            console.error('Error creating user:', err);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }
        res.status(201).json({ message: 'User created successfully', userId: result.insertId });
    });
}

// Delete a user by ID
const deleteUser = (req, res) => {
    const { id } = req.params;

    const sql = 'DELETE FROM user WHERE user_id = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error deleting user:', err);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).json({ message: 'User not found' });
        } else {
            res.json({ message: 'User deleted successfully' });
        }
    });
}

// Update a user by ID
const updateUser = (req, res) => {
    const { id } = req.params;
    const { user_fullname, user_phone, user_email, user_password } = req.body;

    const sql = `
        UPDATE user
        SET user_fullname = ?, user_phone = ?, user_email = ?, user_password = ?
        WHERE user_id = ?
    `;

    db.query(sql, [user_fullname, user_phone, user_email, user_password, id], (err, result) => {
        if (err) {
            console.error('Error updating user:', err);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).json({ message: 'User not found' });
        } else {
            res.json({ message: 'User updated successfully' });
        }
    });
}

// Export all controllers
module.exports = {
    getUser,
    createUser,
    deleteUser,
    updateUser
};
