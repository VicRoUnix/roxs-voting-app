#!/bin/bash
#
# health-check.sh
# Comprueba que los servicios web (vote y result) responden en localhost.
#
# Uso: ./scripts/health-check.sh
#

set -e

echo "🔎 Realizando Health Check (Smoke Test)..."
echo -n "Comprobando 'vote' (localhost:80)... "

# 'curl --fail' falla si el código no es 200
# '--silent' y '--output /dev/null' ocultan la salida de la página
if curl --fail --silent --output /dev/null http://localhost:80; then
  echo "✅ OK"
else
  echo "❌ FALLIDO"
  exit 1
fi

echo -n "Comprobando 'result' (localhost:3000)... "
if curl --fail --silent --output /dev/null http://localhost:3000; then
  echo "✅ OK"
else
  echo "❌ FALLIDO"
  exit 1
fi

echo "👍 ¡Health Check superado! El sistema está operativo."