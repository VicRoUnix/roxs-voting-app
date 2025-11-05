#!/bin/bash
#
# deploy.sh
# Despliega un entorno (staging o prod).
#
# Uso: ./scripts/deploy.sh <entorno>
# Ejemplo: ./scripts/deploy.sh staging
#

# 1. 'set -e' hace que el script falle inmediatamente si un comando falla
set -e

# 2. Comprueba que se ha pasado el nombre del entorno (staging o prod)
if [ -z "$1" ]; then
  echo "Error: Debes especificar el entorno (ej. 'staging' o 'prod')."
  echo "Uso: $0 <entorno>"
  exit 1
fi

ENV_NAME=$1
ENV_FILE=".env.${ENV_NAME}"
COMPOSE_FILE="docker-compose.${ENV_NAME}.yml"

# 3. Comprueba que los archivos de entorno existen
if [ ! -f "$ENV_FILE" ] || [ ! -f "$COMPOSE_FILE" ]; then
  echo "Error: No se encuentran los archivos de configuración para '${ENV_NAME}'."
  echo "Asegúrate de que '${ENV_FILE}' y '${COMPOSE_FILE}' existen."
  exit 1
fi

echo "🚀 Empezando el despliegue del entorno: ${ENV_NAME}..."

# 4. Inicia sesión en GHCR (necesario para 'pull')
# (Asume que estás logueado localmente o usa un token)
# echo "Iniciando sesión en GHCR..."
# echo $CR_PAT | docker login ghcr.io -u $USERNAME --password-stdin
# (Este paso suele ser manual en local, así que lo comento)

echo "1/3 - Descargando imágenes nuevas..."
docker compose --env-file ${ENV_FILE} -f docker-compose.yml -f ${COMPOSE_FILE} pull

echo "2/3 - Reiniciando servicios (usando 'healthchecks')..."
# '--wait' usa tus healthchecks para esperar a que redis/postgres estén sanos
docker compose --env-file ${ENV_FILE} -f docker-compose.yml -f ${COMPOSE_FILE} up -d --wait

echo "3/3 - Limpiando imágenes antiguas..."
docker image prune -f

echo "✅ ¡Despliegue en ${ENV_NAME} completado!"