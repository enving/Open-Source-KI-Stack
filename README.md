Minimales Setup ohne aut. db Init. Gedacht für das Hosting in der Cloud. 


# IONOS Managed Services Setup für Open-Source-KI-Stack

## Übersicht der Änderungen

Die Docker Compose Konfiguration wurde optimiert, um sowohl IONOS gemanagte PostgreSQL-Datenbank als auch IONOS Redis In-Memory DB zu verwenden anstatt lokaler Container.

### Hauptänderungen:

1. **Entfernung der lokalen Container**
   - Der `postgres` Service wurde aus der Docker Compose entfernt
   - Der `redis` Service wurde aus der Docker Compose entfernt
   - Die entsprechenden Volumes wurden entfernt

2. **IONOS PostgreSQL Konfiguration**
   - Die `DATABASE_URL` verwendet jetzt IONOS Umgebungsvariablen
   - Alle Datenbankverbindungen gehen über IONOS gemanagte PostgreSQL

3. **IONOS Redis Konfiguration**
   - Die `REDIS_URL` und `WEBSOCKET_REDIS_URL` verwenden IONOS Redis
   - SSL/TLS-Unterstützung mit `rediss://` Protokoll
   - Optimierte SSL-Konfiguration für IONOS Managed Redis

## 📊 Größenempfehlungen für Enterprise-Nutzung

### **In Memory DB / Redis-Cluster Empfehlungen:**

#### **Staging/Development (bis 50 Nutzer):**
```
Instanzen: 1
RAM pro Instanz: 4 GB
CPU: 1 Dedicated Core
Persistenz: RDB und AOF
Kosten: ~64€/Monat
```

#### **Production (100-500 Nutzer):**
```
Instanzen: 3
RAM pro Instanz: 8 GB
CPU: 2 Dedicated Cores pro Instanz
Persistenz: RDB und AOF
Replikation: Aktiviert
Kosten: ~192€/Monat
```

#### **Enterprise (500-1000+ Nutzer):**
```
Instanzen: 5
RAM pro Instanz: 16 GB
CPU: 4 Dedicated Cores pro Instanz
Persistenz: RDB und AOF
Replikation: Aktiviert
Auto-Scaling: Aktiviert
Kosten: ~320€/Monat
```

### **PostgreSQL-Cluster Empfehlungen:**

#### **Staging/Development (bis 50 Nutzer):**
```
Instanzen: 1
RAM pro Instanz: 4 GB
CPU: 1 Dedicated Core
Speicher: 20 GB HDD
Kosten: ~64€/Monat
```

#### **Production (100-500 Nutzer):**
```
Instanzen: 3
RAM pro Instanz: 8 GB
CPU: 2 Dedicated Cores pro Instanz
Speicher: 50 GB SSD
Replikation: Aktiviert
Kosten: ~192€/Monat
```

#### **Enterprise (500-1000+ Nutzer):**
```
Instanzen: 5
RAM pro Instanz: 16 GB
CPU: 4 Dedicated Cores pro Instanz
Speicher: 100 GB SSD
Replikation: Aktiviert
Auto-Scaling: Aktiviert
Kosten: ~400€/Monat
```

### **Aktuelle Staging-Konfiguration:**
```
Redis-Cluster: in_memory_db_redis_staging
- 1 Instanz, 4 GB RAM, 1 CPU
- Private IP: 10.7.226.3/24
- Benutzer: staging-benutzer
- Kosten: ~64€/Monat

PostgreSQL-Cluster: staging_postgresql
- 1 Instanz, 4 GB RAM, 1 CPU
- Speicher: 10 GB HDD
- Benutzer: staging-benutzer
- Kosten: ~64€/Monat
```

## Einrichtung

### 1. Umgebungsvariablen konfigurieren

Kopieren Sie die Beispiel-Datei und passen Sie sie an:

```bash
cp env.ionos.example .env
```

Bearbeiten Sie die `.env` Datei mit Ihren IONOS-Datenbankdaten:

```bash
nano .env
```

### 2. Notwendige IONOS-Datenbankdaten

Sie benötigen folgende Informationen von IONOS:

- **IONOS_DB_HOST**: Der Hostname Ihrer IONOS PostgreSQL-Instanz
- **IONOS_DB_PORT**: Port (normalerweise 5432)
- **IONOS_DB_NAME**: Datenbankname (z.B. "openwebui")
- **IONOS_DB_USER**: Benutzername für die Datenbank
- **IONOS_DB_PASSWORD**: Passwort für die Datenbank

### 3. IONOS Redis In-Memory DB konfigurieren

Sie benötigen folgende Informationen von IONOS:

- **IONOS_REDIS_HOST**: Der Hostname Ihrer IONOS Redis-Instanz
- **IONOS_REDIS_PORT**: Port (normalerweise 6379)
- **IONOS_REDIS_USER**: Benutzername für Redis
- **IONOS_REDIS_PASSWORD**: Passwort für Redis

### 4. IONOS AI API konfigurieren

- **IONOS_TOKEN**: Ihr IONOS AI API Token
- **IONOS_BASE_URL**: Die IONOS AI API Basis-URL

### 5. Stack starten

Verwenden Sie die IONOS-spezifische Docker Compose Datei:

```bash
docker-compose -f docker-compose.ionos-complete.yml up -d
```

## Vorteile der IONOS gemanagten Datenbank

- **Automatische Backups**: IONOS übernimmt regelmäßige Backups
- **Skalierbarkeit**: Einfache Skalierung der Datenbankleistung
- **Wartung**: Automatische Updates und Patches
- **Monitoring**: Integriertes Monitoring und Alerting
- **Sicherheit**: Enterprise-Grade Sicherheitsfeatures

## Troubleshooting

### Datenbankverbindung testen

Testen Sie die Verbindung zur IONOS-Datenbank:

```bash
psql "postgresql://${IONOS_DB_USER}:${IONOS_DB_PASSWORD}@${IONOS_DB_HOST}:${IONOS_DB_PORT}/${IONOS_DB_NAME}"
```

### Redis-Verbindung testen

Testen Sie die Verbindung zur IONOS Redis-Instanz:

```bash
redis-cli -h ${IONOS_REDIS_HOST} -p ${IONOS_REDIS_PORT} -u rediss://${IONOS_REDIS_USER}:${IONOS_REDIS_PASSWORD}@${IONOS_REDIS_HOST}:${IONOS_REDIS_PORT}/0 ping
```

### Logs überprüfen

```bash
docker-compose -f docker-compose.ionos-complete.yml logs openwebui
```

### Datenbank-Migration

Bei der ersten Ausführung wird OpenWebUI automatisch die Datenbank-Tabellen erstellen.

### Redis SSL/TLS-Konfiguration

Die Redis-URL verwendet das `rediss://` Protokoll für SSL/TLS-Unterstützung:

```
rediss://${IONOS_REDIS_USER}:${IONOS_REDIS_PASSWORD}@${IONOS_REDIS_HOST}:${IONOS_REDIS_PORT}/0?ssl_cert_reqs=none
```

Der Parameter `ssl_cert_reqs=none` umgeht SSL-Zertifikatsvalidierungsprobleme mit IONOS Managed Redis.

## Sicherheitshinweise

- Verwenden Sie starke Passwörter für alle Umgebungsvariablen
- Beschränken Sie den Datenbankzugriff auf Ihre VM-IP
- Aktivieren Sie SSL/TLS für die Datenbankverbindung
- Regelmäßige Überprüfung der IONOS-Datenbank-Logs

### Datenbank anlegen (ohne Webinterface)

Führen Sie folgenden Befehl auf der VM aus, um die Datenbank zu erstellen:

```bash
psql "postgresql://staging-benutzer:staging_benutzer@pg-oemrj7r0kfjipg97.postgresql.de-txl.ionos.com:5432/postgres" -c "CREATE DATABASE openwebui;"
```

Danach können Sie die Verbindung testen:

```bash
psql "postgresql://staging-benutzer:staging_benutzer@pg-oemrj7r0kfjipg97.postgresql.de-txl.ionos.com:5432/openwebui" -c "SELECT version();"
```

Wenn Sie eine Ausgabe wie z.B.

    PostgreSQL 15.12 (Ubuntu 15.12-1.pgdg22.04+1) ...

erhalten, ist die Verbindung erfolgreich.

### SearXNG Service

SearXNG ist jetzt im Stack enthalten und läuft auf Port 8081.

**Zugriff:** http://194.164.195.38:8081

**Logs anzeigen:**
```bash
docker-compose -f docker-compose.ionos-complete.yml logs searxng
```

**Health-Status prüfen:**
```bash
docker-compose -f docker-compose.ionos-complete.yml ps
```

## 🎯 Erfolgreiche Deployment-Validierung

Der Stack wurde erfolgreich mit folgenden Komponenten getestet:

- ✅ **IONOS PostgreSQL**: Managed Database läuft stabil
- ✅ **IONOS Redis**: Managed In-Memory DB mit SSL/TLS-Unterstützung
- ✅ **OpenWebUI v0.6.15**: Vollständig funktionsfähig
- ✅ **SearXNG**: Suchmaschine läuft auf Port 8081

### Aktuelle Zugriffs-URLs:
- **OpenWebUI**: http://194.164.195.38:3000
- **SearXNG**: http://194.164.195.38:8081

### Deployment-Status:
- **VM**: 194.164.195.38
- **Branch**: staging_beta
- **Docker Compose**: docker-compose.ionos-complete.yml
- **Status**: ✅ Produktionsbereit
