const pool = require('../db');

const createUsuario = async (req, res) => {
    try {
        const { correo, contrasena, idrol, idpersona } = req.body;

        if (!correo || !contrasena || !idpersona || !idrol) {
            return res.status(400).json({ mensaje: "Faltan datos obligatorios" });
        }

        // Convertir idpersona y idrol a enteros para asegurarte
        const idPersonaInt = parseInt(idpersona);
        const idRolInt = parseInt(idrol);

        if (isNaN(idPersonaInt) || isNaN(idRolInt)) {
            return res.status(400).json({ mensaje: "idpersona o idrol inválidos" });
        }

        // Inserción con transacción (opcional)
        const usuarioResult = await pool.query(
            `INSERT INTO seguridad.usuario (correo, contrasenausuario, idpersona)
             VALUES ($1, $2, $3) RETURNING *`,
            [correo, contrasena, idPersonaInt]
        );

        const idusuario = usuarioResult.rows[0].idusuario;

        await pool.query(
            `INSERT INTO seguridad.usuario_rol (idusuario, idrol) VALUES ($1, $2)`,
            [idusuario, idRolInt]
        );

        res.status(201).json({ usuario: usuarioResult.rows[0] });
    } catch (error) {
        console.error('Error al crear el usuario:', error);
        res.status(500).json({ mensaje: 'Error interno del servidor' });
    }
};


const loginUsuarios = async (req, res) => {
    const { correo, contrasenaUsuario } = req.body;

    try {
        const query = `
            SELECT * FROM seguridad.autenticar_usuario($1, $2);
        `;

        const result = await pool.query(query, [correo, contrasenaUsuario]);

        if (result.rows.length === 0) {
            return res.status(401).json({ message: 'Credenciales inválidas' });
        }

        res.status(200).json({
            message: 'Inicio de sesión exitoso',
            usuario: result.rows[0]
        });
    } catch (error) {
        console.error("Error al iniciar sesión:", error);
        res.status(500).json({ error: "Ocurrió un error al iniciar sesión" });
    }
};

module.exports = {
    loginUsuarios,
    createUsuario
};
