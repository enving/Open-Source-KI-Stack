
# Informationen

- Dieses Repo dient der Open Source Weiterentwicklung und wird öffentlich zugänglich

- Dieses Repo ist befreit von personenbezogenen als auch firmeninternen Informationen wie Passwörter, ssh keys oder (https) Zertifikate. Diese müssen vor der öffentlichen veröffentlichung des repos entfernt werden, und sollten dann über .env oder .gitignore auf dem lokalen Rechner oder Server bleiben.

# Installation

## Option 1: Advanced stack and for rollout Oktober 2025 - manuel imports
```
git clone -b main https://github.com/enving/ki_stack
cd ki_stack
cp .env.example .env
docker compose -f ./docker-compose.testing.yml up -d
```

Dann manueller Import von n8n workflow und Konfigurationsdatei (config.file) in OpenWebui.


## Option 2: Basic stack  - automatic imports 

To prepare the development environment, just follow these steps:

```
git clone -b main https://github.com/enving/ki_stack
cd ki_stack
cp .env.example .env
docker compose -f ./docker-compose.dev.yml up -d
```

After that, the entire enviroment should be **automatically prepared**\* and come up, mainly:

- n8n on: http://localhost:5678/
- openwebui on: http://localhost:3000/
- qdrant on: http://localhost:6333/

\* To customize how the databases are populated on first startup, refer to the README in `db_init` and deeper folders.

### Login

When the environment first starts, the initialization scripts create a default user, which is:

```
User: admin@admin.com
Password: Dc.3Dk6DX!ZpfUj
```

Use the above credentials to access n8n and openwebui; These should only be used in a development settting, for obvious reasons.


### Other features

Function KI workflow: Die Variablen / vaults müssen dann noch ggf. angepasst werden auf deine jeweilige n8n instanz

n8n_RAG_ionos_Openwebui: Musst natürlich die credentials anlegen

Bei Verwendung weiterer Frameworks müssen wir gucken das Nutzung kommerziell möglich (findet man im jeweiligen repo unter lizenz). 

# Prerequisites

One of:

- Linux (preferably Unbuntu) with Nano, Git, and Docker installed
- Windows 10/11 with Docker Desktop and WSL2 (Ubuntu) installed

Before you begin, make sure you have the following software installed/set up:

- Git/GitHub Desktop - For easy repository management
- Docker/Docker Desktop - Required to run all services
- Ionos dcd cloud login

Before running the services, it is adviced to set up your environment variables. **If you don't, the services will get default ports and passwords. Be aware!**
Make a copy of .env.example and rename it to .env in the root directory of the project and set the variables accordingly.

> [!IMPORTANT]
> Make sure to generate secure random values for all secrets. Never use the example values in production.

Further steps might be needed, such as: 
 - Ionos token auf 3 versch. Seiten in Openwebui anlegen
 - ionos token als credential in n8n anlegen
 - qdrant qdrant:6333 API Key anlegen und bei Openwebui hinterlegen

## Upgrading

To update all containers to their latest versions (n8n, Open WebUI, etc.), run these commands:

```bash
# Stop all services
docker compose -f ./docker-compose.dev.yml down
# Pull latest versions of all containers
docker compose pull
# Start all services in detached mode
docker compose -f ./docker-compose.dev.yml up -d
```

## Further notes

There is also a so called "Testing" environment where reverse proxy, docling and other services run. To start that instead of the default development environment, use:
```
docker compose -f ./docker-compose.testing.yml up -d
```
Ironically enough, the testing branch was *not* tested. Use it at your own risk.
