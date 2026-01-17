const sequelize = require("../config/db");
const { Participant } = require("../../models");
const QRCode = require("qrcode");
const { randomUUID: uuidv4 } = require("crypto");

const isValidUUID = (str) => {
  const regex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return regex.test(str);
};

const createParticipant = async (req, res) => {
  try {
    const { event_id, full_name, email } = req.body;
    if (!event_id || !full_name || !email) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const uniqueQrCode = uuidv4();

    const newParticipant = await Participant.create({
      event_id,
      full_name,
      email,
      qr_code: uniqueQrCode,
      checked_in_at: null,
    });

    const qrImage = await QRCode.toDataURL(uniqueQrCode);

    res.status(201).json({
      message: "Participant created successfully",
      data: newParticipant,
      qr_image: qrImage,
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Could not create participant" });
  }
};

const checkInParticipant = async (req, res) => {
  try {
    const { qr_code, event_id } = req.body;

    console.log("QR Code:", qr_code);

    if (!qr_code || !event_id) {
      return res
        .status(400)
        .json({ error: "QR Code and Event ID are required" });
    }
    if (!isValidUUID(qr_code)) {
      console.log("Bad format: not UUID.");
      return res.status(400).json({
        error: "Invalid QR Format!",
      });
    }
    const participant = await Participant.findOne({
      where: { qr_code: qr_code },
    });

    if (!participant) {
      return res.status(404).json({ error: "Ticket not found!" });
    }

    if (participant.event_id != event_id) {
      return res
        .status(403)
        .json({ error: "This ticket belongs to another event!" });
    }

    if (participant.checked_in_at !== null) {
      return res.status(409).json({
        error: "This ticket has already been used!",
        check_in_time: participant.checked_in_at,
      });
    }

    participant.checked_in_at = new Date();
    await participant.save();

    res.status(200).json({
      message: "Login Successful",
      participant: participant,
    });
  } catch (err) {
    console.error("Check-in Error Detail:", err);
    res.status(500).json({ error: "Server error during check-in." });
  }
};

const getParticipantsByEvent = async (req, res) => {
  const { eventId } = req.params;
  try {
    const participants = await Participant.findAll({
      where: {
        event_id: eventId,
      },
    });
    if (participants.length === 0) {
      return res.status(404).json({
        error: "No participants found for this event",
      });
    }
    res.status(200).json(participants);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Could not fetch participants" });
  }
};

module.exports = {
  createParticipant,
  checkInParticipant,
  getParticipantsByEvent,
};
