const pool = require('../db');

const getPreciosLitro = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM comercial.vw_precios_litro ORDER BY fecha DESC');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener precios por litro:', error);
    res.status(500).json({ error: 'Error al obtener los precios.' });
  }
};

module.exports = { getPreciosLitro };
