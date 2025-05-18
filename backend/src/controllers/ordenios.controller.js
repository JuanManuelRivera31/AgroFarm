const pool = require('../db');

const getAllOrdenios = async (req, res) => {
    try {
        const allOrdenios = await pool.query("SELECT * FROM ordenios");
        res.json(allOrdenios.rows);
    } catch (error) {
        console.error(error);
    }
}


const getOrdeniosPorSesion = async (req, res) => {
  const { idsesionordeno } = req.params;
  try {
    const response = await pool.query(
      'SELECT * FROM produccion.vaca_ordeno WHERE idsesionordeno = $1',
      [idsesionordeno]
    );
    res.json(response.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener ordeños de la sesión' });
  }
};

const createOrdenio = async (req, res) => {
    const { idvaca, idsesionordeno, cantidadleche, hora, observaciones } = req.body;

    try {
        const result = await pool.query(
            `INSERT INTO produccion.vaca_ordeno (idvaca, idsesionordeno, cantidadleche, hora, observaciones)
             VALUES ($1, $2, $3, $4, $5) RETURNING *`,
            [idvaca, idsesionordeno, cantidadleche, hora, observaciones]
        );

        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error("Error al crear el ordeño:", error);
        res.status(500).json({ error: "Ocurrió un error al registrar el ordeño." });
    }
};

const createSesionOrdenio = async (req, res) => {
    const { idusuario, horainicio, horafin, observaciones } = req.body;

    try {
        const result = await pool.query(
            `INSERT INTO produccion.sesion_ordeno (idusuario, horainicio, horafin, observaciones)
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [idusuario, horainicio, horafin, observaciones]
        );

        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error("Error al crear la sesión de ordeño:", error);
        res.status(500).json({ error: "Ocurrió un error al registrar la sesión de ordeño." });
    }
};

const getSesionesOrdenio = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM produccion.sesion_ordeno');
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener sesiones de ordeño:', error);
    res.status(500).json({ error: 'Error al obtener sesiones de ordeño.' });
  }
};

    const updateOrdenio = (req, res) => {
        res.send('PUT Ordenio');
    }

    const deleteOrdenio = (req, res) => {
        res.send('DELETE Ordenio');
    }

    module.exports = {
        getAllOrdenios,
        getOrdeniosPorSesion,
        getSesionesOrdenio,
        createOrdenio,
        createSesionOrdenio,
        updateOrdenio,
        deleteOrdenio
    }

