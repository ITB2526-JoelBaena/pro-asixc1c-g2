DELIMITER //

CREATE TRIGGER trg_audit_trucades
BEFORE INSERT ON Trucades
FOR EACH ROW
BEGIN
    IF USER() LIKE '%administracio%' THEN
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Trucades',
            'INSERT',
            CONCAT('Intent no autoritzat d accés a taula Trucades per usuari: ', USER())
        );
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: No tens permisos per accedir a les trucades de clients.';
    END IF;
END //

DELIMITER ;
