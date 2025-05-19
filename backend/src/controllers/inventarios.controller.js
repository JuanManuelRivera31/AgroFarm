const pool = require('../db');

const getInventarios = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM inventario.vista_inventarios');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener inventarios:', error);
    res.status(500).json({ error: 'Error al obtener los inventarios' });
  }
};

module.exports = {
  getInventarios
};
