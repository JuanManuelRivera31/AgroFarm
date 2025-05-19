const express = require('express');
const router = express.Router();
const { getTiposEntrega } = require('../controllers/tiposEntrega.controller');

router.get('/', getTiposEntrega);
module.exports = router;