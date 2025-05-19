const { Router } = require('express');
const { getAllOrdenios, getOrdeniosPorSesion, procesarSesionOrdeno, getSesionesOrdenio, createOrdenio, createSesionOrdenio, deleteOrdenio, updateOrdenio } = require('../controllers/ordenios.controller');

const router = Router();

// Usa rutas más limpias
router.get('/', getAllOrdenios);
// router.get('/:id', getOrdenio);
router.get('/sesion/:idsesionordeno', getOrdeniosPorSesion);
router.get('/sesion', getSesionesOrdenio);
router.post('/', createOrdenio);
router.post('/sesion', createSesionOrdenio);
router.post('/procesar-sesion', procesarSesionOrdeno);
router.delete('/:id', deleteOrdenio); 
router.put('/:id', updateOrdenio);    

module.exports = router;
