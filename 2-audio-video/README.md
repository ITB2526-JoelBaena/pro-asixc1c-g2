# 2. Implantació dels serveis d'àudio i vídeo

## 2.1 Descripció general

InnovateTech requereix una infraestructura de serveis multimèdia dins del seu CPD per donar suport a la comunicació interna, la formació corporativa i la distribució de continguts als clients. Aquesta infraestructura permet:

| Servei | Protocol | Port |
|--------|----------|------|
| Streaming d'àudio | Icecast2 / MP3 | 8000 |
| Streaming de vídeo | RTMP / HLS | 1935 / 8080 |
| Videoconferència | WebRTC | 443 / 10000 UDP |

Tots els serveis s'han desplegat sobre instàncies EC2 d'AWS amb Ubuntu 24.04 LTS, utilitzant tecnologies estàndard d'entorn empresarial.

---

## 2.2 Servei d'àudio

### 2.2.1 Descripció del servei

El servei d'àudio permet la distribució de contingut sonor en temps real (streaming en directe) i sota demanda (on-demand) a través de la xarxa. Funciona amb una arquitectura client-servidor: el servidor rep una font d'àudio, la codifica en un format estàndard i la distribueix a múltiples clients simultàniament.

Per a InnovateTech, aquest servei cobreix les necessitats de comunicació interna i distribució de continguts corporatius.

### 2.2.2 Tecnologia escollida: Icecast2 + Liquidsoap

S'ha escollit **Icecast2** com a servidor de streaming d'àudio per les raons següents:

- Programari lliure i de codi obert, sense cost de llicència.
- Suporta els formats MP3, OGG Vorbis i AAC, tots estàndards del sector.
- Permet múltiples canals (mount points) simultanis.
- Ofereix accés via navegador web sense necessitat de programari addicional.
- Documentació àmplia i comunitat activa.

Com a font d'àudio s'utilitza **Liquidsoap**, que permet automatitzar la reproducció de fitxers i afegir lògica de programació.

### 2.2.3 Formats d'àudio utilitzats

| Format | Bitrate | Ús |
|--------|---------|----|
| MP3 | 128 kbps | Compatibilitat màxima amb clients |
| OGG Vorbis | 128 kbps | Qualitat superior, lliure de patents |
| AAC | 96 kbps | Optimitzat per a baixa amplada de banda |

S'ha escollit **MP3 a 128 kbps** com a format principal per la seva compatibilitat universal amb navegadors i clients de tots els sistemes operatius.

### 2.2.4 Arquitectura del servei

```
Fitxers MP3 → Liquidsoap → Icecast2 (port 8000) → Clients (navegador / VLC)
```

- **Liquidsoap** llegeix els fitxers d'àudio i envia el flux al servidor Icecast2 via protocol Shoutcast/Icecast.
- **Icecast2** rep el flux i el redistribueix als clients que es connectin.
- Els clients accedeixen mitjançant: `http://IP_SERVIDOR:8000/stream`

### 2.2.5 Instal·lació i configuració

**Instal·lació dels paquets:**
```bash
sudo apt-get update -y
sudo apt-get install -y icecast2 liquidsoap
```

**Configuració d'Icecast2** (`/etc/icecast2/icecast.xml`):
```xml
<authentication>
    <source-password>Aneto_3404</source-password>
    <relay-password>Aneto_3404</relay-password>
    <admin-user>admin</admin-user>
    <admin-password>Aneto_3404</admin-password>
</authentication>
<hostname>localhost</hostname>
```

**Configuració de Liquidsoap** (`/home/admintech_audio/liquidsoap.liq`):
```liquidsoap
#!/usr/bin/liquidsoap

log.file.path := "/var/log/liquidsoap/innovatetech.log"
log.level := 3

audio_source = playlist(
  mode="randomize",
  reload=3600,
  "/home/admintech_audio/audio"
)

audio_safe = fallback(
  track_sensitive=false,
  [audio_source, blank()]
)

audio_final = normalize(audio_safe)

output.icecast(
  %mp3(
    bitrate=128,
    samplerate=44100,
    stereo=true
  ),
  host="localhost",
  port=8000,
  password="Aneto_3404",
  mount="/stream",
  name="InnovateTech Radio - MP3",
  description="Canal principal d'àudio corporatiu InnovateTech",
  genre="Corporate",
  url="http://localhost:8000",
  public=false,
  audio_final
)
```

**Iniciar els serveis:**
```bash
sudo systemctl enable icecast2
sudo systemctl start icecast2
liquidsoap /home/admintech_audio/liquidsoap.liq &
```

### 2.2.6 Comprovació del servei

**Verificació de l'estat:**
```bash
sudo systemctl status icecast2
```

**Accés via navegador:**
- Panell d'administració: `http://IP_SERVIDOR:8000`
- Stream d'àudio: `http://IP_SERVIDOR:8000/stream`

![Panell Icecast2 actiu amb stream funcionant](./capturas/capturaXX.png)

> **Validació:** Stream d'àudio reproduint-se en temps real, accessible des del navegador i clients VLC.

---

## 2.3 Servei de vídeo

### 2.3.1 Descripció del servei

El servei de vídeo permet la distribució de contingut audiovisual en temps real (streaming en directe) i sota demanda (fitxers MP4). NGINX converteix el stream RTMP a HLS, compatible amb qualsevol navegador modern sense necessitat de programari addicional.

### 2.3.2 Tecnologia escollida: NGINX amb mòdul RTMP

S'ha escollit **NGINX amb el mòdul RTMP** per les raons següents:

- Programari lliure i de codi obert, sense cost de llicència.
- Suporta els protocols RTMP (recepció) i HLS (distribució als clients).
- Permet servir vídeos sota demanda (fitxers MP4) des del mateix servidor.
- Lleuger i eficient en consum de recursos.
- Estàndard en entorns empresarials.

### 2.3.3 Formats i còdecs utilitzats

| Format | Còdec | Ús |
|--------|-------|----|
| MP4 | H.264 | Vídeo sota demanda i streaming |
| HLS (.m3u8) | H.264 | Distribució als navegadors |
| RTMP | H.264 | Recepció del stream des de ffmpeg |

S'ha escollit **H.264** com a còdec principal per la seva compatibilitat universal amb navegadors, dispositius mòbils i reproductors de vídeo.

### 2.3.4 Protocols utilitzats

**RTMP (Real-Time Messaging Protocol):** Protocol usat per enviar el stream de vídeo des de ffmpeg cap al servidor NGINX. Funciona pel port 1935 i és el protocol estàndard per a la publicació de streams en entorns professionals.

**HLS (HTTP Live Streaming):** Protocol usat per distribuir el vídeo als clients. NGINX converteix automàticament el stream RTMP a HLS. El client rep fragments de vídeo de curta durada (`.ts`) i una llista de reproducció (`.m3u8`). Funciona pel port 8080 i és compatible amb qualsevol navegador modern.

### 2.3.5 Instal·lació i configuració

**Instal·lació dels paquets:**
```bash
sudo apt-get install -y nginx libnginx-mod-rtmp ffmpeg
sudo mkdir -p /home/admintech_video/videos
sudo mkdir -p /tmp/hls
```

**Configuració de NGINX** (`/etc/nginx/nginx.conf`):
```nginx
load_module modules/ngx_rtmp_module.so;

user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3s;
            hls_playlist_length 60s;
        }

        application vod {
            play /home/admintech_video/videos;
        }
    }
}

http {
    sendfile on;
    tcp_nopush on;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 8080;

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }

        location /videos {
            alias /home/admintech_video/videos;
            autoindex on;
            mp4;
            mp4_buffer_size 1m;
            mp4_max_buffer_size 5m;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }
    }

    include /etc/nginx/sites-enabled/*.conf;
}
```

**Publicar stream amb ffmpeg:**
```bash
ffmpeg -re -stream_loop -1 -i /home/admintech_video/videos/prova.mp4 \
  -c copy -f flv rtmp://localhost:1935/live/stream
```

### 2.3.6 Comprovació del servei

**Verificació de l'estat:**
```bash
sudo systemctl status nginx
```

**Accés als serveis:**
- Vídeo sota demanda: `http://IP_SERVIDOR:8080/videos/prova.mp4`
- Stream HLS: `http://IP_SERVIDOR:8080/hls/stream.m3u8`

![Vídeo prova.mp4 reproduint-se al navegador](./capturas/capturaXX.png)

![Stream HLS reproduint-se al VLC](./capturas/capturaXX.png)

> **Validació:** Vídeo accessible des del navegador web i des de VLC mitjançant el protocol HLS.

---

## 2.4 Servei de videoconferència

### 2.4.1 Descripció del servei

El servei de videoconferència permet la comunicació en temps real entre múltiples usuaris mitjançant àudio i vídeo. Està orientat a la comunicació interna d'InnovateTech i a sessions de formació corporativa.

### 2.4.2 Tecnologia escollida: Jitsi Meet

S'ha escollit **Jitsi Meet** per les raons següents:

- Programari lliure i de codi obert, sense cost de llicència.
- No requereix instal·lació de cap aplicació als clients: funciona directament des del navegador.
- Suporta videoconferències de múltiples participants simultanis.
- Inclou funcionalitats corporatives: compartir pantalla, xat, gravació.
- Solució de videoconferència autogestionada més estesa en entorns empresarials.

### 2.4.3 Protocol utilitzat: WebRTC

**WebRTC (Web Real-Time Communication)** és el protocol que usa Jitsi Meet per transmetre àudio i vídeo entre els participants:

- Comunicació directa entre navegadors sense necessitat de plugins.
- Xifrat extrem a extrem de l'àudio i el vídeo.
- Adaptació automàtica de la qualitat segons l'amplada de banda disponible.
- Funciona sobre UDP (port 10000) per minimitzar la latència.

### 2.4.4 Components de Jitsi Meet

| Component | Funció |
|-----------|--------|
| **Jitsi Meet** | Interfície web del client |
| **Jicofo** | Gestor de conferències (focus) |
| **Jitsi Videobridge (JVB)** | Servidor de vídeo WebRTC |
| **Prosody** | Servidor XMPP per a la senyalització |

### 2.4.5 Instal·lació i configuració

**Preparació de Lua 5.4** (requerit per Prosody a Ubuntu 24.04):
```bash
sudo apt-get install -y lua5.4 liblua5.4-dev
sudo update-alternatives --install /usr/bin/lua lua-interpreter /usr/bin/lua5.4 200
```

**Repositori i instal·lació de Prosody:**
```bash
wget https://prosody.im/files/prosody-debian-packages.key -O /tmp/prosody.key
sudo gpg --dearmor -o /usr/share/keyrings/prosody.gpg /tmp/prosody.key
echo "deb [signed-by=/usr/share/keyrings/prosody.gpg] http://packages.prosody.im/debian noble main" \
  | sudo tee /etc/apt/sources.list.d/prosody.list
sudo apt-get update -y
sudo apt-get install -y prosody
```

**Configuració mínima de Prosody** (`/etc/prosody/prosody.cfg.lua`):
```lua
admins = { }
modules_enabled = {
    "roster"; "saslauth"; "tls"; "dialback"; "disco";
    "carbons"; "pep"; "private"; "blocklist";
    "version"; "uptime"; "time"; "ping"; "register";
}
allow_registration = false
c2s_require_encryption = false
s2s_require_encryption = false
authentication = "internal_hashed"
pidfile = "/run/prosody/prosody.pid"
log = {
    info = "/var/log/prosody/prosody.log";
    error = "/var/log/prosody/prosody.err";
}
data_path = "/var/lib/prosody"

VirtualHost "localhost"
```

**Repositori i instal·lació de Jitsi Meet:**
```bash
curl -fsSL https://download.jitsi.org/jitsi-key.gpg.key \
  | sudo gpg --dearmor -o /usr/share/keyrings/jitsi.gpg
echo "deb [signed-by=/usr/share/keyrings/jitsi.gpg] https://download.jitsi.org stable/" \
  | sudo tee /etc/apt/sources.list.d/jitsi-stable.list
sudo apt-get update -y
sudo apt-get install -y jitsi-meet
```

> Durant la instal·lació s'introdueix la IP pública com a domini i es genera un certificat self-signed.

**Integració amb NGINX existent** — afegir al bloc `http` de `/etc/nginx/nginx.conf`:
```nginx
include /etc/nginx/sites-enabled/*.conf;
```

### 2.4.6 Comprovació del servei

**Verificació de l'estat de tots els components:**
```bash
sudo systemctl status prosody
sudo systemctl status jicofo
sudo systemctl status jitsi-videobridge2
sudo systemctl status nginx
```

**Ports actius:**
```bash
sudo ss -tlnp | grep -E "443|80|10000"
```

| Port | Servei | Protocol |
|------|--------|----------|
| 80 | NGINX (redirect a HTTPS) | TCP |
| 443 | Jitsi Meet (HTTPS) | TCP |
| 8080 | NGINX vídeo | TCP |
| 10000 | Jitsi Videobridge | UDP |

**Accés al servei:** `https://IP_SERVIDOR`

![Dues connexions simultànies a la sala Innovatetech de Jitsi Meet](./capturas/captura25.png)

> **Validació:** Dos usuaris (`usuari1` i `usuari2`) connectats simultàniament a la mateixa sala de videoconferència `Innovatetech`.

---

## 2.5 Comprovacions d'amplada de banda

### 2.5.1 Objectiu

Garantir que la infraestructura desplegada és capaç de suportar els serveis d'àudio, vídeo i videoconferència sense degradació del servei.

### 2.5.2 Instal·lació de l'eina de mesura

```bash
sudo apt-get install -y speedtest-cli
```

### 2.5.3 Resultats de les proves

> ⚠️ *Secció pendent de completar — proves a realitzar el dia següent.*

**Prova 1:**
```
# Inserir sortida de: speedtest-cli
```

**Prova 2:**
```
# Inserir sortida de: speedtest-cli
```

### 2.5.4 Anàlisi dels resultats

| Servei | Ample de banda mínim requerit | Resultat |
|--------|-------------------------------|----------|
| Streaming d'àudio MP3 128kbps | ~0,2 Mbps per client | ✅ / ❌ |
| Streaming de vídeo HLS 360p | ~1 Mbps per client | ✅ / ❌ |
| Videoconferència WebRTC | ~1,5 Mbps per participant | ✅ / ❌ |

### 2.5.5 Classificació del sistema

> ⚠️ *Pendent de completar amb els resultats reals.*

- **Download:** X Mbps
- **Upload:** X Mbps  
- **Latència:** X ms
- **Classificació:** Acceptable / No acceptable

### 2.5.6 Conclusió tècnica

> ⚠️ *Pendent de completar.*

---

## 2.6 Incidències i solucions

| Incidència | Causa | Solució |
|------------|-------|---------|
| Prosody no arrencava | Conflicte entre Lua 5.1 i Lua 5.4 a Ubuntu 24.04 | Instal·lar Lua 5.4 des del repositori oficial i forçar la prioritat amb `update-alternatives` |
| Jitsi no escoltava al port 443 | El `nginx.conf` no incloïa el directori `sites-enabled` | Afegir `include /etc/nginx/sites-enabled/*.conf;` al bloc `http` |
| Prosody fallava sense VirtualHost | Fitxer de configuració sense cap `VirtualHost` definit | Afegir `VirtualHost "localhost"` al fitxer de configuració |
