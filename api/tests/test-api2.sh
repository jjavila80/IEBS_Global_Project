#!/bin/bash

API_URL="ad2601478a549477db833503480ae189-2029441709.eu-south-2.elb.amazonaws.com:3000/api/"

echo "🔧 Registrando usuario normal..."
REGISTER_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"userpass","nombre":"Usuario","apellido":"Normal"}')

if [ "$REGISTER_RESPONSE" -eq 201 ]; then
  echo "✅ Registro OK (201)"
elif [ "$REGISTER_RESPONSE" -eq 409 ]; then
  echo "⚠️  Usuario ya registrado (409)"
else
  echo "❌ Registro fallido ($REGISTER_RESPONSE)"
fi

echo "🔧 Registrando usuario admin..."
ADMIN_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"adminpass","nombre":"Admin","apellido":"User", "rol":"admin"}')

if [ "$ADMIN_RESPONSE" -eq 201 ]; then
  echo "✅ Admin registrado (201)"
elif [ "$ADMIN_RESPONSE" -eq 409 ]; then
  echo "⚠️  Admin ya registrado (409)"
else
  echo "❌ Registro admin fallido ($ADMIN_RESPONSE)"
fi

echo "🔐 Login como admin..."
LOGIN_ADMIN=$(curl -s -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"adminpass"}')

ADMIN_TOKEN=$(echo "$LOGIN_ADMIN" | jq -r .token)

if [ "$ADMIN_TOKEN" != "null" ] && [ -n "$ADMIN_TOKEN" ]; then
  echo "✅ Login admin OK"
else
  echo "❌ Login admin fallido. Respuesta: $LOGIN_ADMIN"
  exit 1
fi

echo "📋 Consultando usuarios como admin..."
STATUS_USERS=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API_URL/admin/users" \
  -H "Authorization: Bearer $ADMIN_TOKEN")

if [ "$STATUS_USERS" -eq 200 ]; then
  echo "✅ Acceso a usuarios OK (200)"
  curl -s -X GET "$API_URL/admin/users" \
    -H "Authorization: Bearer $ADMIN_TOKEN" | jq
else
  echo "❌ Acceso a usuarios fallido ($STATUS_USERS)"
fi

echo "➕ Creando nuevo usuario como admin..."
CREATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/admin/users" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email":"nuevo@example.com","password":"nuevo123","nombre":"Nuevo","apellido":"Usuario"}')

if [ "$CREATE_RESPONSE" -eq 201 ]; then
  echo "✅ Usuario creado correctamente (201)"
elif [ "$CREATE_RESPONSE" -eq 409 ]; then
  echo "⚠️  Usuario ya existe (409)"
else
  echo "❌ Fallo al crear usuario ($CREATE_RESPONSE)"
fi

