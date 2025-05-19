const express = require('express');
const router = express.Router();
const { getPreciosLitro } = require('../controllers/precios.controller');

router.get('/', getPreciosLitro);
module.exports = router;