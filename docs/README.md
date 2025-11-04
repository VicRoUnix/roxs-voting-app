# VOting APP Project RoxsDevOps90days

---

# Semana 3:

---

## 1. Creacion de los archivos `docker-compose.staging.yml` y `docker-compose.prod.yml`
* En estos archivos se han realizado cambios de las diferencias entre , desarrollo local, en staging y en produccion real
  * En docker compose stagging: Las versiones de desarolo trabajamos con las ultimas imagenes
  * En docker compose prod: ya tenemos un release de la imagen versionada lista para ponerse en produccion.

---

## 2.Creacion del primer workflow `CI.yml`
* Lo que queremos realizar con el primer workflow es 
1. 👨‍💻 Developer hace push a 'develop'
   ↓
2. 🔄 GitHub Actions ejecuta CI
   - Tests de vote (Python)
   - Tests de result (Node.js) 
   - Tests de worker (Node.js)
   - Integration tests con Docker Compose
   ↓
3. 🏗️ Build de imágenes Docker
   - vote:latest
   - result:latest
   - worker:latest