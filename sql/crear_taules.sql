-- SCRIPT CREACIÓ DE TAULES - InnovateTech

USE innovatetech;

-- 1. DEPARTAMENTS
CREATE TABLE Departaments (
    codi_dept   INT             NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(100)    NOT NULL,
    telefon     VARCHAR(15)     NOT NULL,
    
    CONSTRAINT pk_departaments PRIMARY KEY (codi_dept)
);

-- 2. CLIENTS
CREATE TABLE Clients (
    id_client   INT             NOT NULL AUTO_INCREMENT,
    nom_complet VARCHAR(150)    NOT NULL,
    email       VARCHAR(100)    NOT NULL,
    telefon     VARCHAR(15)     NOT NULL,

    CONSTRAINT pk_clients PRIMARY KEY (id_client),
    CONSTRAINT uq_clients_email UNIQUE (email)

);

-- 3. GRUPS_QUALITAT
CREATE TABLE Grups_Qualitat (
    id_grup         INT             NOT NULL AUTO_INCREMENT,
    nom_grup        VARCHAR(20)     NOT NULL,
    qualitat_video  VARCHAR(10)     NOT NULL,
    qualitat_audio  VARCHAR(10)     NOT NULL,
    bandwidth_max   INT             NOT NULL,

    CONSTRAINT pk_grups_qualitat PRIMARY KEY (id_grup),
    CONSTRAINT uq_grups_nom UNIQUE (nom_grup),
    CONSTRAINT chk_nom_grup CHECK (nom_grup IN ('alta', 'mitja', 'baixa'))
);

-- 4. CONFIG_SERVIDOR
CREATE TABLE Config_Servidor (
    id_config   INT             NOT NULL AUTO_INCREMENT,
    parametre   VARCHAR(100)    NOT NULL,
    valor       VARCHAR(200)    NOT NULL,
    protocol    VARCHAR(20)     NOT NULL,
    port        INT             NOT NULL,

    CONSTRAINT pk_config_servidor PRIMARY KEY (id_config),
    CONSTRAINT uq_config_parametre UNIQUE (parametre),
    CONSTRAINT chk_port CHECK (port BETWEEN 1 AND 65535)
);

-- 5. CATEGORIES_VIDEO
CREATE TABLE Categories_Video (
    id_categoria    INT             NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(50)     NOT NULL,

    CONSTRAINT pk_categories_video PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categories_nom UNIQUE (nom)
);

-- 6. PRODUCTES
CREATE TABLE Productes (
    id_producte     INT             NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(100)    NOT NULL,
    descripcio      TEXT,
    preu            DECIMAL(10,2)   NOT NULL,
    estoc           INT             NOT NULL DEFAULT 0,

    CONSTRAINT pk_productes PRIMARY KEY (id_producte),
    CONSTRAINT chk_preu CHECK (preu >= 0),
    CONSTRAINT chk_estoc CHECK (estoc >= 0)
);

-- 7. GRUP_NIVELL
CREATE TABLE Grup_Nivell (
    id_grup_nivell  INT             NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(50)     NOT NULL,
    nivell          INT             NOT NULL,
    descripcio      TEXT,

    CONSTRAINT pk_grup_nivell PRIMARY KEY (id_grup_nivell),
    CONSTRAINT uq_grup_nivell_nom UNIQUE (nom),
    CONSTRAINT chk_nivell CHECK (nivell BETWEEN 1 AND 5)
);

-- 8. EMPLEATS
CREATE TABLE Empleats (
    dni            VARCHAR(9)   NOT NULL,
    nom            VARCHAR(50)  NOT NULL,
    cognoms        VARCHAR(100) NOT NULL,
    adreca         VARCHAR(200) NOT NULL,
    telefon        VARCHAR(15)  NOT NULL,
    codi_dept      INT          NOT NULL,
    id_grup_nivell INT,

    CONSTRAINT pk_empleats PRIMARY KEY (dni),
    CONSTRAINT fk_empleats_dept FOREIGN KEY (codi_dept) REFERENCES Departaments(codi_dept),
    CONSTRAINT fk_empleats_grup_nivell FOREIGN KEY (id_grup_nivell) REFERENCES Grup_Nivell(id_grup_nivell)
);

-- 9. USUARIS
CREATE TABLE Usuaris (
    id_usuari       INT             NOT NULL AUTO_INCREMENT,
    dni             VARCHAR(9)      NOT NULL,
    email           VARCHAR(100)    NOT NULL,
    extensio        VARCHAR(10)     NOT NULL,
    estat           VARCHAR(10)     NOT NULL,
    id_grup_qualitat INT            NOT NULL,

    CONSTRAINT pk_usuaris PRIMARY KEY (id_usuari),
    CONSTRAINT fk_usuaris_empleat FOREIGN KEY (dni) 
        REFERENCES Empleats(dni),
    CONSTRAINT fk_usuaris_grup FOREIGN KEY (id_grup_qualitat) 
        REFERENCES Grups_Qualitat(id_grup),
    CONSTRAINT uq_usuaris_dni UNIQUE (dni),
    CONSTRAINT uq_usuaris_email UNIQUE (email),
    CONSTRAINT uq_usuaris_extensio UNIQUE (extensio),
    CONSTRAINT chk_estat CHECK (estat IN ('actiu', 'bloquejat'))
);

-- 10. NOMINES
CREATE TABLE Nomines (
    id_nomina       INT             NOT NULL AUTO_INCREMENT,
    dni             VARCHAR(9)      NOT NULL,
    mes_any         VARCHAR(7)      NOT NULL,
    salari_base     DECIMAL(10,2)   NOT NULL,
    complements     DECIMAL(10,2)   NOT NULL DEFAULT 0,
    deduccions      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    total_net       DECIMAL(10,2)   NOT NULL,

    CONSTRAINT pk_nomines PRIMARY KEY (id_nomina),
    CONSTRAINT fk_nomines_empleat FOREIGN KEY (dni)
        REFERENCES Empleats(dni),
    CONSTRAINT uq_nomines_dni_mes UNIQUE (dni, mes_any),
    CONSTRAINT chk_salari CHECK (salari_base > 0),
    CONSTRAINT chk_mes_any_nomina CHECK (mes_any REGEXP '^[0-9]{4}-[0-9]{2}$')
);

-- 11. VIDEOS
CREATE TABLE Videos (
    id_video        INT             NOT NULL AUTO_INCREMENT,
    titol           VARCHAR(200)    NOT NULL,
    descripcio      TEXT,
    id_categoria    INT             NOT NULL,
    duracio         INT             NOT NULL,
    data_publicacio DATE            NOT NULL,
    url_streaming   VARCHAR(500)    NOT NULL,

    CONSTRAINT pk_videos PRIMARY KEY (id_video),
    CONSTRAINT fk_videos_categoria FOREIGN KEY (id_categoria)
        REFERENCES Categories_Video(id_categoria),
    CONSTRAINT uq_videos_url UNIQUE (url_streaming)
);

-- 12. COMANDES
CREATE TABLE Comandes (
    id_comanda      INT             NOT NULL AUTO_INCREMENT,
    id_client       INT             NOT NULL,
    data_comanda    DATETIME        NOT NULL DEFAULT NOW(),
    estat           VARCHAR(20)     NOT NULL DEFAULT 'pendent',
    total           DECIMAL(10,2)   NOT NULL DEFAULT 0,

    CONSTRAINT pk_comandes PRIMARY KEY (id_comanda),
    CONSTRAINT fk_comandes_client FOREIGN KEY (id_client)
        REFERENCES Clients(id_client),
    CONSTRAINT chk_estat_comanda CHECK (estat IN ('pendent', 'processada', 'enviada', 'completada', 'cancel·lada')),
    CONSTRAINT chk_total CHECK (total >= 0)
);

-- 13. CISTELL
CREATE TABLE Cistell (
    id_cistell      INT             NOT NULL AUTO_INCREMENT,
    id_comanda      INT             NOT NULL,
    id_producte     INT             NOT NULL,
    quantitat       INT             NOT NULL DEFAULT 1,
    preu_unitari    DECIMAL(10,2)   NOT NULL,

    CONSTRAINT pk_cistell PRIMARY KEY (id_cistell),
    CONSTRAINT fk_cistell_comanda FOREIGN KEY (id_comanda)
        REFERENCES Comandes(id_comanda),
    CONSTRAINT fk_cistell_producte FOREIGN KEY (id_producte)
        REFERENCES Productes(id_producte),
    CONSTRAINT chk_quantitat CHECK (quantitat > 0),
    CONSTRAINT chk_preu_unitari CHECK (preu_unitari >= 0)
);

-- 14. TRUCADES
CREATE TABLE Trucades (
    id_trucada          INT             NOT NULL AUTO_INCREMENT,
    id_usuari_origen    INT             NOT NULL,
    id_client_desti     INT,
    id_usuari_desti     INT,
    data_inici          DATETIME        NOT NULL,
    data_fi             DATETIME,
    duracio_minuts      DECIMAL(10,2),
    id_grup_qualitat    INT             NOT NULL,
    valoracio           INT,
    comentari           TEXT,

    CONSTRAINT pk_trucades PRIMARY KEY (id_trucada),
    CONSTRAINT fk_trucades_origen FOREIGN KEY (id_usuari_origen)
        REFERENCES Usuaris(id_usuari),
    CONSTRAINT fk_trucades_client FOREIGN KEY (id_client_desti)
        REFERENCES Clients(id_client),
    CONSTRAINT fk_trucades_usuari_desti FOREIGN KEY (id_usuari_desti)
        REFERENCES Usuaris(id_usuari),
    CONSTRAINT fk_trucades_qualitat FOREIGN KEY (id_grup_qualitat)
        REFERENCES Grups_Qualitat(id_grup),
    CONSTRAINT chk_desti CHECK (
        id_client_desti IS NOT NULL OR id_usuari_desti IS NOT NULL
    ),
    CONSTRAINT chk_valoracio CHECK (valoracio BETWEEN 1 AND 5)
);

-- 15. MESURES_BANDWIDTH
CREATE TABLE Mesures_Bandwidth (
    id_mesura           INT             NOT NULL AUTO_INCREMENT,
    data_hora           DATETIME        NOT NULL,
    id_usuari_operari   INT             NOT NULL,
    equip_mesurat       VARCHAR(100)    NOT NULL,
    velocitat_baixada   DECIMAL(10,2)   NOT NULL,
    velocitat_pujada    DECIMAL(10,2)   NOT NULL,
    latencia            DECIMAL(10,2)   NOT NULL,
    resultat            VARCHAR(20)     NOT NULL,
    notes               TEXT,

    CONSTRAINT pk_mesures_bandwidth PRIMARY KEY (id_mesura),
    CONSTRAINT fk_mesures_operari FOREIGN KEY (id_usuari_operari)
        REFERENCES Usuaris(id_usuari),
    CONSTRAINT chk_resultat CHECK (resultat IN ('acceptable', 'no acceptable')),
    CONSTRAINT chk_velocitat_baixada CHECK (velocitat_baixada >= 0),
    CONSTRAINT chk_velocitat_pujada CHECK (velocitat_pujada >= 0),
    CONSTRAINT chk_latencia CHECK (latencia >= 0)
);

-- 16. QUOTES_USUARI
CREATE TABLE Quotes_Usuari (
    id_quota            INT             NOT NULL AUTO_INCREMENT,
    id_usuari           INT             NOT NULL,
    mes_any             VARCHAR(7)      NOT NULL,
    minuts_consumits    DECIMAL(10,2)   NOT NULL DEFAULT 0,
    trucades_avui       INT             NOT NULL DEFAULT 0,
    limit_minuts_mes    INT             NOT NULL,
    limit_trucades_dia  INT             NOT NULL,

    CONSTRAINT pk_quotes_usuari PRIMARY KEY (id_quota),
    CONSTRAINT fk_quotes_usuari FOREIGN KEY (id_usuari)
        REFERENCES Usuaris(id_usuari),
    CONSTRAINT uq_quotes_usuari_mes UNIQUE (id_usuari, mes_any),
    CONSTRAINT chk_mes_any CHECK (mes_any REGEXP '^[0-9]{4}-[0-9]{2}$'),
    CONSTRAINT chk_minuts CHECK (minuts_consumits >= 0),
    CONSTRAINT chk_trucades CHECK (trucades_avui >= 0)
);

-- 17. AVISOS
CREATE TABLE Avisos (
    id_avis         INT             NOT NULL AUTO_INCREMENT,
    usuari_db       VARCHAR(100)    NOT NULL,
    taula_afectada  VARCHAR(100)    NOT NULL,
    operacio        VARCHAR(10)     NOT NULL,
    data_hora       DATETIME        NOT NULL DEFAULT NOW(),
    descripcio      TEXT,

    CONSTRAINT pk_avisos PRIMARY KEY (id_avis),
    CONSTRAINT chk_operacio CHECK (operacio IN ('INSERT', 'UPDATE', 'DELETE', 'SELECT'))
);
ALTER TABLE Avisos ENGINE = MyISAM;

-- 18. BACKUP_LOG
CREATE TABLE Backup_Log (
    id_backup       INT             NOT NULL AUTO_INCREMENT,
    data_hora       DATETIME        NOT NULL DEFAULT NOW(),
    taules_incloses TEXT            NOT NULL,
    resultat        VARCHAR(20)     NOT NULL,

    CONSTRAINT pk_backup_log PRIMARY KEY (id_backup),
    CONSTRAINT chk_resultat_backup CHECK (resultat IN ('correcte', 'error'))
);
