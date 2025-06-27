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



Danach können Sie die Verbindung testen:



### Verbindung zur Datenbank testen

Nach dem Anlegen der Datenbank können Sie die Verbindung wie folgt testen:



Wenn Sie eine Ausgabe wie z.B.

    PostgreSQL 15.12 (Ubuntu 15.12-1.pgdg22.04+1) ...

erhalten, ist die Verbindung erfolgreich.

### SearXNG Service

SearXNG ist jetzt im Stack enthalten und läuft auf Port 8081.

**Zugriff:** http://194.164.195.38:8081

**Logs anzeigen:**


**Health-Status prüfen:**


