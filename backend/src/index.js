const express = require('express');
const morgan = require('morgan');

const ordeniosRoutes = require('./routes/ordenios.routes');

const app = express();

app.use(morgan('dev'));
app.use(express.json());

app.use(ordeniosRoutes)

app.listen(4000)
console.log('Server is running on port 4000');
