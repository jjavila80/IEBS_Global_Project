const app = require('./app');
const PORT = process.env.PORT || 3000;
console.log("Arrancando servidor...");


app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});

