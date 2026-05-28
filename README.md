# Projecte Transversal ASIXc1 — InnovateTech

> Proposta de CPD físic i desplegament d'una infraestructura tecnològica al núvol AWS per a una empresa de serveis tecnològics — directori actiu LDAP, streaming d'àudio i vídeo, base de dades corporativa i logs centralitzats.

**Autors:** Joel Baena · Marc Balastegui · Oussama Boukhali · Alex Sampietro  
**Cicle:** CFGS ASIX  
**Centre:** Institut Tecnològic de Barcelona  
**Curs:** 2025–2026  
**Període del projecte:** 18/05/2026 → 28/05/2026  
**Defensa:** 29/05/2026

---

## El repte

InnovateTech és una empresa petita (entre 10 i 50 empleats) dedicada a la provisió de serveis tecnològics, amb una activitat creixent de vendes en línia i una demanda de suport tècnic als seus clients. L'empresa disposa de 5 departaments: Vendes, Suport Tècnic, Administració, Logística i Direcció. El projecte inclou una proposta de CPD físic on-premise i el desplegament d'una infraestructura completa al núvol AWS.

---

## Infraestructura del projecte

```
CPD Físic — Proposta de disseny (on-premise)
├── Rack 1: Patch panels Cat6A · Switch core · Switch accés · pfSense · ODF
├── Rack 2: S1 OpenLDAP · S2 MariaDB · S3 Vídeo+Jitsi · S4 Icecast2
│           S5 Web+SFTP · S6 Logs · NAS Synology RS1221+ · SAI APC 3000VA
└── Serveis: DNS · DHCP · VPN WireGuard · Backups NAS RAID5
    Seguretat: CRAC N+1 · RFID+PIN · VESDA · FM-200 · 3 càmeres 1080p

AWS Cloud — Desplegat i operatiu (us-east-1 · VPC 10.0.0.0/16)
├── 10.0.1.10 — LDAP        OpenLDAP + phpLDAPadmin
├── 10.0.1.21 — Web + SFTP  Apache2 + SFTP autenticat LDAP + Ansible
├── 10.0.1.31 — Logs        syslog-ng centralitzat + Ansible
├── 10.0.1.40 — BBDD        MySQL 8.0 · 18 taules · 4 rols · 5 triggers
├── 10.0.1.50 — Àudio       Icecast2 + Liquidsoap · MP3 128kbps
└── 10.0.1.60 — Vídeo       NGINX-RTMP + Jitsi Meet · HLS + WebRTC
```

---

## Flux d'autenticació SFTP

```
Usuari → sftp mnadal@IP_WEB
       → SSH (PasswordAuthentication)
       → PAM (libpam-ldapd)
       → nslcd → OpenLDAP (10.0.1.10)
       → Credencials validades
       → ChrootDirectory /sftp/mnadal/files
```

---

## Technology Stack

| Component | Tecnologia | Funció |
|-----------|-----------|--------|
| Directori actiu | OpenLDAP (slapd) | Gestió centralitzada d'usuaris i permisos |
| Servidor web | Apache2 | Portal corporatiu InnovateTech |
| Transferència fitxers | OpenSSH SFTP | SFTP autenticat via LDAP amb ChrootDirectory |
| Automatització | Ansible | Configuració automàtica màquines web i logs |
| Logs centralitzats | syslog-ng | Recollida logs de totes les màquines |
| Base de dades | MySQL 8.0 | Gestió dades corporatives |
| Streaming àudio | Icecast2 + Liquidsoap | Distribució àudio MP3/OGG/AAC |
| Streaming vídeo | NGINX-RTMP + HLS | Vídeo sota demanda i en directe |
| Videoconferència | Jitsi Meet + WebRTC | Videoconferències corporatives |
| Monitorització | Netdata | Dashboard temps real servidor web |
| Firewall CPD | pfSense | DNS · DHCP · VPN WireGuard · filtratge IP/port |
| Infraestructura cloud | AWS VPC · EC2 · Security Groups | Xarxa aïllada i segura |

---

## Índex de continguts

| Document | Descripció |
|----------|-----------|
| [`docs/1-CPD.md`](docs/1-CPD.md) | Proposta CPD físic — racks, climatització, seguretat física i lògica |
| [`docs/2-AWS.md`](docs/2-AWS.md) | Infraestructura AWS — VPC, EC2, Security Groups, IPs elàstiques |
| [`docs/3-LDAP.md`](docs/3-LDAP.md) | Directori actiu OpenLDAP — OUs, usuaris, phpLDAPadmin |
| [`docs/4-WEB-SFTP.md`](docs/4-WEB-SFTP.md) | Servidor web Apache + SFTP autenticat LDAP + Ansible |
| [`docs/5-LOGS.md`](docs/5-LOGS.md) | Logs centralitzats syslog-ng + Ansible |
| [`docs/6-AUDIO.md`](docs/6-AUDIO.md) | Streaming àudio Icecast2 + Liquidsoap |
| [`docs/7-VIDEO.md`](docs/7-VIDEO.md) | Streaming vídeo NGINX-RTMP + Jitsi Meet |
| [`docs/8-BBDD.md`](docs/8-BBDD.md) | Base de dades MySQL — 18 taules, 4 rols, 5 triggers, backup automàtic |
| [`docs/9-BANDWIDTH.md`](docs/9-BANDWIDTH.md) | Proves amplada de banda — >1 Gbps, <3ms latència |

---

## Resultats principals

| Servei | Estat | Verificació |
|--------|-------|-------------|
| CPD físic | 📐 Disseny | 2 racks · 6 servidors Dell · NAS Synology · SAI APC · CRAC · FM-200 |
| OpenLDAP + phpLDAPadmin | ✅ Operatiu | 10 usuaris · 7 OUs · port 389 |
| Apache2 — pàgina web | ✅ Operatiu | http://54.210.46.27 |
| SFTP autenticat LDAP | ✅ Operatiu | sftp mnadal@54.210.46.27 |
| Ansible web + logs | ✅ Operatiu | failed=0 · idempotent |
| syslog-ng centralitzat | ✅ Operatiu | /var/log/hosts/ · port 514 |
| MySQL 8.0 | ✅ Operatiu | 18 taules · 4 rols · 5 triggers · backup 02:00 |
| Icecast2 streaming | ✅ Operatiu | http://34.196.148.33:8000/stream |
| NGINX-RTMP + HLS | ✅ Operatiu | http://3.214.188.132:8080/hls/stream.m3u8 |
| Jitsi Meet | ✅ Operatiu | https://3.214.188.132 |
| Bandwidth | ✅ Acceptable | >1 Gbps download/upload · <3ms latència |

---

## Estructura del repositori

```
pro-asixc1c-g2/
├── README.md                          # Índex general del projecte
├── docs/
│   ├── 1-CPD.md                       # Proposta CPD físic i seguretat
│   ├── 2-AWS.md                       # Infraestructura AWS — 6 màquines EC2
│   ├── 3-LDAP.md                      # Directori actiu OpenLDAP
│   ├── 4-WEB-SFTP.md                  # Servidor web Apache + SFTP + Ansible
│   ├── 5-LOGS.md                      # Logs centralitzats syslog-ng + Ansible
│   ├── 6-AUDIO.md                     # Streaming àudio Icecast2 + Liquidsoap
│   ├── 7-VIDEO.md                     # Streaming vídeo NGINX-RTMP + Jitsi Meet
│   ├── 8-BBDD.md                      # Base de dades MySQL — triggers i rols
│   └── 9-BANDWIDTH.md                 # Proves d'amplada de banda
├── img/
│   ├── audio-video/                   # Captures àudio, vídeo i bandwidth
│   │   ├── captura10.png              # Panell Icecast2 actiu
│   │   ├── captura19.png              # Vídeo reproduint-se al navegador
│   │   ├── captura20.png              # Stream HLS reproduint-se al VLC
│   │   ├── captura25.png              # Jitsi Meet — 2 usuaris connectats
│   │   ├── captura26.png              # Speedtest màquina àudio
│   │   └── captura27.png              # Speedtest màquina vídeo
│   ├── aws/                           # Captures infraestructura AWS
│   │   ├── instancies.png             # 6 instàncies EC2 en estat Running
│   │   ├── route-table.png            # Taula de rutes configurada
│   │   ├── sg-audio.png               # Security Group audio-sg
│   │   ├── sg-bbdd.png                # Security Group bbdd-sg
│   │   ├── sg-ldap.png                # Security Group ldap-sg
│   │   ├── sg-logs.png                # Security Group logs-sg
│   │   ├── sg-video.png               # Security Group video-sg
│   │   ├── sg-web.png                 # Security Group web-sg
│   │   ├── subnet.png                 # Subxarxa subred-innovateTech-publica
│   │   └── vpc.png                    # VPC vpc-innovateTech
│   ├── bbdd/                          # Captures base de dades
│   │   ├── backup.png                 # Event backup diari verificat
│   │   ├── bash_discord.png           # Script notificacions Discord
│   │   ├── diagramaBBDD.png           # Diagrama Entitat-Relació (18 taules)
│   │   ├── discord.png                # Notificació Discord en temps real
│   │   ├── grants.png                 # Verificació permisos SHOW GRANTS
│   │   ├── mesura_amplebanda.png      # Inserció automàtica mesures bandwidth
│   │   ├── show_tables.png            # SHOW TABLES — 18 taules creades
│   │   ├── trigger1.png               # Trigger bloqueig usuaris
│   │   ├── trigger2.png               # Trigger quota minuts mensuals
│   │   ├── trigger3.png               # Trigger quota trucades diàries
│   │   ├── trigger4.png               # Trigger auditoria nòmines
│   │   ├── trigger5.png               # Trigger auditoria trucades
│   │   ├── usuaris.png                # Execució script scriptusuaris.sh
│   │   ├── usuaris_creats.png         # Fitxer usuaris_creats.sql generat
│   │   └── usuaris_error.png          # Gestió d'errors script usuaris
│   ├── cpd/                           # Plànols i diagrames CPD físic
│   │   ├── cpd.png                    # Diagrama de racks
│   │   ├── perfil.png                 # Plànol vista lateral
│   │   └── sala.png                   # Plànol vista de planta
│   ├── ldap/                          # Captures servei LDAP
│   │   ├── ldap-phpldap.png           # phpLDAPadmin amb usuaris
│   │   ├── ldap-ports.png             # Ports 389 i 636 actius
│   │   ├── ldap-sftp.png              # Connexió SFTP autenticada via LDAP
│   │   └── ldap-status.png            # Estat servei slapd
│   ├── logs/                          # Captures logs centralitzats
│   │   ├── logs-ansible.png           # Execució playbook Ansible failed=0
│   │   ├── logs-contingut.png         # Logs rebuts de la màquina LDAP
│   │   ├── logs-hosts.png             # Carpetes per màquina a /var/log/hosts
│   │   └── logs-status.png            # Estat servei syslog-ng
│   └── web/                           # Captures servei web i SFTP
│       ├── web-ansible.png            # Execució playbook Ansible failed=0
│       ├── web-apache.png             # Estat servei Apache
│       ├── web-directoris.png         # Directoris SFTP per usuari
│       ├── web-netdata.png            # Dashboard Netdata temps real
│       ├── web-pagina.png             # Pàgina web InnovateTech al navegador
│       └── web-sftp.png               # Connexió SFTP amb usuari LDAP
├── scripts/
│   ├── ldap/                          # Fitxers LDIF directori actiu
│   │   ├── ous_innova.ldif            # Creació de les 7 OUs per departament
│   │   └── usuaris_innova.ldif        # Creació dels 10 usuaris corporatius
│   ├── amplebanda.sh                  # Mesura automàtica d'amplada de banda
│   ├── notificacions_discord.sh       # Notificacions Discord via webhook
│   ├── playbook-logs.yml              # Ansible — configuració màquina logs
│   ├── playbook-web.yml               # Ansible — configuració màquina web
│   └── scriptusuaris.sh               # Creació automatitzada usuaris BBDD
└── sql/
    ├── triggeraudit/                  # Triggers d'auditoria accés no autoritzat
    │   ├── audit_trucades.sql         # Bloqueig rol administracio a trucades
    │   └── vendes_audit.sql           # Bloqueig rol vendes a nòmines
    ├── backup.sql                     # Event backup diari a les 02:00
    ├── crear_rols.sql                 # Creació dels 4 rols MySQL
    ├── crear_taules.sql               # Creació de les 18 taules
    ├── insertardades.sql              # Inserció de dades de prova
    ├── trigger_bloqueig.sql           # Trigger bloqueig usuaris
    ├── trigger_trucades_mensuals.sql  # Trigger quota minuts mensuals
    └── trigger_trucadesdiaries.sql    # Trigger quota trucades diàries
```
