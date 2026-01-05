const sequelize = require("../config/db");
const { Participant } = require("../../models");
const QRCode = require('qrcode');
const { randomUUID: uuidv4 } = require('crypto');

const createParticipant = async (req, res) => {
    try {
        const { event_id, full_name, email } = req.body;
        if (!event_id || !full_name || !email) {
            return res.status(400).json({error: "All fields are required"});
        }

        const uniqueQrCode = uuidv4();

        const newParticipant = await Participant.create({
            event_id,
            full_name,
            email,
            qr_code: uniqueQrCode,
            checked_in_at: null
        });

        const qrImage = await QRCode.toDataURL(uniqueQrCode);

        res.status(201).json({
            message: "Participant created successfully",
            data: newParticipant,
            qr_image: qrImage
        });
    } catch (err) {
        console.log(err)
        res.status(500).json({error: "Could not create participant"});
    }
};
const checkInParticipant = async (req, res) => {
    const { qr_code, event_id } = req.body;

    try {
        const participant = await Participant.findOne({
            where: { qr_code: qr_code}
        });

        if (!participant) {
            return res.status(404).json({error: "Invalid QR Code / Participant not found"});
        }

        if (participant.event_id != event_id) {
            return res.status(403).json({error: "This ticket is for a different event!"});
        }

        if (participant.checked_in_at !== null) {
            return res.status(409).json({
                error: "Participant already checked in!",
                check_in_time: participant.checked_in_at
            });
        }

        participant.checked_in_at = new Date();
        await participant.save();

        res.status(200).json({
            message: "Check-in successful",
            participant: participant
        });
    } catch (err) {
        console.log(err),
        res.status(500).json({error: "Check-in process failed"});
    }
};

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


module.exports = { createParticipant, checkInParticipant, getParticipantsByEvent }