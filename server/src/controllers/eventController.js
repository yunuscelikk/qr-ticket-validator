const sequelize = require("../config/db");
const { Event } = require('../../models');

const getAllEvents = async (req, res) => {
    try {
        const events = await Event.findAll({
            order: [['event_date', 'ASC']]
        });
        res.status(200).json(events);
    } catch (err) {
        res.status(500).json({error: "Events cant fetch"});
    }
};

const getEventById = async (req, res) => {
    const { eventId } = req.params
    try {
        const event = await Event.findByPk(eventId);
        
        if(!event) {
            return res.status(404).json({error: "Event not found"});
        }

        res.status(200).json(event);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: "Server error"});
    }
};

const createEvent = async (req, res) => {
    const {title, description, event_date, location, image_url} = req.body;
    try {
        const event = await Event.create({
            title,
            description,
            event_date,
            location,
            image_url
        });
        res.status(201).json(event);
    } catch (err) {
        console.error(err)
        res.status(500).json({error: "Event creation failed"})
    }
}
const deleteEvent = async (req, res) => {
     const { id } = req.params;
     try {
        const event = await Event.findByPk(id);
        if (!event) {
            return res.status(404).json({error: "Event not found"});
        }

        await event.destroy();

        res.status(200).json({
            message: "Event deleted successfully",
            deletedEvent: event
        });
     } catch (err) {
        console.error(err);
        res.status(500).json({error: "Server error during deletion"});
     }
};

const updateEvent = async (req, res) => {
    const { id } = req.params
    const {title, description, event_date, location, image_url} = req.body
    try {
        const event = await Event.findByPk(id);

        if (!event) {
            return res.status(404).json({error: "Event not found"});
        }

        await event.update({
            title,
            description,
            event_date,
            location,
            image_url
        });
        res.status(200).json(event);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: "Update failed"});
    }
};

// const getParticipantsByEvent = async (req, res) => {
//     const { eventId } = req.params;
//     try {
//         const result = await pool.query("SELECT * FROM participants WHERE event_id = $1", [eventId]);
//         res.status(200).json(result.rows);
//     } catch (err) {
//         res.status(500).json({error: "Participants cant fetch"});
//     }
// };


module.exports = { getAllEvents, getEventById, createEvent, deleteEvent, updateEvent };