# Paso 1: Utilizar una imagen base oficial de Node.js
FROM node:16-alpine

# Paso 2: Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Paso 3: Copiar el archivo `package.json` y `package-lock.json` (o `yarn.lock`) al contenedor
# Esto permite instalar dependencias sin tener que copiar todo el código al principio
COPY api/package*.json /app

# Paso 4: Instalar las dependencias del proyecto
RUN npm install

# Paso 5: Copiar el resto de los archivos del proyecto al contenedor
COPY api/ /app

# Paso 6: Exponer el puerto en el que la aplicación escucha (por defecto Express usa el puerto 3000)
EXPOSE 3000

# Paso 7: Definir el comando para ejecutar la aplicación
CMD ["node", "server.js"]

