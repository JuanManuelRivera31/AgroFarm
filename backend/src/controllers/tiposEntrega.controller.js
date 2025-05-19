const pool = require('../db');

const getTiposEntrega = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM comercial.vw_tipos_entrega');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener tipos de entrega:', error);
    res.status(500).json({ error: 'Error al obtener tipos de entrega.' });
  }
};

module.exports = { getTiposEntrega };
