const { Router } = require('express');
const { getAllOrdenios, getOrdenio, createOrdenio, deleteOrdenio, updateOrdenio } = require('../controllers/ordenios.controller');

const router = Router();

// Usa rutas más limpias
router.get('/', getAllOrdenios);
router.get('/:id', getOrdenio);
router.post('/', createOrdenio);
router.delete('/:id', deleteOrdenio); // mejor con ID
router.put('/:id', updateOrdenio);    // mejor con ID

module.exports = router;
