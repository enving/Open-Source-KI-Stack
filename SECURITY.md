
**Datenschutzmaßnahmen im Detail:**  

Für die einzelnen Bestandteile des Stacks siehe auf jeweiligem Repository.

- **IONOS** ([Dokumentation](https://docs.ionos.com/cloud/ai/ai-model-hub/data-handling)):  
  ✓ GDPR-konforme Verarbeitung  
  ✓ Ende-zu-Ende-Verschlüsselung  
  ✓ Isolierte Speicherung pro Kunde  
  


### Netzwerksicherheit (Workflow 4)
- **Zscaler Tunnel**: Sichere Verbindung ohne direkte Exposition der VM
- **Zero Trust Access**: E-Mail-Domain-basierte Zugriffsrichtlinien
- **Automatisierte DNS-Konfiguration**: Sichere CNAME-Einträge für Subdomains
- **TLS-Verschlüsselung**: Sichere Kommunikation mit TLS 1.3
- **Systemd-Service**: Zuverlässiger cloudflared-Dienst mit automatischem Neustart


### BSI C5 Cloud-Sicherheit
- Zertifizierte IONOS Cloud Infrastructure
- Regelmäßige Sicherheitsaudits
- Transparente Kontrollmechanismen
- Nachweisbare Sicherheitsstandards

### Mehrschichtige Sicherheitsarchitektur

#### Schicht 1: Cloud-Infrastruktur
- BSI C5 & ISO 27001 zertifizierte IONOS Cloud
- Physische Sicherheit deutscher Rechenzentren
- 24/7 Security Monitoring
- DDoS Protection
- NAT Gateway pro Kunden-VDC
- Automatische IP-Translation
- Isolierte Netzwerksegmente
- Logging aller ausgehenden Verbindungen
- Integrierte Threat Prevention


#### Schicht 4: Anwendungssicherheit
- Verschlüsselte Kommunikation (TLS 1.3)
- Regelmäßige Security Updates
- Vulnerability Scanning
- Audit Logging

### Datenschutz & Compliance
- 100% DSGVO-konform
- Datenverarbeitung nur in Deutschland
- Transparente Datenverarbeitungsprozesse
- Keine Weitergabe an Dritte

### Disaster Recovery
- Automatische Backups
- Multi-AZ Deployment
- Failover-Mechanismen
- 99.9% Verfügbarkeitsgarantie

### Security Best Practices
- Principle of Least Privilege
- Defense in Depth
- Secure by Design
- Regular Security Reviews

### SSH-Schlüssel-Management
- Zentrale Verwaltung der SSH-Schlüssel in IONOS Cloud
- Automatische Zuweisung bei Server-Erstellung
- Private Schlüssel nur auf dem Master-Server in /secrets
- Regelmäßige Schlüssel-Rotation empfohlen
