
# Informationen

- Dieses Repo dient der Open Source Weiterentwicklung und ist öffentlich zugänglich

- Dieses Repo ist befreut von Personenbezogenen als auch Firmeninternen Informationen wie Passwörter, ssh keys oder (https) Zertifikate. Diese müssen vor der öffentlichen veröffentlichung des repos entfernt werden, und sollten dann über .env oder .gitignore auf dem lokalen Rechner oder Server bleiben.

# Installation

To prepare the development environment, just follow these steps:

```
git clone -b main https://github.com/enving/ki_stack
cd ki_stack
cp .env.example .env
docker compose -f .\docker-compose.dev.yml up -d
```

After that, the entire enviroment should come up, mainly:

- n8n on: http://localhost:5678/
- openwebui on: http://localhost:3000/
- qdrant on: http://localhost:6333/

function KI workflow: ist die derzeitige function pipe zwischen openwebui und n8n. kann so wie sie ist in der openwebui oberfläche uner Admin panel--> Funktionen importiert werden. Die Variablen / vaults müssen dann noch ggf. angepasst werden auf deine jeweilige n8n instanz

n8n_RAG_ionos_Openwebui: kann direkt so in n8n reingeladen werden. musst natürlich die credentials anlegen

Bei Verwendung weiterer Frameworks müssen wir gucken das Nutzung kommerziell möglich (findet man im jeweiligen repo unter lizenz). 

#Prerequisites

One of:

- Linux (preferably Unbuntu) with Nano, Git, and Docker installed
- Windows 10/11 with Docker Desktop and WSL2 (Ubuntu) installed

Before you begin, make sure you have the following software installed:

Git/GitHub Desktop - For easy repository management
Docker/Docker Desktop - Required to run all services
Ionos dcd cloud login

Before running the services, it is adviced to set up your environment variables. **If you don't, the services will get default ports and passwords. Be aware!**
Make a copy of .env.example and rename it to .env in the root directory of the project

Set the following required environment variables 

> [!IMPORTANT]
> Make sure to generate secure random values for all secrets. Never use the example values in production.

3. Set the following environment variables if deploying to production, otherwise leave commented:
   ```bash
   ############
   # Caddy Config
   ############
   N8N_HOSTNAME=n8n.yourdomain.com
   WEBUI_HOSTNAME=:openwebui.yourdomain.com
   SEARXNG_HOSTNAME=searxng.yourdomain.com
   LETSENCRYPT_EMAIL=your-email-address
   ```   

---

ionos token auf 3 versch. Seiten in Openwebui anlegen

ionos token als credential in n8n anlegen

qdrant qdrant:6333 API Key anlegen und bei Openwebui hinterlegen

## Upgrading

To update all containers to their latest versions (n8n, Open WebUI, etc.), run these commands:

```bash
# Stop all services
docker compose -f .\docker-compose.dev.yml down
# Pull latest versions of all containers
docker compose pull
# Start all services in detached mode
docker compose -f .\docker-compose.dev.yml up -d
```
