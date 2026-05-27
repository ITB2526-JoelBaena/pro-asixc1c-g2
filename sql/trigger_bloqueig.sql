DELIMITER //

CREATE TRIGGER trg_bloqueig_usuari
BEFORE INSERT ON Trucades
FOR EACH ROW
BEGIN
    DECLARE estat_origen VARCHAR(10);
    DECLARE estat_desti VARCHAR(10);

    -- Comprovem l'estat de l'usuari origen
    SELECT estat INTO estat_origen
    FROM Usuaris
    WHERE id_usuari = NEW.id_usuari_origen;

    -- Comprovem l'estat de l'usuari destí (si és usuari intern)
    IF NEW.id_usuari_desti IS NOT NULL THEN
        SELECT estat INTO estat_desti
        FROM Usuaris
        WHERE id_usuari = NEW.id_usuari_desti;
    END IF;

    -- Bloquejem si l'origen està bloquejat
    IF estat_origen = 'bloquejat' THEN
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Trucades',
            'INSERT',
            CONCAT('Intent de trucada bloquejat. Usuari origen bloquejat: ', NEW.id_usuari_origen)
        );
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: L usuari origen està bloquejat i no pot realitzar trucades.';
    END IF;

    -- Bloquejem si el destí està bloquejat
    IF NEW.id_usuari_desti IS NOT NULL AND estat_desti = 'bloquejat' THEN
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Trucades',
            'INSERT',
            CONCAT('Intent de trucada bloquejat. Usuari destí bloquejat: ', NEW.id_usuari_desti)
        );
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: L usuari destí està bloquejat i no pot rebre trucades.';
    END IF;

END //

DELIMITER ;
