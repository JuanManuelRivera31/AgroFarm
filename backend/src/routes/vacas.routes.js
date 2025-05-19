const { Router } = require('express');
const { createVaca } = require('../controllers/vacas.controller');

const router = Router();

router.post('/vacas', createVaca)

module.exports = router;