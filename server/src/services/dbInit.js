const pool = require("../config/db");

const initDatabase = async () => {
    const queries = `
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP      
        );

        CREATE TABLE IF NOT EXISTS events (
            id SERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            event_date TIMESTAMP,
            location VARCHAR(255),
            image_url TEXT
        );

        CREATE TABLE IF NOT EXISTS participants (
            id SERIAL PRIMARY KEY,
            event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
            full_name VARCHAR(255) NOT NULL,
            email VARCHAR(255) 
        );    
    `;
    try {
        await pool.query(queries);
        console.log("Tables successfully created or already available");
    } catch (err) {
        console.error("Table creation error", err);
        process.exit(1);
    }
};

module.exports = initDatabase;