-- =============================================
-- INSERCIONS DE DADES DE PROVA - InnovateTech
-- =============================================

USE innovatetech;

-- 1. DEPARTAMENTS
INSERT INTO Departaments (nom, telefon) VALUES
('Vendes', '934001001'),
('Suport Tècnic', '934001002'),
('Administració', '934001003'),
('Logística', '934001004'),
('Direcció', '934001005');

-- 2. CLIENTS
INSERT INTO Clients (nom_complet, email, telefon) VALUES
('Joan Puigdomènech Mas', 'joan.puigdomenech@gmail.com', '612001001'),
('Maria Solà Ferrer', 'maria.sola@hotmail.com', '612001002'),
('Pere Roca Vidal', 'pere.roca@empresa.cat', '612001003'),
('Anna Tort Campany', 'anna.tort@gmail.com', '612001004'),
('Lluís Bosch Prat', 'lluis.bosch@empresa.cat', '612001005'),
('Núria Mas Soler', 'nuria.mas@hotmail.com', '612001006'),
('Carles Puig Vila', 'carles.puig@gmail.com', '612001007'),
('Marta Riera Compte', 'marta.riera@empresa.cat', '612001008');

-- 3. GRUPS_QUALITAT
INSERT INTO Grups_Qualitat (nom_grup, qualitat_video, qualitat_audio, bandwidth_max) VALUES
('alta', '1080p', '320kbps', 10000),
('mitja', '720p', '128kbps', 5000),
('baixa', '480p', '64kbps', 2000);

-- 4. CONFIG_SERVIDOR
INSERT INTO Config_Servidor (parametre, valor, protocol, port) VALUES
('max_connexions', '100', 'TCP', 8080),
('timeout_trucada', '3600', 'WebRTC', 443),
('qualitat_defecte', 'mitja', 'RTMP', 1935),
('max_participants', '50', 'HLS', 8088);

-- 5. CATEGORIES_VIDEO
INSERT INTO Categories_Video (nom) VALUES
('Formació'),
('Reunions'),
('Presentacions'),
('Tutorials'),
('Comunicats Interns');

-- 6. PRODUCTES
INSERT INTO Productes (nom, descripcio, preu, estoc) VALUES
('Llicència Software A', 'Llicència anual de software de gestió', 299.99, 50),
('Servei Suport Tècnic', 'Pack de 10 hores de suport tècnic', 499.99, 100),
('Servidor Virtual', 'Servidor virtual dedicat mensual', 149.99, 30),
('Formació Online', 'Accés a plataforma de formació 1 any', 199.99, 200),
('Consultoría IT', 'Servei de consultoría tecnològica per dia', 799.99, 20);

-- 7. GRUP_NIVELL
INSERT INTO Grup_Nivell (nom, nivell, descripcio) VALUES
('Junior', 1, 'Treballador amb menys de 2 anys d experiència'),
('Mig', 2, 'Treballador amb 2-5 anys d experiència'),
('Senior', 3, 'Treballador amb més de 5 anys d experiència'),
('Cap de Departament', 4, 'Responsable d un departament'),
('Direcció', 5, 'Membre de l equip directiu');

-- 8. EMPLEATS
INSERT INTO Empleats (dni, nom, cognoms, adreca, telefon, codi_dept) VALUES
('12345678A', 'Marc', 'Batlle Soler', 'Carrer Major 12, Barcelona', '934010001', 1),
('23456789B', 'Laura', 'Comes Puig', 'Avinguda Diagonal 45, Barcelona', '934010002', 1),
('34567890C', 'Jordi', 'Font Mas', 'Carrer Balmes 78, Barcelona', '934010003', 2),
('45678901D', 'Cristina', 'Gil Valls', 'Passeig Gràcia 23, Barcelona', '934010004', 2),
('56789012E', 'Antoni', 'Huguet Roca', 'Carrer Aragó 56, Barcelona', '934010005', 3),
('67890123F', 'Sílvia', 'Isern Tort', 'Avinguda Meridiana 89, Barcelona', '934010006', 3),
('78901234G', 'Pau', 'Jover Bosch', 'Carrer Muntaner 34, Barcelona', '934010007', 4),
('89012345H', 'Elena', 'Llop Puig', 'Gran Via 67, Barcelona', '934010008', 4),
('90123456I', 'Ramon', 'Mas Riera', 'Carrer Provença 12, Barcelona', '934010009', 5),
('01234567J', 'Mònica', 'Nadal Vila', 'Passeig Sant Joan 45, Barcelona', '934010010', 5);

-- 9. USUARIS
INSERT INTO Usuaris (dni, email, extensio, estat, id_grup_qualitat) VALUES
('12345678A', 'marc.batlle@innovatetech.cat', '1001', 'actiu', 1),
('23456789B', 'laura.comes@innovatetech.cat', '1002', 'actiu', 1),
('34567890C', 'jordi.font@innovatetech.cat', '1003', 'actiu', 2),
('45678901D', 'cristina.gil@innovatetech.cat', '1004', 'actiu', 2),
('56789012E', 'antoni.huguet@innovatetech.cat', '1005', 'actiu', 2),
('67890123F', 'silvia.isern@innovatetech.cat', '1006', 'actiu', 3),
('78901234G', 'pau.jover@innovatetech.cat', '1007', 'actiu', 3),
('89012345H', 'elena.llop@innovatetech.cat', '1008', 'bloquejat', 3),
('90123456I', 'ramon.mas@innovatetech.cat', '1009', 'actiu', 1),
('01234567J', 'monica.nadal@innovatetech.cat', '1010', 'actiu', 2);

-- 10. NOMINES
INSERT INTO Nomines (dni, mes_any, salari_base, complements, deduccions, total_net) VALUES
('12345678A', '2025-03', 1800.00, 200.00, 350.00, 1650.00),
('23456789B', '2025-03', 1800.00, 150.00, 330.00, 1620.00),
('34567890C', '2025-03', 2000.00, 300.00, 400.00, 1900.00),
('45678901D', '2025-03', 2000.00, 250.00, 380.00, 1870.00),
('56789012E', '2025-03', 2200.00, 400.00, 450.00, 2150.00),
('67890123F', '2025-03', 2200.00, 350.00, 430.00, 2120.00),
('78901234G', '2025-03', 1900.00, 200.00, 360.00, 1740.00),
('89012345H', '2025-03', 1900.00, 200.00, 360.00, 1740.00),
('90123456I', '2025-03', 3500.00, 800.00, 700.00, 3600.00),
('01234567J', '2025-03', 3500.00, 750.00, 680.00, 3570.00);

-- 11. VIDEOS
INSERT INTO Videos (titol, descripcio, id_categoria, duracio, data_publicacio, url_streaming) VALUES
('Introducció a InnovateTech', 'Vídeo de benvinguda per a nous empleats', 1, 600, '2025-01-10', 'rtmp://streaming.innovatetech.cat/videos/intro'),
('Formació en Vendes Q1', 'Tècniques de venda per al primer trimestre', 1, 3600, '2025-01-15', 'rtmp://streaming.innovatetech.cat/videos/vendes_q1'),
('Reunió Direcció Febrer', 'Reunió mensual de direcció', 2, 2700, '2025-02-05', 'rtmp://streaming.innovatetech.cat/videos/reuni_feb'),
('Presentació Producte X', 'Presentació del nou producte X als clients', 3, 1800, '2025-02-20', 'rtmp://streaming.innovatetech.cat/videos/prod_x'),
('Tutorial Eines Internes', 'Com usar les eines de gestió interna', 4, 1200, '2025-03-01', 'rtmp://streaming.innovatetech.cat/videos/tutorial_eines'),
('Comunicat Canvis Horari', 'Comunicat oficial sobre canvis d horari', 5, 300, '2025-03-10', 'rtmp://streaming.innovatetech.cat/videos/horari'),
('Formació Suport Tècnic', 'Procediments per al departament de suport', 1, 4500, '2025-03-15', 'rtmp://streaming.innovatetech.cat/videos/suport'),
('Reunió Vendes Març', 'Revisió objectius de vendes de març', 2, 3000, '2025-03-20', 'rtmp://streaming.innovatetech.cat/videos/vendes_marc');

-- 12. COMANDES
INSERT INTO Comandes (id_client, data_comanda, estat, total) VALUES
(1, '2025-03-01 10:00:00', 'completada', 299.99),
(2, '2025-03-02 11:00:00', 'completada', 499.99),
(3, '2025-03-03 12:00:00', 'enviada', 149.99),
(4, '2025-03-04 09:00:00', 'processada', 199.99),
(5, '2025-03-05 10:30:00', 'pendent', 799.99);

-- 13. CISTELL
INSERT INTO Cistell (id_comanda, id_producte, quantitat, preu_unitari) VALUES
(1, 1, 1, 299.99),
(2, 2, 1, 499.99),
(3, 3, 1, 149.99),
(4, 4, 1, 199.99),
(5, 5, 1, 799.99);

-- 14. TRUCADES
INSERT INTO Trucades (id_usuari_origen, id_client_desti, id_usuari_desti, data_inici, data_fi, duracio_minuts, id_grup_qualitat, valoracio, comentari) VALUES
(1, 1, NULL, '2025-03-01 09:00:00', '2025-03-01 09:25:00', 25.00, 1, 5, 'Excel·lent atenció'),
(2, 2, NULL, '2025-03-01 10:00:00', '2025-03-01 10:15:00', 15.00, 1, 4, 'Bona trucada'),
(3, NULL, 4, '2025-03-02 11:00:00', '2025-03-02 11:30:00', 30.00, 2, NULL, NULL),
(4, 3, NULL, '2025-03-02 12:00:00', '2025-03-02 12:10:00', 10.00, 2, 3, 'Acceptable'),
(5, NULL, 6, '2025-03-03 09:30:00', '2025-03-03 09:45:00', 15.00, 2, NULL, NULL),
(1, 4, NULL, '2025-03-03 10:00:00', '2025-03-03 10:45:00', 45.00, 1, 5, 'Molt satisfactori'),
(7, NULL, 8, '2025-03-04 11:00:00', '2025-03-04 11:20:00', 20.00, 3, NULL, NULL),
(9, 5, NULL, '2025-03-04 12:00:00', '2025-03-04 12:30:00', 30.00, 1, 4, 'Bona gestió');

-- 15. MESURES_BANDWIDTH
INSERT INTO Mesures_Bandwidth (data_hora, id_usuari_operari, equip_mesurat, velocitat_baixada, velocitat_pujada, latencia, resultat, notes) VALUES
('2025-03-01 08:00:00', 9, 'Servidor-Web-01', 950.50, 480.25, 12.30, 'acceptable', 'Mesura matinal correcta'),
('2025-03-01 14:00:00', 9, 'Servidor-Web-01', 880.75, 450.00, 15.50, 'acceptable', 'Mesura migdia correcta'),
('2025-03-02 08:00:00', 10, 'Servidor-BD-01', 920.00, 460.50, 11.80, 'acceptable', NULL),
('2025-03-02 14:00:00', 10, 'Servidor-BD-01', 750.25, 380.75, 22.40, 'acceptable', 'Lleugera baixada de rendiment'),
('2025-03-03 08:00:00', 9, 'Servidor-Streaming-01', 1200.00, 600.00, 8.50, 'acceptable', 'Rendiment òptim'),
('2025-03-03 14:00:00', 9, 'Servidor-Streaming-01', 450.00, 200.00, 45.00, 'no acceptable', 'Degradació detectada a la tarda'),
('2025-03-04 08:00:00', 10, 'Switch-Core-01', 980.00, 490.00, 10.20, 'acceptable', NULL);

-- 16. QUOTES_USUARI
INSERT INTO Quotes_Usuari (id_usuari, mes_any, minuts_consumits, trucades_avui, limit_minuts_mes, limit_trucades_dia) VALUES
(1, '2025-03', 70.00, 2, 500, 10),
(2, '2025-03', 15.00, 1, 500, 10),
(3, '2025-03', 30.00, 1, 300, 8),
(4, '2025-03', 10.00, 1, 300, 8),
(5, '2025-03', 15.00, 1, 300, 8),
(6, '2025-03', 0.00, 0, 200, 5),
(7, '2025-03', 20.00, 1, 200, 5),
(9, '2025-03', 30.00, 1, 500, 10),
(10, '2025-03', 0.00, 0, 300, 8);

-- 17. AVISOS
INSERT INTO Avisos (usuari_db, taula_afectada, operacio, data_hora, descripcio) VALUES
('user_vendes', 'Empleats', 'UPDATE', '2025-03-01 10:30:00', 'Intent de modificar taula Empleats per usuari amb rol vendes'),
('user_treballador', 'Nomines', 'SELECT', '2025-03-02 11:00:00', 'Intent d accés a taula Nomines per usuari amb rol treballador'),
('user_administracio', 'Trucades', 'SELECT', '2025-03-03 09:15:00', 'Intent d accés al sistema de trucades de clients');

-- 18. BACKUP_LOG
INSERT INTO Backup_Log (data_hora, taules_incloses, resultat) VALUES
('2025-03-01 02:00:00', 'Empleats, Clients, Trucades, Mesures_Bandwidth', 'correcte'),
('2025-03-08 02:00:00', 'Empleats, Clients, Trucades, Mesures_Bandwidth', 'correcte'),
('2025-03-15 02:00:00', 'Empleats, Clients, Trucades, Mesures_Bandwidth', 'error');
