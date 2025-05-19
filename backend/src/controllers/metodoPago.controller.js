const pool = require('../db');

const getMetodosPago = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM comercial.vw_metodos_pago');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener métodos de pago:', error);
    res.status(500).json({ error: 'Error al obtener métodos de pago' });
  }
};

module.exports = { getMetodosPago };
