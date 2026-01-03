const express = require('express');
const sequelize = require('./config/db'); 
const eventRoutes = require("./routes/eventRoutes");
const userRoutes = require("./routes/userRoutes");
require("dotenv").config();

const app = express();
app.use(express.json()); 

app.use("/api/events", eventRoutes);
app.use("/api/users", userRoutes);

(async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connected successfully');
  } catch (error) {
    console.error('Unable to connect to database:', error);
  }
})();

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// app.get('/reset-db', async (req, res) => {
//     try {
//         await pool.query('DROP TABLE IF EXISTS participants');
//         await pool.query('DROP TABLE IF EXISTS events');
//         res.send("Tables deleted. restart server");
//     } catch (err) {
//         res.send("Error: " + err.message);
//     }
// });

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port: ${PORT} `);
});