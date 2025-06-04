
# Informationen und Installation

- Dieses Repo hat ist befreut von Personenbezogenen als auch Firmeninternen Informationen wie Passwörter, ssh keys oder (https) Zertifikate

- Dieses Repo dient der Open Source Weiterentwicklung und ist öffentlich zugänglich

- n8n und Ionos (hybrid derzeit nicht in Planung muss geprüft werden ob zuversichtlich und möglich) https://www.youtube.com/watch?v=K_zmCUkHK4k
- 





Settings for use of IONOS AI Hub in Openwebui / n8n:







function KI workflow: ist die derzeitige function pipe zwischen openwebui und n8n. kann so wie sie ist in der openwebui oberfläche uner Admin panel--> Funktionen importiert werden. Die Variablen / vaults müssen dann noch ggf. angepasst werden auf deine jeweilige n8n instanz

n8n_RAG_ionos_Openwebui: kann direkt so in n8n reingeladen werden. musst natürlich die credentials anlegen



Bei Verwendung weiterer Frameworks müssen wir gucken das Nutzung kommerziell möglich (findet man im jeweiligen repo unter lizenz). 



#Prerequisites

- Linux machine (preferably Unbuntu) with Nano, Git, and Docker installed


Before you begin, make sure you have the following software installed:

Python - Required to run the setup script
Git/GitHub Desktop - For easy repository management
Docker/Docker Desktop - Required to run all services
Ionos dcd cloud login

#Installation
git clone -b stable https://github.com/enving/ki_stack
cd local-ai-packaged


Before running the services, you need to set up your environment variables
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


docker compose starten

imports manuell in openwebui und n8n hochladen

ionos token auf 3 versch. Seiten in Openwebui anlegen

ionos token als credential in n8n anlegen

qdrant qdrant:6333 API Key anlegen und bei Openwebui hinterlegen



## Upgrading

To update all containers to their latest versions (n8n, Open WebUI, etc.), run these commands:

```bash
# Stop all services
docker compose down

# Pull latest versions of all containers
docker compose pull

# Start all services in detached mode
docker compose up -d
```
