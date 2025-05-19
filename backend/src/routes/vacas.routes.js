const express = require('express');
const router = express.Router();
const { createVaca } = require('../controllers/vacas.controller');
const upload = require('../middleware/upload');

router.post('/', upload.single('imagen'), createVaca);

module.exports = router;