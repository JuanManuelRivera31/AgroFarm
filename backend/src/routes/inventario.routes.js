const express = require('express');
const router = express.Router();
const { getInventarios } = require('../controllers/inventarios.controller');

router.get('/', getInventarios);

module.exports = router;
