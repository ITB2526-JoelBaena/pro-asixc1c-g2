DELIMITER //

CREATE TRIGGER trg_control_trucades_dia
BEFORE INSERT ON Trucades
FOR EACH ROW
BEGIN
    DECLARE v_trucades_avui INT;
    DECLARE v_limit_trucades INT;

    SELECT trucades_avui, limit_trucades_dia
    INTO v_trucades_avui, v_limit_trucades
    FROM Quotes_Usuari
    WHERE id_usuari = NEW.id_usuari_origen
    AND mes_any = DATE_FORMAT(NOW(), '%Y-%m');

    IF v_trucades_avui IS NOT NULL AND (v_trucades_avui >= v_limit_trucades) THEN
        INSERT INTO Avisos (usuari_db, taula_afectada, operacio, descripcio)
        VALUES (
            USER(),
            'Trucades',
            'INSERT',
            CONCAT('Quota de trucades diàries superada per usuari id: ', NEW.id_usuari_origen,
                   '. Trucades avui: ', v_trucades_avui,
                   ' de ', v_limit_trucades)
        );
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Has superat el nombre màxim de trucades diàries.';
    END IF;

END //

DELIMITER ;
