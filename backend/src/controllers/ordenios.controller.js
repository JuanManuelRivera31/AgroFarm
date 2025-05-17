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
        const { id, name } = req.body;

        try {
            const result = await pool.query(
                "INSERT INTO ordenios (id, name) VALUES ($1, $2) RETURNING *",
                [id, name]
            );

            res.json(result.rows[0]);
        } catch (error) {
            res.send({ error: error.message });
        }
    }

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

