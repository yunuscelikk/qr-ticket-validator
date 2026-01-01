const express = require('express');
const pool = require('./config/db'); 
const initDatabase = require('./services/dbInit');
const eventRoutes = require("./routes/eventRoutes");
require("dotenv").config();

const app = express();
app.use(express.json()); 
app.use("/api/events", eventRoutes);


initDatabase();

app.get('/health', async (req, res) => {
    try {
        await pool.query('SELECT NOW()');
        res.json({ status: "success", message: "Connection valid!" });
    } catch (err) {
        res.status(500).json({ status: "error", error: err.message });
    }
});

app.get('/reset-db', async (req, res) => {
    try {
        await pool.query('DROP TABLE IF EXISTS participants');
        await pool.query('DROP TABLE IF EXISTS events');
        res.send("Tables deleted. restart server");
    } catch (err) {
        res.send("Error: " + err.message);
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port: ${PORT} `);
});