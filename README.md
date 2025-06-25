# API de Autenticación y Gestión de Usuarios

Este proyecto proporciona una API RESTful para gestionar el registro, login y administración de usuarios. Está diseñada para ser utilizada por diferentes aplicaciones frontend que necesiten un sistema común de autenticación y gestión de usuarios. La API está construida con Node.js y Express, y utiliza una base de datos PostgreSQL para almacenar la información de los usuarios.


## Estructura del global Project IEBS


auth-api/
│
├── config/
│   └── db.config.js        # Configuración de la base de datos PostgreSQL
├── controllers/
│   ├── admin.controller.js  # Controlador de administración de usuarios
│   └── auth.controller.js   # Controlador de registro y login
├── middleware/
│   ├── auth.middleware.js   # Middleware para verificar el token JWT
│   └── role.middleware.js   # Middleware para verificar el rol del usuario
├── models/
│   └── user.model.js        # Modelo de usuario con Sequelize
├── routes/
│   ├── admin.routes.js      # Rutas de administración de usuarios
│   └── auth.routes.js       # Rutas de registro y login
├── server.js                # Punto de entrada de la aplicación
└── .env                     # Archivo de configuración de variables de entorno



## Características

- **Registro de usuarios**: Permite registrar usuarios con un correo electrónico, contraseña (cifrada con bcrypt), nombre y apellido.
- **Autenticación (Login)**: Permite a los usuarios autenticarse mediante JWT (JSON Web Token) para acceder a otros servicios de la API.
- **Gestión de usuarios (Admin)**: Solo los usuarios con rol de "admin" pueden visualizar todos los usuarios registrados y crear nuevos usuarios.
- **Seguridad**: Las contraseñas de los usuarios están cifradas con el algoritmo bcrypt antes de ser almacenadas en la base de datos. Además, la autenticación se realiza mediante tokens JWT, que expiran en una hora.
- **Gestión de roles**: Los usuarios pueden tener roles específicos (por ejemplo, `admin`, `user`). Los administradores pueden gestionar otros usuarios y asignarles roles.

## Requisitos

- **Node.js** (Recomendado: v16 o superior)
- **PostgreSQL** para la base de datos
- **npm** o **yarn** para la gestión de dependencias


## Instalación

1. Clona este repositorio:

   git clone https://github.com/tuusuario/auth-api.git

2. Entra en el directorio del proyecto:
   cd auth-api

3. Instala las dependencias:
   npm install

4. Crea un archivo .env con las variables de entorno necesarias (ejemplo más abajo):

   PORT=3000
   DB_HOST=db
   DB_PORT=5432
   DB_NAME=authdb
   DB_USER=postgres
   DB_PASSWORD=yourpassword
   JWT_SECRET=secretkey123

5. Inicia la base de datos PostgreSQL si aún no está corriendo.

6. Ejecuta la aplicación en desarrollo:
   npm run dev

Esto levantará un servidor en http://localhost:3000.


## Contribuciones
Si deseas contribuir a este proyecto, por favor haz un fork y crea un pull request con tus cambios.

## Licencia
Este proyecto está bajo la Licencia MIT - consulta el archivo LICENSE para más detalles.




### ¿Qué incluye el archivo?

1. **Descripción general del proyecto**: Explica qué hace la API y sus principales características.
2. **Instrucciones de instalación**: Detalles sobre cómo clonar, instalar dependencias y ejecutar la aplicación.
3. **Detalles de los endpoints**: Explicación de las rutas disponibles para el registro, login, gestión de usuarios y acceso administrativo.
4. **Estructura de archivos**: Un desglose de la organización del proyecto.
5. **Licencia y contribuciones**: Una breve mención sobre cómo contribuir al proyecto.

Este `README.md` proporciona un punto de partida claro para cualquier desarrollador que quiera trabajar con la API. ¿Te gustaría agregar algo más?


   
