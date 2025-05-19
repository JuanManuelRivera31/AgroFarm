const express = require('express');
const morgan = require('morgan');
const connectToMongo = require('./mongo');
const cors = require('cors');
const path = require('path');

const ordeniosRoutes = require('./routes/ordenios.routes');
const usuariosRoutes = require('./routes/usuarios.routes');
const imagesRoutes = require('./routes/img.routes');

const app = express();

app.use(morgan('dev'));
app.use(cors());
app.use(express.json());

// Rutas
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/ordenios', ordeniosRoutes);
app.use('/api/images', imagesRoutes);

// Servir imágenes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Conexión a Mongo
connectToMongo();

const PORT = 4000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
