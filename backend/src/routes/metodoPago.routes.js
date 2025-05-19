const express = require('express');
const router = express.Router();
const { getMetodosPago } = require('../controllers/metodoPago.controller');

router.get('/', getMetodosPago);
module.exports = router;
