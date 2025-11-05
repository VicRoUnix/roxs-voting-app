#!/bin/bash
#
# backup.sh
# Realiza un backup de la base de datos de un entorno.
#
# Uso: ./scripts/backup.sh <entorno>
# Ejemplo: ./scripts/backup.sh production
#

set -e

# 1. Comprueba el entorno (staging o prod)
if [ -z "$1" ]; then
  echo "Error: Debes especificar el entorno (ej. 'staging' o 'prod')."
  echo "Uso: $0 <entorno>"
  exit 1
fi

ENV_NAME=$1
ENV_FILE=".env.${ENV_NAME}"
COMPOSE_FILE="docker-compose.${ENV_NAME}.yml"

# 2. Define dónde se guardarán los backups
BACKUP_DIR="./backups"
mkdir -p ${BACKUP_DIR} # Crea el directorio si no existe

# 3. Nombre de archivo con fecha y hora
FILENAME="backup-${ENV_NAME}-$(date +%Y-%m-%d_%H%M%S).sql"
FILEPATH="${BACKUP_DIR}/${FILENAME}"

echo "📦 Creando backup para '${ENV_NAME}'..."

# 4. Ejecuta pg_dump DENTRO del contenedor 'postgres'
# 'exec -T' deshabilita la TTY, lo cual es mejor para backups
# 'sh -c' nos deja usar las variables de entorno ($POSTGRES_USER)
# que están DEFINIDAS DENTRO del contenedor
docker compose --env-file ${ENV_FILE} -f docker-compose.yml -f ${COMPOSE_FILE} \
  exec -T postgres \
  sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' > ${FILEPATH}

echo "✅ Backup completado: ${FILEPATH}"