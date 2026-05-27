-- =============================================
-- EVENT DE BACKUP DIARI - InnovateTech
-- =============================================

USE innovatetech;

DROP EVENT IF EXISTS evt_backup_diari;

DELIMITER //

CREATE EVENT evt_backup_diari
ON SCHEDULE EVERY 1 DAY
STARTS '2026-05-27 02:00:00'
DO
BEGIN
    SELECT * INTO OUTFILE '/var/lib/mysql-files/empleats.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM Empleats;

    SELECT * INTO OUTFILE '/var/lib/mysql-files/clients.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM Clients;

    SELECT * INTO OUTFILE '/var/lib/mysql-files/trucades.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM Trucades;

    SELECT * INTO OUTFILE '/var/lib/mysql-files/mesures_bandwidth.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM Mesures_Bandwidth;

    INSERT INTO Backup_Log (taules_incloses, resultat)
    VALUES ('Empleats, Clients, Trucades, Mesures_Bandwidth', 'correcte');

END //

DELIMITER ;
