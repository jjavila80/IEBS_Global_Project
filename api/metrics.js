// /api/metrics.js
const client = require('prom-client');

// Recolectar métricas por defecto del sistema
client.collectDefaultMetrics({ timeout: 5000 });

// Métrica personalizada: duración de peticiones HTTP
const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duración de peticiones HTTP en segundos',
  labelNames: ['method', 'route', 'code'],
  buckets: [0.1, 0.3, 0.5, 1, 2, 5] // segundos
});

// Middleware para medir duración de las peticiones
function metricsMiddleware(req, res, next) {
  const end = httpRequestDurationSeconds.startTimer();
  res.on('finish', () => {
    end({
      method: req.method,
      route: req.route?.path || req.originalUrl,
      code: res.statusCode
    });
  });
  next();
}

// Endpoint para Prometheus
async function metricsEndpoint(req, res) {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
}

module.exports = {
  metricsMiddleware,
  metricsEndpoint,
};

