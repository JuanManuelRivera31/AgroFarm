const express = require('express');
const morgan = require('morgan');
const cors = require('cors');

const ordeniosRoutes = require('./routes/ordenios.routes');
const usuariosRoutes = require('./routes/usuarios.routes');

const app = express();

app.use(morgan('dev'));
app.use(cors());
app.use(express.json());

app.use('/api/usuarios', usuariosRoutes);
app.use('/api/ordenios', ordeniosRoutes);

app.listen(4000)
console.log('Server is running on port 4000');
