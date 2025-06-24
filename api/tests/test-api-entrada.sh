#!/bin/bash

API_URL="http://192.168.49.2:30531/api"

echo "🔧 Pruebas de validación de entrada para registro, login y creación de usuario..."

# Registro válido
echo "🔧 Registrando usuario válido..."
REGISTER_OK=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"valido@example.com","password":"validPass123","nombre":"Valido","apellido":"Usuario"}')

if [ "$REGISTER_OK" -eq 201 ]; then
  echo "✅ Registro válido OK (201)"
else
  echo "❌ Registro válido falló ($REGISTER_OK)"
fi

# Registro email inválido
echo "❌ Registrando con email inválido..."
REGISTER_EMAIL_INV=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"no-es-email","password":"userpass","nombre":"Test","apellido":"User"}')

if [ "$REGISTER_EMAIL_INV" -eq 400 ]; then
  echo "✅ Email inválido rechazado (400)"
else
  echo "❌ Email inválido no fue rechazado ($REGISTER_EMAIL_INV)"
fi

# Registro contraseña vacía
echo "❌ Registrando con contraseña vacía..."
REGISTER_PASS_VACIA=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"user2@example.com","password":"","nombre":"Test","apellido":"User"}')

if [ "$REGISTER_PASS_VACIA" -eq 400 ]; then
  echo "✅ Contraseña vacía rechazada (400)"
else
  echo "❌ Contraseña vacía no fue rechazada ($REGISTER_PASS_VACIA)"
fi

# Registro con email duplicado
echo "❌ Registrando con email duplicado..."
REGISTER_DUPLICADO=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"valido@example.com","password":"otraPass123","nombre":"Test","apellido":"User"}')

if [ "$REGISTER_DUPLICADO" -eq 409 ]; then
  echo "✅ Email duplicado rechazado (409)"
else
  echo "❌ Email duplicado no fue rechazado ($REGISTER_DUPLICADO)"
fi

# Login válido
echo "🔐 Login con usuario válido..."
LOGIN_OK=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"valido@example.com","password":"validPass123"}')

if [ "$LOGIN_OK" -eq 200 ]; then
  echo "✅ Login válido OK (200)"
else
  echo "❌ Login válido falló ($LOGIN_OK)"
fi

# Login con email no existente
echo "❌ Login con email no existente..."
LOGIN_NOEXISTE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"noexiste@example.com","password":"anyPass"}')

if [ "$LOGIN_NOEXISTE" -eq 401 ]; then
  echo "✅ Email no existente rechazado (401)"
else
  echo "❌ Email no existente no fue rechazado ($LOGIN_NOEXISTE)"
fi

# Login con contraseña incorrecta
echo "❌ Login con contraseña incorrecta..."
LOGIN_PASS_INCORR=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"valido@example.com","password":"wrongPass"}')

if [ "$LOGIN_PASS_INCORR" -eq 401 ]; then
  echo "✅ Contraseña incorrecta rechazada (401)"
else
  echo "❌ Contraseña incorrecta no fue rechazada ($LOGIN_PASS_INCORR)"
fi

# Crear usuario admin válido (primero login para token)
echo "🔐 Login admin para crear usuario..."
LOGIN_ADMIN_RESP=$(curl -s -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"adminpass"}')

ADMIN_TOKEN=$(echo "$LOGIN_ADMIN_RESP" | jq -r .token)

if [ "$ADMIN_TOKEN" == "null" ] || [ -z "$ADMIN_TOKEN" ]; then
  echo "❌ Login admin falló. No se puede probar creación de usuario."
  exit 1
fi

# Crear usuario válido con token admin
echo "➕ Creando usuario válido como admin..."
CREATE_OK=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/admin/users" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email":"nuevouser@example.com","password":"nuevoPass123","nombre":"Nuevo","apellido":"Usuario"}')

if [ "$CREATE_OK" -eq 201 ]; then
  echo "✅ Creación usuario válida OK (201)"
else
  echo "❌ Creación usuario válida falló ($CREATE_OK)"
fi

# Crear usuario con email inválido
echo "❌ Creando usuario con email inválido..."
CREATE_EMAIL_INV=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/admin/users" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email":"malemail","password":"nuevoPass123","nombre":"Nuevo","apellido":"Usuario"}')

if [ "$CREATE_EMAIL_INV" -eq 400 ]; then
  echo "✅ Creación con email inválido rechazada (400)"
else
  echo "❌ Creación con email inválido no fue rechazada ($CREATE_EMAIL_INV)"
fi

# Crear usuario sin token
echo "❌ Creando usuario sin token..."
CREATE_SIN_TOKEN=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/admin/users" \
  -H "Content-Type: application/json" \
  -d '{"email":"sinpermiso@example.com","password":"pass123","nombre":"No","apellido":"Token"}')

if [ "$CREATE_SIN_TOKEN" -eq 401 ]; then
  echo "✅ Creación sin token rechazada (401)"
else
  echo "❌ Creación sin token no fue rechazada ($CREATE_SIN_TOKEN)"
fi

echo "✅ Pruebas de validación de entrada completadas."

