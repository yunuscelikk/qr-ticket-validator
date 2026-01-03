const pool = require("../config/db");

const getAllUsers = async (req, res) => {
    try {
        const result = await pool.query("SELECT * FROM users ORDER BY created_at ASC");
        res.status(200).json(result.rows);
    } catch(err) {
        res.status(500).json({error: "Users cant fetch"});
    }
}

module.exports = {getAllUsers};