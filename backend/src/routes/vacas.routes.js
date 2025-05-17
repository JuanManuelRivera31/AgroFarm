const { Router } = require('express');
const { getAllVacas, getVaca, createVaca, deleteVaca, updateVaca } = require('../controllers/vacas.controller');

const router = Router();

router.get('/vacas', getAllOrdenios)

router.get('/vacas/:id', getOrdenio)

router.post('/vacas', createOrdenio)

router.delete('/vacas', deleteOrdenio)

router.put('/vacas', updateOrdenio)

module.exports = router;