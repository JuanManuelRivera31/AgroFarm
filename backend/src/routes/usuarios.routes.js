const express = require('express');
const router = express.Router();
const { loginUsuarios, createUsuario } = require('../controllers/usuarios.controller');

router.post('/login', loginUsuarios);
router.post('/createUsuario', createUsuario); // Esta es la que espera el frontend

module.exports = router;