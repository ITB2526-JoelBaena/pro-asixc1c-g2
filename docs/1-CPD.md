# cpd
# 1. Proposta de CPD

## 1.1 Descripció de l'empresa

InnovateTech és una empresa petita (entre 10 i 50 empleats) dedicada a la provisió de serveis tecnològics, amb una activitat creixent de vendes en línia i una demanda de suport tècnic als seus clients. L'empresa disposa de 3 departaments: Vendes, Suport Tècnic i Administració. Per gestionar tot això, necessitem una base tecnològica que integri la gestió del personal amb serveis multimèdia avançats: distribució d'àudio i vídeo en streaming i un sistema de base de dades integral per gestionar empleats, clients i l'activitat dels serveis.

---

## 1.2 Ubicació física del CPD

El CPD el ubicarem a la planta baixa per facilitar l'accés per al personal de manteniment, i el transport d'equipament pesat. Es tractarà d'una sala suficient per posar 2 racks i tots els sistemes auxiliars necessaris.

### 1.2.1 Mesures per dificultar la identificació de la sala

La sala estarà identificada com sala de manteniment i no hi hauran finestres exteriors ni cap indicador visual. El cablejat que entra a la sala s'enrutarà pel sostre per que no hi hagi cap sospita. La porta serà metàl·lica i necessitarà dos claus a més del pany electrònic.

### 1.2.2 Terra tècnic i sostre tècnic

Serà un fals terra elevat 30 cm per sobre del terra real, format per plaques desmuntables de 600×600 mm que servirà per passar l'aire fred que enviarà el CRAC. Les plaques davant dels racks tenen reixetes per on puja l'aire fred de la climatització cap als servidors.

Un fals sostre col·locat a 3 m d'alçada, deixant 70 cm d'espai ocult a sobre. Per aquest espai passarà tot el cablejat per sota sense que es vegi. Les plaques també seran desmuntables de 60×60 cm per facilitar el manteniment.

### 1.2.3 Distribució i gestió del cablejat

- **Cablejat de dades:** Seran els cables que connectaran els servidors entre ells i amb els switches. S'utilitzaran cables de xarxa UTP Cat6A per a les connexions normals i fibra òptica OM3 per a les connexions principals que necessiten més velocitat. Tots aquests cables passaran pel sostre tècnic, dins de safates metàl·liques, i sempre separats dels cables elèctrics com a mínim 30 cm per evitar interferències.

- **Cablejat elèctric:** Seran els cables que portaran l'electricitat als servidors i al SAI. Cada element tindrà el seu propi circuit elèctric independent, de manera que si falla un circuit no afectarà la resta. Tots els cables estaran identificats amb colors i etiquetes als dos extrems perquè sigui fàcil saber a on va cada cable.

- **Gestió interna als racks:** Dins de cada rack, els cables estaran organitzats amb guies i brides perquè no quedin penjant ni desordenats. A més, tots els cables tindran una etiqueta amb un codi als dos extrems, de manera que qualsevol tècnic podrà identificar ràpidament a on va cada cable sense haver de seguir-lo d'un extrem a l'altre.

---

## 1.3 Sistemes de climatització

La temperatura s'haurà de mantenir al voltant dels 22 °C, sense baixar de 18 °C ni superar els 27 °C. La humitat de l'aire s'haurà de mantenir al 50 %, ja que un ambient massa sec pot generar electricitat estàtica que danya els components, i un ambient massa humit pot provocar condensació. Finalment, l'aire de la sala passarà per filtres HEPA F7 que retindran la pols i les partícules, i es renovaran cada 6 mesos per mantenir la seva eficàcia.

S'instal·larà un sistema de climatització específic per a sales de servidors, anomenat CRAC (Computer Room Air Conditioner), que tindrà una capacitat suficient per absorbir tota la calor que generaran els 2 racks en funcionament.

El CRAC enviarà l'aire fred per sota del terra tècnic, que pujarà verticalment a través de les reixetes situades al terra del passadís fred, davant dels racks. Els servidors aspiraran aquest aire fred per la part frontal, el faran passar pels seus components interns per refredar-los, i l'expulsaran ja calent per la part posterior cap al passadís calent. El CRAC l'aspirarà, el refredarà de nou i el tornarà a enviar per sota del terra tècnic, tancant així el circuit de forma contínua.

Per garantir que la climatització no falli mai, hi haurà una segona unitat de reserva que s'engegà automàticament si la principal deixa de funcionar. A més, hi haurà sensors de temperatura i humitat en 3 punts de la sala que enviaran alertes al responsable de sistemes si els valors surten del rang acceptable.

**Organització passadís fred / calent**

Els racks s'organitzaran alineats amb la part frontal orientada cap al passadís fred, per on arribarà l'aire fred que puja des del terra tècnic, i la part posterior orientada cap al passadís calent, on s'acumularà l'aire calent expulsat pels servidors. Als laterals hi haurà panells físics que separaran els dos passadissos per evitar que l'aire fred i l'aire calent es barregin, permetent que el sistema treballi de forma molt més eficient i estalviant fins a un 30 % d'energia respecte a una distribució desordenada.

---

## 1.4 Infraestructura IT — Racks i servidors

### 1.4.1 Rack 1 — Comunicacions i xarxa

| Posició (U) | Equipament |
|---|---|
| 1 – 2 | Patch panel Cat6A (48 ports) × 2 |
| 3 | Switch core (24 ports GbE + 4 SFP+ uplinks) |
| 4 | Switch d'accés (24 ports GbE) |
| 5 | Router / Firewall (pfSense — appliance) |
| 6 | ODF — Optical Distribution Frame (fibra òptica) |
| 7 – 39 | Espai reservat per a creixement futur |
| 40 – 42 | PDU (Power Distribution Unit) × 2 |

El Router/Firewall pfSense, a més de les funcions de tallafocs perimetral, assumeix els serveis de DNS intern, DHCP i VPN (WireGuard), el que ens permet prescindir d'aquest servei dintre d'un servidor dedicat.

### 1.4.2 Rack 2 — Servidors

El Rack 2 allotja els 6 servidors de producció que donen servei a tota la infraestructura, el NAS per a l'emmagatzematge i backups, i el SAI per a la continuïtat elèctrica.

| Posició (U) | Equipament |
|---|---|
| 1 | Servidor S1: Dell PowerEdge R350 (1U) — Directori actiu (OpenLDAP) |
| 2 | Servidor S2: Dell PowerEdge R350 (1U) — Base de dades (MariaDB) |
| 3 | Servidor S3: Dell PowerEdge R550 (1U) — Streaming de vídeo + Jitsi Meet |
| 4 | Servidor S4: Dell PowerEdge R350 (1U) — Streaming d'àudio (Icecast2) |
| 5 | Servidor S5: Dell PowerEdge R350 (1U) — Servei web (Apache2) + SFTP |
| 6 | Servidor S6: Dell PowerEdge R350 (1U) — Centralització de logs (Syslog-ng) |
| 7 | NAS: Synology RS1221+ — Emmagatzematge i backups locals |
| 8 – 37 | Espai reservat per a creixement futur |
| 38 – 42 | SAI rack: APC Smart-UPS 3000VA LCD RM 2U |

### 1.4.3 Especificacions dels servidors

S3 (Vídeo + Jitsi) utilitza un model Dell PowerEdge R550 de major potència per gestionar la càrrega de processament de vídeo en temps real i les videoconferències simultànies. La resta de servidors utilitzen Dell PowerEdge R350, suficients per als seus serveis respectius.

|  | Model | CPU | RAM | Disc | Funció |
|---|---|---|---|---|---|
| **S1** | Dell PowerEdge R350 | Xeon E-2336 (6C) | 32 GB ECC | 2× 960 GB SSD RAID 1 | Directori actiu (OpenLDAP) |
| **S2** | Dell PowerEdge R350 | Xeon E-2336 (6C) | 32 GB ECC | 2× 960 GB SSD RAID 1 | Base de dades (MariaDB) |
| **S3** | Dell PowerEdge R550 | Xeon Silver 4310 (12C) | 64 GB ECC | 2× 960 GB SSD RAID 1 | Streaming vídeo + Jitsi Meet |
| **S4** | Dell PowerEdge R350 | Xeon E-2336 (6C) | 32 GB ECC | 2× 960 GB SSD RAID 1 | Streaming àudio (Icecast2) |
| **S5** | Dell PowerEdge R350 | Xeon E-2336 (6C) | 32 GB ECC | 2× 960 GB SSD RAID 1 | Servidor web (Apache2) + SFTP |
| **S6** | Dell PowerEdge R350 | Xeon E-2336 (6C) | 32 GB ECC | 2× 1 TB SSD RAID 1 | Centralització de logs |
| **NAS** | Synology RS1221+ | Ryzen V1500B | 4 GB DDR4 | 4× 4 TB HDD RAID 5 | Emmagatzematge · Backups |

### 1.4.4 Descripció dels servidors

#### S1 — Directori actiu (OpenLDAP)

Centralitza la gestió d'usuaris i permisos de tota la infraestructura. Els servidors S5 (Web/SFTP) i S2 (BBDD) s'autentiquen contra S1, de manera que un sol compte d'usuari dona accés a tots els serveis. Utilitza LDAP per a la consulta i LDAPS (port 636) per a les connexions xifrades.

#### S2 — Base de dades (MariaDB)

Allotja la base de dades corporativa que gestiona empleats, clients i l'activitat dels serveis. Únicament accessible des del servidor web S5. Es fan còpies de seguretat nocturnes al NAS.

#### S3 — Streaming de vídeo + Jitsi Meet

Distribueix continguts de vídeo en streaming i ofereix videoconferències corporatives (Jitsi Meet). És el servidor de major potència del rack (12 nuclis, 64 GB RAM) per gestionar múltiples connexions simultànies de vídeo en temps real.

#### S4 — Streaming d'àudio (Icecast2)

Distribueix continguts d'àudio en streaming. S'allotja en un servidor independent de S3 per garantir que un pic de demanda en vídeo no afecti la qualitat del servei d'àudio.

#### S5 — Servidor web (Apache2) + SFTP

Allotja el lloc web corporatiu (Apache2) i el servei de transferència segura de fitxers (SFTP). L'autenticació del SFTP es fa contra el directori actiu OpenLDAP de S1, de manera que els mateixos usuaris corporatius poden accedir al servei sense comptes addicionals.

#### S6 — Centralització de logs (Syslog-ng)

Recull els logs de tots els servidors del CPD mitjançant Syslog-ng. Disposa de 1 TB de disc per emmagatzemar l'historial de logs.

#### NAS — Synology RS1221+

Emmagatzematge centralitzat en RAID 5 (12 TB útils de 16 TB bruts). Guarda els backups diaris, setmanals i mensuals de tots els servidors, i les gravacions de les càmeres de seguretat. No executa cap servei de producció, únicament actua com a magatzem de dades.

---

## 1.5 Infraestructura elèctrica i SAI

Farem una instal·lació en doble línia elèctrica, és a dir, dues línies independents que surten dels quadres elèctrics diferents de l'edifici. Per si el quadre de la línia A pateix una avaria o s'ha d'apagar per fer-hi manteniment, la línia B continua donant energia sense interrupcions.

Els racks aniran amb 2 PDUs (Power Distribution Unit) connectades a les línies elèctriques. Cada servidor té dos cables d'alimentació, un a cada PDU, de manera que si falla una línia el servidor continua funcionant per l'altra. El circuit és dedicat exclusivament als servidors, amb proteccions magnetotèrmiques i diferencials independents per a cada circuit.

### 1.5.2 SAI — Càlcul de consum i autonomia

| Equipament | Consum estimat |
|---|---|
| Servidor S1 (Dell R350) | 350 W |
| Servidor S2 (Dell R350) | 350 W |
| Servidor S3 (Dell R550) | 450 W |
| Servidor S4 (Dell R350) | 350 W |
| Servidor S5 (Dell R350) | 350 W |
| Servidor S6 (Dell R350) | 350 W |
| NAS Synology RS1221+ | 100 W |
| Switch core | 50 W |
| Switch d'accés | 30 W |
| Router / Firewall | 40 W |
| Il·luminació d'emergència | 30 W |
| **TOTAL ESTIMAT** | **2.450 W** |

Donada la càrrega total de 2.450 W, es despleguen dos SAI en paral·lel: 2× APC Smart-UPS 3000VA LCD RM 2U (rack-mount), un per a cada línia elèctrica, distribuint la càrrega i garantint redundància elèctrica completa.

Amb les bateries internes que vénen de sèrie, s'obtenen aproximadament 20-25 minuts d'autonomia a plena càrrega, suficients per activar un generador extern o fer una parada controlada. En cas de voler augmentar l'autonomia fins a 60-90 minuts, es pot afegir una bateria externa APC SUA48RMXLBP.

---

## 1.6 Seguretat física

Per mantenir un cert control en l'accés realitzarem les següents mesures:

- Porta d'acer amb pany electrònic: targeta RFID + PIN de 6 dígits (doble factor).
- Accés restringit al personal de sistemes i responsable de seguretat. Proveïdors amb supervisió obligatòria.
- Registre complet de tots els intents d'accés (autoritzats i denegats): data, hora i usuari.

### Videovigilància

| Càmera | Ubicació | Cobertura |
|---|---|---|
| CAM-01 | Exterior porta CPD | Entrada i passadís d'accés |
| CAM-02 | Interior — zona frontal | Part frontal dels 2 racks |
| CAM-03 | Interior — zona posterior | Part posterior racks i sortida emergència |

Les càmeres han de complir amb els següents requisits:

- Resolució 1080p amb visió nocturna per infrarojos.
- Gravació contínua 24/7 amb retenció mínima de 30 dies al NAS local.
- Alertes en temps real per detecció de moviment fora d'horari laboral.

### Prevenció, detecció i extinció d'incendis

- Detecció precoç VESDA (Very Early Smoke Detection Apparatus): sondes al terra tècnic, dins dels racks i al sostre tècnic.
- Extinció per gas inert FM-200: suprimeix el foc sense danyar l'equipament ni generar residus. Activació automàtica amb retard de 30 s per permetre l'evacuació.
- Detectors tèrmics als racks: alarma si se superen els 35 °C.
- 2 extintors de CO2 manuals a les dues sortides de la sala.

### Vies d'evacuació

- Sortida principal: porta d'entrada, que obre des de l'interior sense clau ni codi (barra antipànic).
- Senyalització lluminosa d'emergència activa 24 h amb bateria de respaldo integrada.
- 2 llums d'emergència autònomes que s'activen en cas de tall elèctric.
- Protocol d'evacuació escrit: ordre de parada dels sistemes crítics i punt de trobada exterior.

### Prevenció de riscos laborals (PRL)

| Risc | Mesures aplicades |
|---|---|
| Elèctric | Cables i connexions conforme IEC 60364. Prohibit treballar en tensió sense EPI. |
| Ergonòmic | Espai mínim 1 m davant i darrere dels racks. Equipament pesant a posicions inferiors. |
| Gas d'extinció | Evacuació obligatòria abans d'activar FM-200. Senyalització de perill a totes les entrades. |
| Temperatura | Manteniment entre 18 i 27 °C per al personal que treballa a la sala. |
| Formació | Formació anual per a tot el personal de sistemes sobre riscos i protocols d'emergència. |

---

## 1.7 Seguretat lògica

### Control d'accés per autorització

Realitzarem l'autenticació amb usuari específic i clau pública/privada SSH, consistent a assignar un compte personal i exclusiu a cada tècnic, eliminant l'ús de contrasenyes tradicionals en favor de fitxers de claus criptogràfiques complexes. Aquesta mesura es justifica perquè fa totalment inviables els atacs automatitzats de força bruta a Internet i, alhora, garanteix una traçabilitat absoluta, permetent auditar amb total certesa quina persona ha realitzat cada acció dins dels servidors.

L'accés el farem de manera remota, únicament via VPN (mitjançant WireGuard), un sistema que obliga qualsevol connexió externa a validar-se primer a través d'un túnel digital xifrat abans de poder veure o interactuar amb els servidors. L'ús d'aquesta eina està justificat perquè permet amagar completament la infraestructura d'Internet públic, reduint dràsticament la superfície d'atac i evitant que usuaris no autoritzats puguin detectar o llançar atacs directes contra els equips.

Seguirem el principi de mínim privilegi, una política de seguretat que restringeix els permisos d'accés de cada usuari exclusivament a les funcions, carpetes i eines que són estrictament necessàries per a la seva feina. Aquesta pràctica es justifica com una mesura de contenció essencial, ja que si un treballador comet un error o el seu compte resulta compromès per un ciberatac, l'impacte queda limitat a la seva àrea.

### Firewall

CPD físic: pfSense, amb regles de filtratge per IP, port i protocol. A més del tallafocs, gestiona els serveis de DNS intern, DHCP i VPN (WireGuard). Política per defecte: tot bloquejat.

### Monitorització

- **Eina:** Netdata instal·lat al servidor S5, monitoritzant tots els servidors del CPD.
- **Alertes:** notificació per correu i/o Telegram davant de: caiguda de servei, CPU > 90 %, disc > 85 %, temperatura > 30 °C.
- **Logs centralitzats:** tots els servidors envien logs a S6 (Syslog-ng).

### Còpies de seguretat (Backups)

L'emmagatzematge de totes les còpies de seguretat recau íntegrament sobre el NAS Synology RS1221+ en RAID 5. Aquesta decisió elimina la necessitat d'un servidor dedicat a backup, ja que el NAS ofereix capacitat i redundància suficients per als backups diaris, setmanals i mensuals de tots els servidors.

| Tipus | Freqüència | Destí | Retenció |
|---|---|---|---|
| Backup incremental diari | Cada nit a les 02:00 | NAS local (RAID 5) | 30 dies |
| Backup setmanal complet | Cada diumenge a les 03:00 | NAS local (RAID 5) | 3 mesos |
| Backup mensual | Primer diumenge de mes | NAS local (disc dedicat) | 1 any |

### RAID

| Servidor | RAID | Justificació |
|---|---|---|
| S1 – S6 | RAID 1 | Redundància per a tots els serveis de producció. Recuperació immediata sense pèrdua de dades. |
| NAS | RAID 5 (4 discs) | Tolerància a fallada d'1 disc. Capacitat neta: 12 TB útils de 16 TB bruts. |

---

## 1.8 Distribució de serveis

| Servei | Servidor | Justificació |
|---|---|---|
| Directori actiu (OpenLDAP) | S1 | Centralitza usuaris i permisos. Usat per Web, SFTP i BBDD. |
| Base de dades (MariaDB) | S2 | Gestió de dades corporatives. Backup nocturn al NAS. |
| Streaming vídeo + Jitsi | S3 | Distribució de vídeo i videoconferència corporativa. Servidor de major potència per gestionar la càrrega multimèdia. |
| Streaming àudio (Icecast2) | S4 | Distribució d'àudio en streaming. Servei independent per garantir la qualitat. |
| Web (Apache2) + SFTP | S5 | Servidor web corporatiu i transferència segura de fitxers. SFTP autenticat via OpenLDAP (S1). |
| Centralització de logs | S6 | Syslog-ng. Recull logs de tots els servidors. |
| Emmagatzematge i backups | NAS | Synology RS1221+ en RAID 5. Backups de tots els servidors i gravacions de càmeres. |

---

## Plànols sala CPD

### Vista de planta

![Plànol vista de planta](../img/cpd/perfil)

### Perfil

![Plànol perfil](../img/cpd/cpd)


### Diagrama de racks

![Diagrama de racks](../img/cpd/cpd)
