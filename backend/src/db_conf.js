const mysql = require('mysql2');

// Create db to XAMPP MySQL database
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',        // default XAMPP user
    password: '',        // default XAMPP has no password
    database: 'usthb' // replace with your actual database name
});

// Connect to the database
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to XAMPP MySQL database.');
});

module.exports = db;
