const express = require('express');
const router = express.Router();
const upload = require('../middleware/upload');
const imageController = require('../controllers/imageController');

// POST /api/images/upload
// Sube una imagen para una vaca
router.post('/upload', upload.single('photo'), imageController.uploadImage);

// PUT /api/images/:id
// Actualiza una imagen existente (puede cambiar la imagen o el idVaca)
router.put('/:id', upload.single('photo'), imageController.updateImage);

// GET /api/images/vaca/:idVaca
// Obtiene la imagen más reciente asociada a una vaca
router.get('/vaca/:idVaca', imageController.getImageByVacaId);

module.exports = router;
