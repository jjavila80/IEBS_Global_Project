const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models');
const { metricsMiddleware, metricsEndpoint } = require('./metrics'); //importa métricas
const app = express();
app.use(express.json());

//middleware de métricas
app.use(metricsMiddleware);

//rutas de la API
app.use('/api', require('./routes/auth'));
app.use('/api/admin', require('./routes/admin'));

//endpoint de metricas para Prometheus
app.get('/metrics', metricsEndpoint);

//sincronizacion con BBDD
sequelize.sync().then(() => {
  console.log('Base de datos sincronizada');
});

module.exports = app;

