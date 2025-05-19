const pool = require('../db');
const Image = require('../models/Image'); // modelo de Mongo
const path = require('path');

const createVaca = async (req, res) => {
  try {
    const { nombre, fechanacimiento, raza, observaciones } = req.body;

    const result = await pool.query(
      `SELECT produccion.sp_insertar_vaca($1, $2, $3, $4) AS idvaca`,
      [nombre, fechanacimiento, parseInt(raza), observaciones]
    );

    const idvaca = result.rows[0].idvaca;

    // Si hay imagen, guardarla en Mongo
    if (req.file) {
      const newImage = new Image({
        idVaca: idvaca.toString(),
        imagePath: path.join('uploads', req.file.filename)
      });

      await newImage.save();
    }

    res.status(201).json({
      message: 'Vaca registrada exitosamente',
      idvaca
    });

  } catch (error) {
    console.error('Error al registrar la vaca:', error);
    res.status(500).json({ error: 'Error al registrar la vaca' });
  }
};

module.exports = {
  createVaca
};
