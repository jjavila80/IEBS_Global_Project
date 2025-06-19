const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models');

const app = express();
app.use(express.json());

app.use('/api', require('./routes/auth'));
app.use('/api/admin', require('./routes/admin'));

sequelize.sync().then(() => {
  console.log('Base de datos sincronizada');
});

module.exports = app;

