const { Router } = require('express');
const pool = require('../db');
const { getAllOrdenios, getOrdenio, createOrdenio, deleteOrdenio, updateOrdenio } = require('../controllers/ordenios.controller');

const router = Router();

router.get('/ordenios', getAllOrdenios)

router.get('/ordenios/:id', getOrdenio)

router.post('/ordenios', createOrdenio)

router.delete('/ordenios', deleteOrdenio)

router.put('/ordenios', updateOrdenio)

module.exports = router;