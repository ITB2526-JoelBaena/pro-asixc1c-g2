DELIMITER //

CREATE TRIGGER trg_audit_nomines
BEFORE UPDATE ON Nomines
FOR EACH ROW
BEGIN
    IF USER() LIKE '%vendes%' OR USER() LIKE '%treballador%' THEN
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Nomines',
            'UPDATE',
            CONCAT('Intent no autoritzat de modificar taula Nomines per usuari: ', USER())
        );
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: No tens permisos per modificar la taula Nomines.';
    END IF;
END //

DELIMITER ;
