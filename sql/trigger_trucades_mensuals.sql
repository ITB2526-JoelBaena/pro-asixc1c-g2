DELIMITER //

CREATE TRIGGER trg_control_minuts
BEFORE INSERT ON Trucades
FOR EACH ROW
BEGIN
    DECLARE minuts_actuals DECIMAL(10,2);
    DECLARE limit_minuts INT;
    DECLARE usuari_id INT;
    
    SET usuari_id = NEW.id_usuari_origen;
    
    -- Obtenim els minuts consumits i el límit del mes actual
    SELECT minuts_consumits, limit_minuts_mes
    INTO minuts_actuals, limit_minuts
    FROM Quotes_Usuari
    WHERE id_usuari = usuari_id
    AND mes_any = DATE_FORMAT(NOW(), '%Y-%m');
    
    -- Si existeix quota i s'ha superat el límit
    IF minuts_actuals IS NOT NULL AND (minuts_actuals >= limit_minuts) THEN
        -- Registrem l'avís
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Trucades',
            'INSERT',
            CONCAT('Quota de minuts mensuals superada per usuari id: ', usuari_id)
        );
        -- Bloquejem la inserció
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Has superat la quota de minuts mensuals.';
    END IF;
END //

DELIMITER ;
