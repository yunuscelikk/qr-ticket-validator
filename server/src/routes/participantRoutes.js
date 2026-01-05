const express = require("express");
const router = express.Router();
const eventController = require("../controllers/eventController")
const participantController = require("../controllers/participantController")

router.get("/:eventId/participants", eventController.getParticipantsByEvent);
router.get();

router.post();

router.delete();
