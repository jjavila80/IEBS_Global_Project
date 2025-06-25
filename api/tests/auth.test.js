const request = require('supertest');
const app = require('../app');
const { User } = require('../models');  // Ajusta la ruta si es distinta
const bcrypt = require('bcrypt');

describe('🧪 Pruebas de Autenticación y Seguridad de la API', () => {
  const email = `test${Date.now()}@mail.com`;
  const password = 'testpass123';

  // Crear usuario admin antes de todos los tests
  beforeAll(async () => {
    // Encriptar password para admin
    const hashedPassword = await bcrypt.hash('adminpass', 10);

    // Crear o buscar admin
    await User.findOrCreate({
      where: { email: 'admin@example.com' },
      defaults: {
        password: hashedPassword,
        role: 'admin',
        nombre: 'Admin',
        apellido: 'User'
      }
    });
  });

  // Registro exitoso
  it('✅ Registro exitoso', async () => {
    const res = await request(app).post('/api/register').send({
      email,
      password,
      nombre: 'Test',
      apellido: 'User'
    });
    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('userId');
  });

  // Registro duplicado
  it('⚠️ Registro duplicado devuelve error 409', async () => {
    const res = await request(app).post('/api/register').send({
      email,
      password,
      nombre: 'Test',
      apellido: 'User'
    });
    expect(res.statusCode).toBe(409);
  });

  // Registro con datos inválidos
  it('❌ Registro con datos inválidos devuelve 400', async () => {
    const res = await request(app).post('/api/register').send({
      email: 'correo_no_valido',
      password: '123',
      nombre: '',
      apellido: ''
    });
    expect(res.statusCode).toBe(400);
  });

  // Login con credenciales erróneas
  it('❌ Login falla con credenciales erróneas', async () => {
    const res = await request(app).post('/api/login').send({
      email: 'fake@email.com',
      password: 'wrongpass'
    });
    expect(res.statusCode).toBe(401);
  });

  // Login exitoso
  let userToken;
  it('✅ Login correcto devuelve token', async () => {
    const res = await request(app).post('/api/login').send({
      email,
      password
    });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('token');
    userToken = res.body.token;
  });

  // Acceso a ruta protegida como usuario normal
  it('🔒 Ruta admin devuelve 403 si no eres admin', async () => {
    const res = await request(app)
      .get('/api/admin/users')
      .set('Authorization', `Bearer ${userToken}`);
    expect(res.statusCode).toBe(403);
  });

  // Crear usuario como admin
  it('✅ Crear usuario como admin', async () => {
    // Login admin para obtener token
    const loginAdmin = await request(app).post('/api/login').send({
      email: 'admin@example.com',
      password: 'adminpass'
    });

    expect(loginAdmin.statusCode).toBe(200);
    expect(loginAdmin.body).toHaveProperty('token');

    const token = loginAdmin.body.token;

    const res = await request(app)
      .post('/api/admin/users')
      .set('Authorization', `Bearer ${token}`)
      .send({
        email: `newuser${Date.now()}@mail.com`,
        password: 'newpass123',
        nombre: 'Nuevo',
        apellido: 'Usuario'
      });

    expect(res.statusCode).toBe(201);
  });

  // Cierra la conexión a la base de datos para que Jest termine
  afterAll(async () => {
    await sequelize.close();
  });
});


