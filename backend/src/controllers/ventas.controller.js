const pool = require('../db');


const registrarVentaLeche = async (req, res) => {
  try {
    const {
      idcliente,
      cantidadlitros,
      idusuario,
      idinventario,
      idpreciolitro,
      idtipoentrega,
      idmetodopago
    } = req.body;

    if (
      !idcliente || !cantidadlitros || !idusuario || !idinventario ||
      !idpreciolitro || !idtipoentrega || !idmetodopago
    ) {
      return res.status(400).json({ error: 'Faltan campos obligatorios.' });
    }

    await pool.query(
      `CALL comercial.registrar_venta_leche($1, $2, $3, $4, $5, $6, $7)`,
      [
        parseInt(idcliente),
        parseFloat(cantidadlitros),
        parseInt(idusuario),
        parseInt(idinventario),
        parseInt(idpreciolitro),
        parseInt(idtipoentrega),
        parseInt(idmetodopago)
      ]
    );

    res.status(201).json({ message: '✅ Venta registrada y procesada correctamente.' });
  } catch (error) {
    console.error('❌ Error al registrar venta:', error);
    res.status(500).json({ error: error.message || 'Error al registrar la venta' });
  }
};


const listarVentas = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM comercial.vw_ventas_leche ORDER BY fechaventa DESC');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al listar ventas:', error);
    res.status(500).json({ error: 'Error al listar las ventas' });
  }
};

module.exports = {
  registrarVentaLeche, 
  listarVentas
};
