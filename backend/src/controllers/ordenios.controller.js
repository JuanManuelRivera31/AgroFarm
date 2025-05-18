const pool = require('../db');

const getAllOrdenios = async (req, res) => {
    try {
        const allOrdenios = await pool.query("SELECT * FROM ordenios");
        res.json(allOrdenios.rows);
    } catch (error) {
        console.error(error);
    }
}


const getOrdenio = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query("SELECT * FROM ordenios WHERE id = $1", [id])

        if (result.rows.length === 0) 
            return res.status(404).json({
                message: 'Ordenio not found'
            })
            res.json(result.rows[0]);

        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Internal Server Error' });
        }
    }

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

    const updateOrdenio = (req, res) => {
        res.send('PUT Ordenio');
    }

    const deleteOrdenio = (req, res) => {
        res.send('DELETE Ordenio');
    }

    module.exports = {
        getAllOrdenios,
        getOrdenio,
        createOrdenio,
        updateOrdenio,
        deleteOrdenio
    }

