const express = require("express");
const router = express.Router();
const participantController = require("../controllers/participantController");
const authMiddleware = require('../middleware/authMiddleware');


router.post('/', authMiddleware, participantController.createParticipant);
router.post('/check-in', authMiddleware, participantController.checkInParticipant);
router.get('/event/:eventId', authMiddleware, participantController.getParticipantsByEvent);
router.get('/event/:eventId', participantController.getParticipantsByEvent);

router.post('/', participantController.createParticipant);
router.post('/check-in', participantController.checkInParticipant);

module.exports = router;