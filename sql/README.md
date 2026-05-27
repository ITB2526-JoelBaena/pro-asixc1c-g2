# Scripts SQL - InnovateTech BBDD

## Ordre d'execució recomanat

Per desplegar la base de dades des de zero, executa els scripts en aquest ordre des de MySQL:

```sql
SOURCE crear_taules.sql;
SOURCE crear_rols.sql;
SOURCE permisosrols.sql;
SOURCE insertar_dades.sql;
SOURCE trigger_bloqueig.sql;
SOURCE trigger_trucades_mensuals.sql;
SOURCE trigger_trucadesdiaries.sql;
SOURCE triggeraudit/vendes_audit.sql;
SOURCE triggeraudit/audit_trucades.sql;
SOURCE backup.sql;
```

> **Nota:** Els paths anteriors assumeixen que t'has situat a la carpeta `sql/` abans d'executar els scripts. Ajusta les rutes si cal.

---

## Descripció dels fitxers

| Fitxer | Descripció |
|---|---|
| `bd1.sql` | Script de reset complet. Executa tots els altres scripts en ordre. Conté rutes absolutes del servidor EC2, no és portable a altres entorns. |
| `crear_taules.sql` | Crea les 18 taules de la BD amb totes les restriccions (PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK). Inclou `ALTER TABLE Avisos ENGINE = MyISAM` per garantir el registre d'auditoria. |
| `borrar_taules.sql` | Elimina totes les taules en ordre invers per respectar les dependències entre claus foranes. També elimina els triggers i l'event de backup. |
| `insertar_dades.sql` | Insereix les dades de prova a totes les taules: 5 departaments, 10 empleats, 10 usuaris, 8 clients, 8 trucades, 7 mesures de bandwidth, 8 vídeos, 5 productes i més. |
| `crear_rols.sql` | Crea els 4 rols de la BD: `admin`, `vendes`, `administracio`, `treballador`. Utilitza `IF NOT EXISTS` per evitar errors si ja existeixen. |
| `permisosrols.sql` | Assigna els permisos corresponents a cada rol sobre les taules específiques. |
| `trigger_bloqueig.sql` | Trigger `BEFORE INSERT` a Trucades que impedeix fer o rebre trucades si l'usuari té estat `bloquejat`. |
| `trigger_trucades_mensuals.sql` | Trigger `BEFORE INSERT` a Trucades que controla la quota de minuts mensuals per usuari. |
| `trigger_trucadesdiaries.sql` | Trigger `BEFORE INSERT` a Trucades que controla el nombre màxim de trucades diàries per usuari. |
| `backup.sql` | Crea l'event periòdic `evt_backup_diari` que s'executa cada dia a les 02:00 AM i fa còpies de seguretat en format CSV a `/var/lib/mysql-files/`. |

### Carpeta `triggeraudit/`

| Fitxer | Descripció |
|---|---|
| `vendes_audit.sql` | Trigger `BEFORE UPDATE` a Nomines que registra i bloqueja intents de modificació per part d'usuaris amb rol `vendes` o `treballador`. |
| `audit_trucades.sql` | Trigger `BEFORE INSERT` a Trucades que registra i bloqueja intents d'accés per part d'usuaris amb rol `administracio`. |

---

## Descripció dels scripts Bash

Els scripts Bash es troben a la carpeta `/scripts`.

| Fitxer | Descripció |
|---|---|
| `scriptusuaris.sh` | Automatitza la creació d'usuaris a la BD. Demana el nom, contrasenya, host i rol, executa les sentències SQL i genera un fitxer `usuaris_creats.sql`. Gestiona errors d'usuari ja existent i rol no vàlid. |
| `amplebanda.sh` | Executa `speedtest-cli` automàticament i insereix els resultats a la taula `Mesures_Bandwidth`, classificant el resultat com a acceptable o no acceptable. |
| `notificacions_discord.sh` | Revisa la taula `Avisos` i envia notificacions al canal de Discord via webhook quan detecta nous intents d'accés no autoritzat. |

---

## Notes importants

- Els scripts de triggers utilitzen la funció `USER()` de MySQL per identificar l'usuari connectat. Per garantir el correcte funcionament dels triggers d'auditoria, els usuaris han de seguir la convenció de nom `nomUsuari_rol` (exemple: `marc_vendes`, `anna_administracio`).
- La taula `Avisos` utilitza motor **MyISAM** en lloc d'InnoDB per evitar que els registres d'auditoria es perdin quan un trigger llança un error i MySQL fa rollback.
- L'event de backup utilitza `SELECT INTO OUTFILE` que requereix que MySQL tingui permisos d'escriptura al directori `/var/lib/mysql-files/`.
