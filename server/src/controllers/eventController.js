const pool = require('../config/db');

const getAllEvents = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM events ORDER BY event_date ASC');
        res.status(200).json(result.rows);
    } catch (err) {
        res.status(500).json({error: "Events cant fetch"});
    }
};

const getEventById = async (req, res) => {
    const { eventId } = req.params
    try {
        const result = await pool.query("SELECT * FROM events WHERE id = $1", [eventId]);

        if (result.rows.length === 0) {
            return res.status(404).json({error: "Event not found"});
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({error: "Server error"});
    }
}

const getParticipantsByEvent = async (req, res) => {
    const { eventId } = req.params;
    try {
        const result = await pool.query("SELECT * FROM participants WHERE event_id = $1", [eventId]);
        res.status(200).json(result.rows);
    } catch (err) {
        res.status(500).json({error: "Participants cant fetch"});
    }
};

const createEvent = async (req, res) => {
    const {title, description, event_date, location, image_url} = req.body;
    try {
        const result = await pool.query("INSERT INTO events (title, description, event_date, location, image_url) VALUES ($1, $2, $3, $4, $5) RETURNING *",
            [title, description, event_date, location, image_url]
        );
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: "Event creation failed"});
    }
}

const deleteEvent = async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query(
            "DELETE FROM events WHERE id = $1 RETURNING *",
            [id]
        );
        if (result.rowCount === 0) {
            return res.status(404).json({error: "Event not found"});
        }
        res.status(200).json({
            message: "Event deleted succesfully",
            deletedEvent: result.rows[0]
        });
    } catch(err) {
        console.error(err);
        res.status(500).json({error: "Server error during deletion"});
    }
}

const updateEvent = async (req,res) => {
    const { id } = req.params;
    const { title, description, event_date, location, image_url } = req.body;

    try {
        const result = await pool.query(
            "UPDATE events SET title = $1, description = $2, event_date = $3, location = $4, image_url = $5 WHERE id = $6 RETURNING *",
            [title, description, event_date, location, image_url, id]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({error: "Event not found"});
        }

        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: "Update failed"});
    }
}

module.exports = { getAllEvents, getParticipantsByEvent, createEvent, deleteEvent, updateEvent, getEventById};