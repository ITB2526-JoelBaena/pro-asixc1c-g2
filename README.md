## 2.2 Servei d'àudio
### 2.2.1 Descripció del servei
El servei d'audio permet la distribució de contingut sonor en temps real (streaming en directe) i sota demanda (on-demand) a través de la xarxa. Funciona amb una arquitectura client-servidor: el servidor rep una font d'àudio, la codifica en un format estàndard i la distribueix a múltiples clients simultàniament.
Per a Innovatech, aquest servei cobrim les necessitats de comunicació interna i distribució de continguts corporatius.
### 2.2.2 Tecnologia escollida: Icecast2
S'ha escollit Icecast2 com a servidor de streaming d'àudio per les raons següents:
És programari lliure i de codi obert, sense cost de llicència.
Suporta els formats MP3, OGG Vorbis i AAC, tots estàndards del sector.
Permet múltiples canals (mount points) simultanis.
Ofereix accés via navegador web sense necessitat de programari addicional al client.
Té documentació àmplia i comunitat activa.
Com a font d'àudio (per injectar el stream al servidor) s'utilitza Liquidsoap, que permet automatitzar la reproducció de fitxers i afegir lògica de programació.
### 2.2.3 Formats d'àudio utilitzats
Format
Bitrate
Ús
MP3
128 kbps
Compatibilitat màxima amb clients
OGG Vorbis
128 kbps
Qualitat superior, lliure de patents
AAC
96 kbps
Optimitzat per a baixa amplada de banda

S'ha escollit MP3 a 128 kbps com a format principal per la seva compatibilitat universal amb navegadors i clients de tots els sistemes operatius.
### 2.2.4 Arquitectura del servei
Font d'àudio (fitxers MP3) → Liquidsoap → Icecast2 → Clients (navegador / VLC / app)
Liquidsoap llegeix els fitxers d'àudio i envia el flux (stream) al servidor Icecast2 via protocol Shoutcast/Icecast.
Icecast2 rep el flux i el redistribueix als clients que es connectin.
Els clients accedeixen mitjançant una URL del tipus http://IP_SERVIDOR:8000/stream.
