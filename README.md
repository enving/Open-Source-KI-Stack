Minimales Setup ohne aut. db Init. Gedacht für das Hosting in der Cloud. 


# IONOS PostgreSQL Setup für Open-Source-KI-Stack

## Übersicht der Änderungen

Die Docker Compose Konfiguration wurde angepasst, um eine IONOS gemanagte PostgreSQL-Datenbank zu verwenden anstatt einer lokalen Datenbank.

### Hauptänderungen:

1. **Entfernung des lokalen PostgreSQL-Containers**
   - Der `postgres` Service wurde aus der Docker Compose entfernt
   - Das `postgres-data` Volume wurde entfernt

2. **IONOS PostgreSQL Konfiguration**
   - Die `DATABASE_URL` verwendet jetzt IONOS Umgebungsvariablen
   - Alle Datenbankverbindungen gehen über IONOS gemanagte PostgreSQL

## 📊 Größenempfehlungen für Enterprise-Nutzung

### **Redis-Cluster Empfehlungen:**

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

### 3. IONOS AI API konfigurieren

- **IONOS_TOKEN**: Ihr IONOS AI API Token
- **IONOS_BASE_URL**: Die IONOS AI API Basis-URL

### 4. Stack starten

Verwenden Sie die IONOS-spezifische Docker Compose Datei:

```bash
docker-compose -f docker-compose.ionos.yml up -d
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

### Logs überprüfen

```bash
docker-compose -f docker-compose.ionos.yml logs openwebui
```

### Datenbank-Migration

Bei der ersten Ausführung wird OpenWebUI automatisch die Datenbank-Tabellen erstellen.

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
docker logs searxng --tail=40
```

**Health-Status prüfen:**
```bash
docker-compose -f docker-compose.ionos-complete.yml ps
```
