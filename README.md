# 🛡️ API de Autenticación y Gestión de Usuarios

Este proyecto proporciona una API RESTful de autenticación centralizada que permite a múltiples aplicaciones web compartir un sistema común de registro e inicio de sesión. Está diseñado para que distintos frontends puedan utilizar un único backend para gestionar usuarios.

---

## 🌐 Objetivo del Proyecto

- Sistema de login/registro único y centralizado
- Cifrado seguro de contraseñas con `bcrypt`
- Gestión de usuarios por parte del administrador
- Panel de métricas con Prometheus + Grafana
- Tests automatizados con cobertura

---

## 📁 Estructura del Proyecto

├── api/ # Código fuente de la API
│ ├── app.js # Configuración principal de Express y middleware
│ ├── server.js # Punto de entrada que inicia el servidor
│ ├── metrics.js # Configuración y exposición de métricas Prometheus
│ ├── routes/ # Definición de rutas para API (auth, admin, etc.)
│ ├── controllers/ # Lógica de negocio y controladores de endpoints
│ ├── models/ # Modelos Sequelize para base de datos PostgreSQL
│ ├── middlewares/ # Middlewares (JWT, roles, validaciones)
│ ├── tests/ # Tests unitarios e integrados con Jest y Supertest
│ └── coverage/ # Reportes de cobertura de pruebas Jest
├── k8s/ # Manifiestos Kubernetes para despliegue
├── eks/ # Políticas IAM para EKS y permisos administrativos
├── terraform/ # Código para infraestructura como código (Terraform)
├── Dockerfile # Imagen Docker para la API
├── docker-compose.yml # Configuración para levantar API + Postgres en local
└── README.md # Documentación del proyecto



## Características

- **Registro de usuarios**: Permite registrar usuarios con un correo electrónico, contraseña (cifrada con bcrypt), nombre y apellido.
- **Autenticación (Login)**: Permite a los usuarios autenticarse mediante JWT (JSON Web Token) para acceder a otros servicios de la API.
- **Gestión de usuarios (Admin)**: Solo los usuarios con rol de "admin" pueden visualizar todos los usuarios registrados y crear nuevos usuarios.
- **Seguridad**: Las contraseñas de los usuarios están cifradas con el algoritmo bcrypt antes de ser almacenadas en la base de datos. Además, la autenticación se realiza mediante tokens JWT, que expiran en una hora.
- **Gestión de roles**: Los usuarios pueden tener roles específicos (por ejemplo, `admin`, `user`). Los administradores pueden gestionar otros usuarios y asignarles roles.



---

## 🧰 Tecnologías

- **Node.js** + **Express**
- **PostgreSQL** + Sequelize ORM
- **JWT** para autenticación
- **bcrypt** para cifrado de contraseñas
- **Prometheus** y **Grafana** para observabilidad
- **Docker** y **Kubernetes** en AWS EKS
- **Terraform** para infraestructura
- **Jest** y **Supertest** para testing

---

## Requisitos

- **Node.js** (Recomendado: v16 o superior)
- **PostgreSQL** para la base de datos
- **npm** o **yarn** para la gestión de dependencias



## 🚀 Endpoints REST

| Método | Ruta               | Descripción                        | Autenticación |
|--------|--------------------|------------------------------------|----------------|
| POST   | `/api/register`    | Registro de nuevo usuario          | ❌             |
| POST   | `/api/login`       | Login de usuario                   | ❌             |
| GET    | `/api/admin/users` | Lista de todos los usuarios        | ✅ (Admin)     |
| POST   | `/api/admin/users` | Crear nuevo usuario (admin)        | ✅ (Admin)     |
| GET    | `/metrics`         | Exposición de métricas Prometheus  | ❌             |

---

## 🔐 Autenticación

- Las contraseñas se cifran usando **bcrypt**
- Los tokens JWT protegen los endpoints de administrador
- Middleware personalizado gestiona roles y autenticación

---

## 📊 Monitorización con Prometheus + Grafana

- Métricas expuestas en `/metrics` con `prom-client`
- Prometheus scrapea automáticamente la API
- Dashboard de Grafana importado (ID: `11074`)

---

## 🐳 Docker

### Dockerfile

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```


### Docker-compose.yml
```docker-compose
version: '3.8'
services:
  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=postgres
      - DB_USER=postgres
      - DB_PASS=postgres
      - DB_NAME=auth_db
      - JWT_SECRET=supersecret
    depends_on:
      - postgres

  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: auth_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

---


###Kubernetes (carpeta /k8s): Incluye todos los manifiestos para desplegar la API y su entorno:
----------------------------------------------------------------------------------------------
- auth-api-deployment.yaml: despliegue principal de la API

- auth-api-service.yaml: servicio tipo LoadBalancer

- postgres-deployment.yaml, postgres-service.yaml, postgres-pvc.yaml: base de datos

- configmap.yaml y secrets.yaml: configuración sensible

- ebs-sc.yaml: StorageClass para EBS


---

###Prometheus scrape: Para habilitar Prometheus en tu servicio, asegúrate de incluir:
------------------------------------------------------------------------------------
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: "/metrics"
    prometheus.io/port: "3000"

---

Terraform (carpeta /terraform):Infraestructura como código con Terraform para:
-----------------------------------------------------------------------------
Crear una instancia EC2 que almacena manifiestos Kubernetes. Configurar acceso a EKS (AWS)

Archivos principales:
- main.tf: instancia EC2, red, seguridad

- provider.tf: configuración AWS

- outputs.tf: salidas útiles (como IP pública)

- variables.tf: definición de variables reutilizables

---

📜 IAM y EBS (carpeta /eks): Contiene políticas de acceso a EBS y permisos administrativos del cluster EKS:
---------------------------------------------------------------------------------------------------------
- ebs-csi-policy.json

- eks-admin-full-access.json

---

✅ Tests: Las pruebas están en /api/tests/ e incluyen casos para login, registro y endpoints protegidos.
--------------------------------------------------------------------------------------------------------
Ejecutar pruebas
cd api
npm install
npm test


###Informe de cobertura: El informe se genera automáticamente en:
---------------------------------------------------------------
api/coverage/lcov-report/index.html


---


###Variables de entorno
.Env: Variables de entorno.

/api/.env.test: Variable de entorno para las pruebas


---

📦 Despliegue en EKS: Ejecuta Terraform para desplegar la instancia EC2 y configurar EKS
---------------------------------------------------------------------------------------
- Conéctate por SSH a la EC2

- Clona este repositorio

- Aplica los manifiestos de Kubernetes: kubectl apply -f k8s/

- Instala Prometheus y Grafana con Helm

- Importa el Dashboard 11074 en Grafana para monitorizar métricas

---

🔗 Repositorio: https://github.com/jjavila80/IEBS_Global_Project
----------------------------------------------------------------

👨🎓 Autor: Proyecto desarrollado por @jjavila80 para IEBS Business School como parte del programa de formación.

📝 Licencia: MIT © jjavila80

