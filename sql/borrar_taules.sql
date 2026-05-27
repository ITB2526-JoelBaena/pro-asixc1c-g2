-- Esborrem les taules en ordre invers (primer les que tenen FKs)
DROP TABLE IF EXISTS Backup_Log;
DROP TABLE IF EXISTS Avisos;
DROP TABLE IF EXISTS Quotes_Usuari;
DROP TABLE IF EXISTS Mesures_Bandwidth;
DROP TABLE IF EXISTS Trucades;
DROP TABLE IF EXISTS Cistell;
DROP TABLE IF EXISTS Comandes;
DROP TABLE IF EXISTS Videos;
DROP TABLE IF EXISTS Usuaris;
DROP TABLE IF EXISTS Nomines;
DROP TABLE IF EXISTS Empleats;
DROP TABLE IF EXISTS Productes;
DROP TABLE IF EXISTS Grup_Nivell;
DROP TABLE IF EXISTS Config_Servidor;
DROP TABLE IF EXISTS Grups_Qualitat;
DROP TABLE IF EXISTS Categories_Video;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Departaments;

DROP EVENT IF EXISTS evt_backup_diari;
DROP TRIGGER IF EXISTS trg_bloqueig_usuari;
DROP TRIGGER IF EXISTS trg_control_minuts;
DROP TRIGGER IF EXISTS trg_control_trucades_dia;
DROP TRIGGER IF EXISTS trg_audit_nomines;
DROP TRIGGER IF EXISTS trg_audit_trucades;
