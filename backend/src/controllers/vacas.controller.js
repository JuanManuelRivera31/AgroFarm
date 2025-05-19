const pool = require('../db');

const createVaca = async (req, res) => {
    try {
        const { nombre, raza, edad, peso, observaciones } = req.body;

        const result = await pool.query(
            `INSERT INTO produccion.vaca (nombre, raza, edad, peso, observaciones)
             VALUES ($1, $2, $3, $4, $5) RETURNING *`,
            [nombre, raza, edad, peso, observaciones]
        );

        res.status(201).json({
            message: 'Vaca registrada exitosamente',
            vaca: result.rows[0]
        });
    } catch (error) {
        console.error('Error al registrar la vaca:', error);
        res.status(500).json({ error: 'Error al registrar la vaca' });
    }
};

module.exports = {
    createVaca
};