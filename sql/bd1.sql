-- =============================================
-- RESET COMPLET - InnovateTech
-- =============================================

-- Seleccionem la BD
USE innovatetech;

-- 1. BORRAR TAULES
SOURCE /home/admintech/borrar_taules.sql;

-- 2. CREAR TAULES
SOURCE /home/admintech/crear_taules.sql;

-- 3. CREAR ROLS
SOURCE /home/admintech/crear_rols.sql;

-- 4. ASSIGNAR PERMISOS
SOURCE /home/admintech/permisosrols.sql;

-- 5. INSERTAR DADES
SOURCE /home/admintech/insertar_dades.sql;

-- 6. TRIGGERS
SOURCE /home/admintech/trigger_bloqueig.sql;
SOURCE /home/admintech/trigger_trucades_mensuals.sql;
SOURCE /home/admintech/trigger_trucadesdiaries.sql;
SOURCE /home/admintech/triggeraudit/vendes_audit.sql;
SOURCE /home/admintech/triggeraudit/audit_trucades.sql;

-- 7. EVENT BACKUP
SOURCE /home/admintech/backup.sql;
