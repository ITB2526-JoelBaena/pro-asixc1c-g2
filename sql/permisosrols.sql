-- =============================================
-- PERMISOS DELS ROLS
-- =============================================

-- ROL ADMIN (accés total)
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON innovatetech.* TO 'admin';
GRANT GRANT OPTION ON innovatetech.* TO 'admin';

-- ROL VENDES
GRANT SELECT, INSERT, UPDATE ON innovatetech.Clients TO 'vendes';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Comandes TO 'vendes';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Productes TO 'vendes';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Cistell TO 'vendes';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Trucades TO 'vendes';

-- ROL ADMINISTRACIO
GRANT SELECT, INSERT, UPDATE ON innovatetech.Empleats TO 'administracio';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Nomines TO 'administracio';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Departaments TO 'administracio';
GRANT SELECT, INSERT, UPDATE ON innovatetech.Grup_Nivell TO 'administracio';

-- ROL TREBALLADOR
GRANT SELECT ON innovatetech.Productes TO 'treballador';
GRANT SELECT ON innovatetech.Videos TO 'treballador';
GRANT SELECT ON innovatetech.Config_Servidor TO 'treballador';
GRANT SELECT, INSERT ON innovatetech.Trucades TO 'treballador';

-- FLUSH
FLUSH PRIVILEGES;
