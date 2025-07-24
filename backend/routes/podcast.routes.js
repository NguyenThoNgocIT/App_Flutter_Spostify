const express = require("express");
const router = express.Router();
const podcastController = require("../controllers/PodcastController");

router.get("/", podcastController.getPodcasts);

module.exports = router;
