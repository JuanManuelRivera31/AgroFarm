const express = require('express');
const router = express.Router();
const { registrarVentaLeche, listarVentas } = require('../controllers/ventas.controller');

router.post('/', registrarVentaLeche);
router.get('/', listarVentas);

module.exports = router;
