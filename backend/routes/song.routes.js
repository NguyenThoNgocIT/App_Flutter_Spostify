const express = require('express');
const router = express.Router();
const songController = require('../controllers/song.controller');

router.get('/', songController.getSongs);

module.exports = router;
