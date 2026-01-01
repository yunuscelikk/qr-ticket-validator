const express = require("express");
const router = express.Router();
const eventController = require("../controllers/eventController");

router.get("/", eventController.getAllEvents);
router.get("/:eventId/participants", eventController.getParticipantsByEvent);

router.post("/", eventController.createEvent);

router.delete("/:id", eventController.deleteEvent);

module.exports = router;