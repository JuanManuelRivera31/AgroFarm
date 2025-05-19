const Image = require('../models/Image');
const fs = require('fs');
const path = require('path');

// SUBIR imagen asociada a una vaca
exports.uploadImage = async (req, res) => {
  try {
    const { idVaca } = req.body;

    if (!idVaca || !req.file) {
      return res.status(400).json({ error: 'Debe enviar el id de la vaca y una imagen' });
    }

    const newImage = new Image({
      imagePath: req.file.path,
      idVaca
    });

    await newImage.save();

    res.status(201).json({
      message: 'Imagen subida exitosamente',
      image: {
        _id: newImage._id,
        url: `${req.protocol}://${req.get('host')}/${newImage.imagePath}`,
        idVaca: newImage.idVaca,
        createdAt: newImage.createdAt
      }
    });
  } catch (error) {
    console.error('Error al subir imagen:', error);
    res.status(500).json({ error: 'Error al subir la imagen' });
  }
};

// ACTUALIZAR imagen existente (opcionalmente reemplaza imagen y/o idVaca)
exports.updateImage = async (req, res) => {
  try {
    const { idVaca } = req.body;
    const { id } = req.params;

    const image = await Image.findById(id);
    if (!image) {
      return res.status(404).json({ message: 'Imagen no encontrada' });
    }

    // Si hay una nueva imagen, eliminar la anterior del sistema de archivos
    if (req.file && image.imagePath) {
      fs.unlink(path.resolve(image.imagePath), err => {
        if (err) console.warn('No se pudo eliminar imagen anterior:', err.message);
      });
      image.imagePath = req.file.path;
    }

    // Actualizar idVaca si se envió
    if (idVaca) {
      image.idVaca = idVaca;
    }

    await image.save();

    res.json({
      message: 'Imagen actualizada correctamente',
      image: {
        _id: image._id,
        url: `${req.protocol}://${req.get('host')}/${image.imagePath}`,
        idVaca: image.idVaca,
        createdAt: image.createdAt
      }
    });
  } catch (error) {
    console.error('Error al actualizar imagen:', error);
    res.status(500).json({ error: 'Error al actualizar la imagen' });
  }
};

// OBTENER imagen por ID de vaca (la más reciente si hay varias)
exports.getImageByVacaId = async (req, res) => {
  try {
    const { idVaca } = req.params;

    const image = await Image.findOne({ idVaca }).sort({ createdAt: -1 });

    if (!image) {
      return res.status(404).json({ message: 'No se encontró imagen para esta vaca' });
    }

    res.json({
      _id: image._id,
      url: `${req.protocol}://${req.get('host')}/${image.imagePath}`,
      idVaca: image.idVaca,
      createdAt: image.createdAt
    });
  } catch (error) {
    console.error('Error al obtener imagen por vaca:', error);
    res.status(500).json({ error: 'Error al obtener la imagen' });
  }
};
