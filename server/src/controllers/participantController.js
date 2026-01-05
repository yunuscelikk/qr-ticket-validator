const sequelize = require("../config/db");
const { Participant } = require("../../models");

const getAllParticipants = async (req, res) => {
    // tüm katılımcıları getir
}

const createParticipant = async (req, res) => {
    // katılımcı oluştur
}

const getParticipantsByEvent = async (req, res) => {
    const { eventId } = req.params;
    try {
        const participants = await Participant.findAll({
            where: {
                event_id: eventId
            }
        });
        if (participants.length === 0) {
            return res.status(404).json({
                error: "No participants found for this event"
            });
        }
        res.status(200).json(participants)
        
    } catch (err) {
        console.log(err)
        res.status(500).json({error: "Could not fetch participants"});
    }
};

module.exports = { getParticipantsByEvent }