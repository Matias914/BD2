
/* ---------------------------------- DEFINICION DE TABLAS ---------------------------------- */

-- Table: Barrio
DROP TABLE IF EXISTS Barrio CASCADE;
CREATE TABLE Barrio (
    id_barrio int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    id_ciudad int  NOT NULL,
    CONSTRAINT Barrio_pk PRIMARY KEY (id_barrio)
);

-- Table: Categoria
DROP TABLE IF EXISTS Categoria CASCADE;
CREATE TABLE Categoria (
    id_cat int  NOT NULL,
    nombre varchar(50)  NOT NULL,
    CONSTRAINT Categoria_pk PRIMARY KEY (id_cat)
);

-- Table: Ciudad
DROP TABLE IF EXISTS Ciudad CASCADE;
CREATE TABLE Ciudad (
    id_ciudad int  NOT NULL,
    nombre varchar(80)  NOT NULL,
    CONSTRAINT Ciudad_pk PRIMARY KEY (id_ciudad)
);

-- Table: Cliente
DROP TABLE IF EXISTS Cliente CASCADE;
CREATE TABLE Cliente (
    id_cliente int  NOT NULL,
    saldo numeric(18,3)  NULL,
    CONSTRAINT Cliente_pk PRIMARY KEY (id_cliente)
);

-- Table: Comprobante
DROP TABLE IF EXISTS Comprobante CASCADE;
CREATE TABLE Comprobante (
    id_comp bigint  NOT NULL,
    id_tcomp int  NOT NULL,
    fecha timestamp  NULL,
    comentario varchar(2048)  NOT NULL,
    estado varchar(20)  NULL,
    fecha_vencimiento timestamp  NULL,
    id_turno int  NULL,
    importe numeric(18,5)  NOT NULL,
    id_cliente int  NOT NULL,
    id_lugar int,
    CONSTRAINT pk_comprobante PRIMARY KEY (id_comp,id_tcomp)
);

-- Table: Direccion
DROP TABLE IF EXISTS Direccion CASCADE;
CREATE TABLE Direccion (
    id_direccion int  NOT NULL,
    id_persona int  NOT NULL,
    calle varchar(50)  NOT NULL,
    numero int  NOT NULL,
    piso int  NULL,
    depto varchar(50)  NULL,
    id_barrio int  NOT NULL,
    CONSTRAINT Direccion_pk PRIMARY KEY (id_direccion,id_persona)
);

-- Table: Equipo
DROP TABLE IF EXISTS Equipo CASCADE;
CREATE TABLE Equipo (
    id_equipo int  NOT NULL,
    nombre varchar(80)  NOT NULL,
    MAC varchar(20)  NOT NULL default '00:00:00:00:00:00',
    IP varchar(20)  NULL,
    AP varchar(20)  NULL,
    id_servicio int  NULL,
    id_cliente int  NULL,
    fecha_alta timestamp  NOT NULL,
    fecha_baja timestamp  NULL,
    tipo_conexion varchar(20)  NULL,
    tipo_asignacion varchar(20)  NULL,
    CONSTRAINT Equipo_pk PRIMARY KEY (id_equipo)
);

-- Table: LineaComprobante
DROP TABLE IF EXISTS LineaComprobante CASCADE;
CREATE TABLE LineaComprobante (
    nro_linea int  NOT NULL,
    id_comp bigint  NOT NULL,
    id_tcomp int  NOT NULL,
    descripcion varchar(80)  NOT NULL,
    cantidad int  NOT NULL,
    importe numeric(18,5)  NOT NULL,
    id_servicio int  NULL,
    CONSTRAINT pk_lineacomp PRIMARY KEY (nro_linea,id_comp,id_tcomp)
);

-- Table: Persona
DROP TABLE IF EXISTS Persona CASCADE;
CREATE TABLE Persona (
    id_persona int  NOT NULL,
    tipo varchar(10)  NOT NULL,
    tipodoc varchar(10)  NOT NULL,
    nrodoc varchar(10)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    fecha_nacimiento timestamp  NOT NULL,
    fecha_alta timestamp  NOT NULL default now(),
    fecha_baja timestamp  NULL,
    CUIT varchar(20)  NULL,
    activo boolean  NOT NULL,
    mail varchar(100)  NULL,
    telef_area int  NULL,
    telef_numero int  NULL,
    CONSTRAINT pk_persona PRIMARY KEY (id_persona)
);

-- Table: Personal
DROP TABLE IF EXISTS Personal CASCADE;
CREATE TABLE Personal (
    id_personal int  NOT NULL,
    id_rol int  NOT NULL,
    CONSTRAINT Personal_pk PRIMARY KEY (id_personal)
);

-- Table: Rol
DROP TABLE IF EXISTS Rol CASCADE;
CREATE TABLE Rol (
    id_rol int  NOT NULL,
    nombre varchar(50)  NOT NULL,
    CONSTRAINT Rol_pk PRIMARY KEY (id_rol)
);

-- Table: Servicio
DROP TABLE IF EXISTS Servicio CASCADE;
CREATE TABLE Servicio (
    id_servicio int  NOT NULL,
    nombre varchar(80)  NOT NULL,
    periodico boolean  NOT NULL,
    costo numeric(18,3)  NOT NULL,
    intervalo int  NULL,
    tipo_intervalo varchar(20)  NULL,
    activo boolean  NOT NULL DEFAULT true,
    id_cat int  NOT NULL,
    CONSTRAINT CHECK_0 CHECK (( tipo_intervalo in ( 'semana' , 'quincena' , 'mes' , 'bimestre' ) )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT pk_servicio PRIMARY KEY (id_servicio)
);

-- Table: TipoComprobante
DROP TABLE IF EXISTS TipoComprobante CASCADE;
CREATE TABLE TipoComprobante (
    id_tcomp int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    tipo varchar(80)  NOT NULL,
    CONSTRAINT pk_tipo_comprobante PRIMARY KEY (id_tcomp)
);

-- Table: Turno
DROP TABLE IF EXISTS Turno CASCADE;
CREATE TABLE Turno (
    id_turno int  NOT NULL,
    desde timestamp  NOT NULL,
    hasta timestamp  NULL,
    dinero_inicio numeric(18,3)  NOT NULL,
    dinero_fin numeric(18,3)  NULL,
    id_personal int  NOT NULL,
    id_lugar int,
    CONSTRAINT Turno_pk PRIMARY KEY (id_turno)
);

-- Table: Lugar
DROP TABLE IF EXISTS Lugar CASCADE;
CREATE TABLE Lugar (
    id_lugar int  NOT NULL,
    nombre varchar(50)  NOT NULL,
    CONSTRAINT Lugar_pk PRIMARY KEY (id_lugar)
);

-- Table: Informe
-- Tabla de informacion de registro de empleados usada para la consigna 2) B)
DROP TABLE IF EXISTS Informe CASCADE;
CREATE TABLE Informe (
    id_personal INT NOT NULL,
    nombre VARCHAR(40),
    apellido VARCHAR(40),
    tipodoc VARCHAR(10),
    nrodoc VARCHAR(10),
    promedio_tiempo INTERVAL NOT NULL,
    maximo_tiempo INTERVAL NOT NULL,
    cantidad_atendidos INT NOT NULL,
    CONSTRAINT Informe_pk PRIMARY KEY (id_personal)
);

/* ----------------------------------- CLAVES EXTRANJERAS ----------------------------------- */

-- Implementacion declarativa de la RI de tupla de la consigna 1) A)
-- DROP CONSTRAINT
ALTER TABLE Persona DROP
    CONSTRAINT check_fecha_baja;
-- ADD CONSTRAINT
ALTER TABLE Persona ADD
    CONSTRAINT check_fecha_baja CHECK (
        activo OR (
            fecha_baja IS NOT NULL AND
            fecha_baja >= fecha_alta + INTERVAL '6 months'
        )
    );

-- foreign keys
-- Reference: fk_lineacomprobante_servicio (table: LineaComprobante)
ALTER TABLE LineaComprobante ADD CONSTRAINT LineaComprobante_Servicio
    FOREIGN KEY (id_servicio)
    REFERENCES Servicio (id_servicio)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_lineacomprobante_comprobante (table: LineaComprobante)
ALTER TABLE LineaComprobante ADD CONSTRAINT fk_lineacomprobante_comprobante
    FOREIGN KEY (id_comp, id_tcomp)
    REFERENCES Comprobante (id_comp, id_tcomp)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_barrio_ciudad (table: Barrio)
ALTER TABLE Barrio ADD CONSTRAINT fk_barrio_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES Ciudad (id_ciudad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_cliente_persona (table: Cliente)
ALTER TABLE Cliente ADD CONSTRAINT fk_cliente_persona
    FOREIGN KEY (id_cliente)
    REFERENCES Persona (id_persona)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_comprobante_cliente (table: Comprobante)
ALTER TABLE Comprobante ADD CONSTRAINT fk_comprobante_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_comprobante_tipocomprobante (table: Comprobante)
ALTER TABLE Comprobante ADD CONSTRAINT fk_comprobante_tipocomprobante
    FOREIGN KEY (id_tcomp)
    REFERENCES TipoComprobante (id_tcomp)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_comprobante_turno(table: Comprobante)
ALTER TABLE Comprobante ADD CONSTRAINT fk_comprobante_turno
    FOREIGN KEY (id_turno)
    REFERENCES Turno (id_turno)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_direccion_persona (table: Direccion)
ALTER TABLE Direccion ADD CONSTRAINT fk_direccion
    FOREIGN KEY (id_persona)
    REFERENCES Persona (id_persona)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_direccion_barrio (table: Direccion)
ALTER TABLE Direccion ADD CONSTRAINT fk_direccion_barrio
    FOREIGN KEY (id_barrio)
    REFERENCES Barrio (id_barrio)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_equipo_cliente (table: Equipo)
ALTER TABLE Equipo ADD CONSTRAINT fk_equipo_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_equipo_servicio (table: Equipo)
ALTER TABLE Equipo ADD CONSTRAINT fk_equipo_servicio
    FOREIGN KEY (id_servicio)
    REFERENCES Servicio (id_servicio)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_personal_persona (table: Personal)
ALTER TABLE Personal ADD CONSTRAINT fk_personal_persona
    FOREIGN KEY (id_personal)
    REFERENCES Persona (id_persona)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_personal_rol (table: Personal)
ALTER TABLE Personal ADD CONSTRAINT fk_personal_rol
    FOREIGN KEY (id_rol)
    REFERENCES Rol (id_rol)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_personal_turno (table: Turno)
ALTER TABLE Turno ADD CONSTRAINT fk_personal_turno
    FOREIGN KEY (id_personal)
    REFERENCES Personal (id_personal)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: fk_servicio_categoria (table: Servicio)
ALTER TABLE Servicio ADD CONSTRAINT fk_servicio_categoria
    FOREIGN KEY (id_cat)
    REFERENCES Categoria (id_cat)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

/* -------------------------------- DEFINICION DE SECUENCIAS  ------------------------------- */

-- Esta secuencia puede ser util para la generacion de comprobante
/*
DROP SEQUENCE IF EXISTS comprobante_id_comp_seq;
CREATE SEQUENCE IF NOT EXISTS comprobante_id_comp_seq AS BIGINT
START WITH 1
INCREMENT BY 1;
*/

/* ---------------------------------- DEFINICION DE VISTAS ---------------------------------- */

DROP VIEW IF EXISTS Vista1;
CREATE OR REPLACE VIEW Vista1 AS
    SELECT
        c.id_cliente,
        p.nombre,
        p.apellido,
        p.tipodoc,
        p.nrodoc,
        c.saldo
    FROM Cliente c
    JOIN Persona p
    ON (c.id_cliente = p.id_persona)
    WHERE AGE(fecha_nacimiento) < '30 years'
      AND EXISTS (
        SELECT 1
        FROM Equipo
        WHERE id_servicio IS NOT NULL
          AND id_cliente = c.id_cliente
        GROUP BY id_cliente
        HAVING COUNT(DISTINCT id_servicio) > 3
    ) AND EXISTS (
        SELECT 1
        FROM Direccion
        WHERE id_cliente = c.id_cliente
          AND id_barrio IN (
            SELECT id_barrio
            FROM Barrio
            WHERE id_ciudad = (
                SELECT id_ciudad
                FROM Ciudad
                WHERE nombre ilike 'napoli'
            )
        )
    );

DROP VIEW IF EXISTS Vista2;
CREATE OR REPLACE VIEW Vista2 AS
    SELECT DISTINCT
        c.id_cliente,
        p.tipo,
        p.tipodoc,
        p.nrodoc,
        p.nombre,
        p.apellido,
        p.fecha_nacimiento,
        p.fecha_alta,
        p.fecha_baja,
        p.CUIT,
        p.activo,
        p.mail,
        p.telef_area,
        p.telef_numero,
        c.saldo,
        s.id_servicio,
        s.nombre AS nombre_servicio,
        s.costo
    FROM Equipo
    JOIN Cliente c USING (id_cliente)
    JOIN Persona p
    ON (c.id_cliente = p.id_persona)
    JOIN Servicio s USING (id_servicio)
    WHERE p.activo
      AND s.activo
      AND EXTRACT(YEAR FROM p.fecha_alta) =
          EXTRACT(YEAR FROM CURRENT_TIMESTAMP);

DROP VIEW IF EXISTS Vista3;
CREATE OR REPLACE VIEW Vista3 AS
    WITH fechas AS (
        SELECT
        GENERATE_SERIES(
            DATE_TRUNC('month', CURRENT_TIMESTAMP - INTERVAL '20 years'),
            DATE_TRUNC('month', CURRENT_TIMESTAMP),
            '1 month'
        ) AS fecha_por_mes
    )
    SELECT
        s.id_servicio,
        nombre,
        periodico,
        costo,
        intervalo,
        tipo_intervalo,
        activo,
        id_cat,
        EXTRACT(YEAR FROM fecha_por_mes) AS anio,
        EXTRACT(MONTH FROM fecha_por_mes) AS mes,
        COALESCE(SUM(importe * cantidad), 0) AS monto_facturado
    FROM Servicio s CROSS JOIN fechas
    LEFT JOIN (
        SELECT id_servicio, lc.importe, cantidad, DATE_TRUNC('month', c.fecha) AS fecha
        FROM LineaComprobante lc
        JOIN Comprobante c USING (id_comp, id_tcomp)
        WHERE id_tcomp = 1
          AND AGE(c.fecha) <= '20 years'
    ) AS datos_linea
    ON (s.id_servicio = datos_linea.id_servicio AND fechas.fecha_por_mes = datos_linea.fecha)
    WHERE periodico
    GROUP BY
        s.id_servicio,
        nombre,
        periodico,
        costo,
        intervalo,
        tipo_intervalo,
        activo,
        id_cat,
        EXTRACT(YEAR FROM fecha_por_mes),
        EXTRACT(MONTH FROM fecha_por_mes)
    ORDER BY id_servicio, anio, mes, monto_facturado;

DROP VIEW IF EXISTS Vista1_alternativa;
CREATE OR REPLACE VIEW Vista1_alternativa AS
    SELECT datos_persona.*, c.saldo
    FROM Cliente c
    JOIN (
        SELECT
            id_persona AS id_cliente,
            nombre,
            apellido,
            tipodoc,
            nrodoc
        FROM Persona
        WHERE AGE(fecha_nacimiento) < '30 years'
    ) AS datos_persona USING (id_cliente)
    WHERE 3 < (
        SELECT COUNT(DISTINCT id_servicio)
        FROM Equipo
        WHERE id_servicio IS NOT NULL
          AND id_cliente = c.id_cliente
    ) AND EXISTS (
        SELECT 1
        FROM Direccion
        WHERE id_cliente = c.id_cliente
          AND id_barrio IN (
            SELECT id_barrio
            FROM Barrio
            WHERE id_ciudad = (
                SELECT id_ciudad
                FROM Ciudad
                WHERE nombre ilike 'napoli'
            )
        )
    );

DROP VIEW IF EXISTS Vista3_alternativa;
CREATE OR REPLACE VIEW Vista3_alternativa AS
    SELECT *
    FROM (
        SELECT
            id_servicio, nombre, periodico, costo, intervalo, tipo_intervalo, activo, id_cat, anio, mes,
            SUM(importe * cantidad) AS monto_facturado
        FROM Servicio
        JOIN (
            SELECT
                id_servicio,
                anio,
                mes,
                importe,
                cantidad
            FROM LineaComprobante
            JOIN (
                SELECT
                    id_comp,
                    id_tcomp,
                    EXTRACT(MONTH FROM fecha) AS mes,
                    EXTRACT(YEAR FROM fecha)  AS anio
                FROM Comprobante
                WHERE AGE(fecha) <= '20 years'
                  AND id_tcomp = 1
            ) AS c USING (id_comp, id_tcomp)
        ) AS lc  USING (id_servicio)
        WHERE periodico
        GROUP BY id_servicio, nombre, periodico, costo, intervalo, tipo_intervalo, activo, id_cat, anio, mes
    ) AS Datos
    ORDER BY id_servicio, anio, mes, monto_facturado;

-- Vistas para comparación de optimización

DROP VIEW IF EXISTS Vista1_anterior;
CREATE OR REPLACE VIEW Vista1_anterior AS
    SELECT c.id_cliente, p.nrodoc, p.nombre, p.apellido, p.CUIT, p.mail, p.telef_numero, c.saldo
    FROM Cliente c JOIN Persona p ON (c.id_cliente = p.id_persona)
    WHERE current_timestamp < p.fecha_nacimiento + INTERVAL '30 years'
      AND EXISTS (
            SELECT 1
            FROM direccion
            JOIN barrio USING (id_barrio)
            JOIN ciudad USING (id_ciudad)
            WHERE id_persona = c.id_cliente
              AND ciudad.nombre ILIKE 'napoli'
    ) AND EXISTS (
            SELECT 1
            FROM Equipo e
            WHERE e.id_cliente = c.id_cliente
            GROUP BY e.id_cliente
            HAVING COUNT(DISTINCT e.id_servicio) > 3
    );

DROP VIEW IF EXISTS Vista2_anterior;
CREATE OR REPLACE VIEW Vista2_anterior AS
    SELECT DISTINCT p.*, c.saldo, s.id_servicio, s.nombre as nombre_servicio, s.costo
    FROM Cliente c
    JOIN Equipo e ON (c.id_cliente = e.id_cliente)
    JOIN Persona p ON (c.id_cliente = p.id_persona)
    JOIN Servicio s ON (e.id_servicio = s.id_servicio)
    WHERE p.activo
      AND extract(year from current_timestamp) = extract(year from p.fecha_alta)
      AND e.id_servicio IS NOT NULL
      AND s.activo;

DROP VIEW IF EXISTS Vista3_anterior;
CREATE OR REPLACE VIEW Vista3_anterior AS
    SELECT id_servicio, nombre, periodico, costo, intervalo, tipo_intervalo, activo, id_cat, anio, mes, importe
    FROM (
        SELECT DISTINCT s.*,
            EXTRACT(YEAR FROM c.fecha)  as anio,
            EXTRACT(MONTH FROM c.fecha) as mes,
            SUM(lc.importe) OVER (PARTITION BY s.id_servicio, EXTRACT(YEAR FROM c.fecha), EXTRACT(MONTH FROM c.fecha)) AS importe
        FROM Servicio s
        JOIN LineaComprobante lc ON (s.id_servicio = lc.id_servicio)
        JOIN Comprobante c ON (c.id_comp = lc.id_comp AND c.id_tcomp = lc.id_tcomp)
        WHERE s.periodico
          AND CURRENT_TIMESTAMP <= c.fecha + INTERVAL '20 years'
          AND c.id_tcomp = 1
    ) AS Datos
    ORDER BY id_servicio, anio, mes, importe;

/* ------------------------------- DEFINICION DE PROCEDIMIENTOS ----------------------------- */

-- La sentencia de la secuencia era:
-- PERFORM SETVAL('comprobante_id_comp_seq', secuencia_comprobante);
-- Procedimiento Optimizado
DROP PROCEDURE IF EXISTS pr_generar_facturas;
CREATE OR REPLACE PROCEDURE pr_generar_facturas(
    comentario varchar(2048),
    descripcion varchar(80)
)
LANGUAGE 'plpgsql' AS $$
DECLARE
    max_comp BIGINT = (
        SELECT COALESCE(MAX(id_comp), 0)
        FROM Comprobante
        WHERE id_tcomp = 1
);
BEGIN
    -- creo tabla temporal donde voy a guardar mis datos
    CREATE TEMP TABLE temporal_data (
        id_comprobante BIGINT,
        id_cliente INT,
        id_servicio INT,
        costo NUMERIC(18,3),
        cantidad INT
    ) ON COMMIT DROP;

    -- cargo la tabla temporal con todos los datos de un
    -- momento dado
    INSERT INTO temporal_data (
        id_comprobante,
        id_cliente,
        id_servicio,
        costo,
        cantidad
    )
    SELECT
        DENSE_RANK() OVER (ORDER BY id_cliente) + max_comp,
        e.id_cliente,
        e.id_servicio,
        s.costo,
        COUNT(*) AS cantidad
    FROM Equipo e JOIN Servicio s USING (id_servicio)
    WHERE s.activo
      AND s.periodico
      AND id_cliente IS NOT NULL
      AND id_cliente IN (
          SELECT p.id_persona
          FROM Persona p
          WHERE p.activo
    )
    GROUP BY e.id_cliente, e.id_servicio, s.costo;

    -- con los datos de la tabla hago un insert masivo
    -- en comprobante
    INSERT INTO Comprobante (
        id_comp,
        id_tcomp,
        fecha,
        comentario,
        estado,
        fecha_vencimiento,
        id_turno,
        importe,
        id_cliente,
        id_lugar
    )
    SELECT
        id_comprobante,
        1,
        CURRENT_TIMESTAMP,
        comentario,
        NULL,
        CURRENT_TIMESTAMP + INTERVAL '1 month',
        NULL,
        SUM(costo * cantidad),
        id_cliente,
        NULL
    FROM temporal_data
    GROUP BY id_cliente, id_comprobante;

    -- con los datos de la tabla hago un insert masivo
    -- en linea comprobante
    INSERT INTO LineaComprobante (
        nro_linea,
        id_comp,
        id_tcomp,
        descripcion,
        cantidad,
        importe,
        id_servicio
    )
    SELECT
        ROW_NUMBER() OVER (PARTITION BY id_cliente),
        id_comprobante,
        1,
        descripcion,
        cantidad,
        costo,
        id_servicio
    FROM temporal_data;
END $$;

-- version original
DROP PROCEDURE IF EXISTS pr_generar_facturas_antes;
CREATE OR REPLACE PROCEDURE pr_generar_facturas(comentario varchar(2048), descripcion varchar(80))
LANGUAGE 'plpgsql' AS $$
DECLARE
    secuencia_comprobante BIGINT = (SELECT max(id_comp) FROM comprobante c WHERE id_tcomp = 1);
BEGIN

    -- creo tabla temporal donde voy a guardar mis datos
    CREATE TEMP TABLE temporal_data (
        id_comprobante BIGINT,
        id_cliente INT,
        id_servicio INT,
        costo NUMERIC(18,3),
        cantidad INT
    ) ON COMMIT DROP;

    -- cargo la tabla temporal con todos los datos de un momento dado
    INSERT INTO temporal_data(id_comprobante, id_cliente, id_servicio, costo, cantidad)
    SELECT
        DENSE_RANK() OVER (ORDER BY id_cliente) + secuencia_comprobante,
        e.id_cliente,
        e.id_servicio,
        s.costo,
        COUNT(*) as cantidad
    FROM Equipo e JOIN Servicio s USING (id_servicio)
    WHERE s.activo AND s.periodico AND id_cliente IS NOT NULL AND
          id_cliente IN (
              SELECT p.id_persona
              FROM Persona p
              WHERE p.activo
    )
    GROUP BY e.id_cliente, e.id_servicio, s.costo;

    -- con los datos de la tabla hago un insert masivo en comprobante
    INSERT INTO Comprobante(id_comp, id_tcomp, fecha, comentario, estado, fecha_vencimiento, id_turno, importe, id_cliente, id_lugar)
    SELECT
        id_comprobante,
        1,
        CURRENT_TIMESTAMP,
        comentario,
        NULL,
        CURRENT_TIMESTAMP + '1 month',
        NULL,
        SUM(costo * cantidad),
        id_cliente,
        1
    FROM temporal_data
    GROUP BY id_cliente, id_comprobante;

    -- con los datos de la tabla hago un insert masivo en linea comprobante
    INSERT INTO LineaComprobante(nro_linea, id_comp, id_tcomp, descripcion, cantidad, importe, id_servicio)
    SELECT
        ROW_NUMBER() OVER (PARTITION BY id_cliente),
        id_comprobante,
        1,
        descripcion,
        cantidad,
        costo * cantidad,
        id_servicio
    FROM temporal_data;
END $$;

-- Procedimiento optimizado
DROP PROCEDURE IF EXISTS pr_generar_informe;
CREATE OR REPLACE PROCEDURE pr_generar_informe(
    fecha_inicio timestamp,
    fecha_fin timestamp
)
LANGUAGE 'plpgsql' AS $$
BEGIN
    DELETE FROM Informe;
    INSERT INTO Informe
        SELECT
            id_personal,
            nombre,
            apellido,
            tipodoc,
            nrodoc,
            COALESCE(AVG(tiempo), INTERVAL '0')
            AS promedio_horas,
            COALESCE(MAX(tiempo), INTERVAL '0')
            AS max_horas,
            COUNT(DISTINCT id_cliente) AS cant_clientes
        FROM Personal
        JOIN (
            SELECT
                id_persona AS id_personal,
                nombre,
                apellido,
                tipodoc,
                nrodoc
            FROM Persona
        ) AS datos_personal USING (id_personal)
        LEFT JOIN (
            SELECT
                id_turno,
                COALESCE(hasta, CURRENT_TIMESTAMP) - desde
                AS tiempo,
                id_personal
            FROM Turno
        ) AS datos_turno USING (id_personal)
        LEFT JOIN (
            SELECT id_cliente, id_turno
            FROM Comprobante
            WHERE fecha BETWEEN fecha_inicio AND fecha_fin
        ) AS datos_comprobante USING (id_turno)
        GROUP BY
            id_personal,
            nombre,
            apellido,
            nrodoc,
            tipodoc;
 END $$;

-- Procedimiento optimizado
DROP PROCEDURE IF EXISTS pr_generar_informe_alt;
CREATE OR REPLACE PROCEDURE pr_generar_informe_alt(
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP
)
LANGUAGE 'plpgsql' AS $$
BEGIN
    DELETE FROM Informe;
    INSERT INTO Informe
        SELECT
            id_personal,
            nombre,
            apellido,
            tipodoc,
            nrodoc,
            COALESCE(AVG(
                COALESCE(hasta, CURRENT_TIMESTAMP) - desde
            ), INTERVAL '0')
            AS promedio_horas,
            COALESCE(MAX(
                COALESCE(hasta, CURRENT_TIMESTAMP) - desde
            ), INTERVAL '0')
            AS max_horas,
            COUNT(DISTINCT id_cliente) AS cant_clientes
        FROM Personal pl
        JOIN Persona pa
        ON (pl.id_personal = pa.id_persona)
        LEFT JOIN Turno USING (id_personal)
        LEFT JOIN Comprobante USING (id_turno)
        WHERE id_comp IS NULL
           OR fecha BETWEEN fecha_inicio AND fecha_fin
        GROUP BY
            id_personal,
            nombre,
            apellido,
            nrodoc,
            tipodoc;
 END $$;

/* --------------------------------- DEFINICION DE FUNCIONES -------------------------------- */

-- Funcion de comprobación de actualización de Comprobante
DROP FUNCTION IF EXISTS fn_up_comprobante CASCADE;
CREATE OR REPLACE FUNCTION fn_up_comprobante()
RETURNS TRIGGER AS $$
BEGIN
    -- cambia el importe del comprobante, se compara el
    -- importe del mismo con el de las lineas correspon-
    -- dientes
    IF (
        SELECT SUM(importe * cantidad)
        FROM LineaComprobante
        WHERE NEW.id_comp = id_comp
          AND 1 = id_tcomp
    ) != NEW.importe THEN
        RAISE EXCEPTION 'El importe del comprobante no coincide con el de sus lineas';
    END IF;
    RETURN NULL;
END $$ LANGUAGE 'plpgsql';

-- Funcion de comprobación de inserción o eliminación de Comprobante
DROP FUNCTION IF EXISTS fn_indel_linea_comprobante CASCADE;
CREATE OR REPLACE FUNCTION fn_indel_linea_comprobante()
RETURNS TRIGGER AS $$
DECLARE
    id_comprobante BIGINT;
BEGIN
    -- Si es un INSERT se toma el ID nuevo, sino el viejo
    IF (TG_OP = 'INSERT') THEN
        id_comprobante = NEW.id_comp;
    ELSE
        id_comprobante = OLD.id_comp;
    END IF;
    -- Si era un INSERT se comprueba que la suma de los im-
    -- portes de las líneas con el nuevo ID coincida con
    -- el del comprobante correspondiente.
    -- Si era un DELETE, con el viejo ID
    IF (
        SELECT importe
        FROM Comprobante
        WHERE id_comp = id_comprobante
          AND id_tcomp = 1
    ) != (
        SELECT SUM(importe * cantidad)
        FROM LineaComprobante
        WHERE id_comp = id_comprobante
          AND id_tcomp = 1
    ) THEN
        RAISE EXCEPTION 'El importe del comprobante no coincide con el de sus lineas';
    END IF;
    RETURN NULL;
END $$ LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS fn_up_linea_comprobante CASCADE;
CREATE OR REPLACE FUNCTION fn_up_linea_comprobante()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la nueva tupla es una Factura, chequeo el importe
    -- para el nuevo ID.
    IF (NEW.id_tcomp = 1) THEN
        IF (
            SELECT SUM(importe * cantidad)
            FROM LineaComprobante
            WHERE NEW.id_comp = id_comp
              AND 1 = id_tcomp
        ) != (
            SELECT importe
            FROM Comprobante
            WHERE NEW.id_comp = id_comp
              AND 1 = id_tcomp
        ) THEN
            RAISE EXCEPTION 'El importe del comprobante no coincide con el de sus lineas';
        END IF;
    END IF;
    -- CASO A: (NEW.id_tcomp != 1) ???
    -- Si el NEW.id_tcomp != 1, esto significa que el OLD
    -- es 1 (mirar el WHEN). Se chequea importe para
    -- el OLD. De la tupla NEW y OLD, hay una que es fact.
    -- CASO B: (NEW id_tcomp = 1)
    -- Si el OLD.id_tcomp = 1 y el id_comp cambia
    -- (hay dos facturas a chequear: la nueva y la vieja),
    -- se chequea el importe para el ID viejo. Si el
    -- id_comp no cambia entonces se trata de la misma
    -- factura que se chequeó arriba.
    IF NEW.id_tcomp != 1 OR
       OLD.id_tcomp = 1 AND NEW.id_comp != OLD.id_comp
    THEN
        IF (
            NEW.id_comp != OLD.id_comp OR
            NEW.id_tcomp != OLD.id_tcomp
        ) THEN
            IF (
                SELECT SUM(importe * cantidad)
                FROM LineaComprobante
                WHERE OLD.id_comp = id_comp
                  AND 1 = id_tcomp
            ) != (
                SELECT importe
                FROM Comprobante
                WHERE OLD.id_comp = id_comp
                  AND 1 = id_tcomp
            ) THEN
                RAISE EXCEPTION 'El importe del comprobante no coincide con el de sus lineas';
            END IF;
        END IF;
    END IF;
    RETURN NULL;
END $$ LANGUAGE 'plpgsql';

-- Funcion de actualizacion y eliminacion de Equipo
DROP FUNCTION IF EXISTS fn_in_up_equipo CASCADE;
CREATE OR REPLACE FUNCTION fn_in_up_equipo()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 'Hay otro cliente con la ip'
        FROM Equipo
        WHERE id_cliente != NEW.id_cliente
          AND ip = NEW.ip
    ) THEN
        RETURN NULL;
    ELSE
        RAISE EXCEPTION 'Existe otro cliente que tiene la IP dada';
    END IF;
END $$ LANGUAGE 'plpgsql';

-- Funcion de actualización de la Vista2
DROP FUNCTION IF EXISTS fn_update_Vista2 CASCADE;
CREATE OR REPLACE FUNCTION fn_update_Vista2()
RETURNS TRIGGER AS $$
BEGIN
    if (NEW != OLD) THEN
        -- si no existen, da error de FK
        IF (
            NEW.id_cliente != OLD.id_cliente OR
            NEW.id_servicio != OLD.id_servicio
        ) THEN
            UPDATE Equipo SET
                id_cliente = NEW.id_cliente,
                id_servicio = NEW.id_servicio
            WHERE
                id_cliente = OLD.id_cliente AND
                id_servicio = OLD.id_servicio;
        END IF;
        IF (
           NEW.tipo != OLD.tipo OR
           NEW.tipodoc != OLD.tipodoc OR
           NEW.nrodoc != OLD.nrodoc OR
           NEW.nombre != OLD.nombre OR
           NEW.apellido != OLD.apellido OR
           NEW.fecha_nacimiento != OLD.fecha_nacimiento OR
           NEW.fecha_alta != OLD.fecha_alta OR
           NEW.fecha_baja IS DISTINCT FROM OLD.fecha_baja OR
           NEW.CUIT IS DISTINCT FROM OLD.CUIT OR
           NEW.activo != OLD.activo OR
           NEW.mail IS DISTINCT FROM OLD.mail OR
           NEW.telef_area IS DISTINCT FROM OLD.telef_area OR
           NEW.telef_numero IS DISTINCT FROM OLD.telef_numero
        ) THEN
            UPDATE Persona SET
                tipo = NEW.tipo,
                tipodoc = NEW.tipodoc,
                nrodoc = NEW.nrodoc,
                nombre = NEW.nombre,
                apellido = NEW.apellido,
                fecha_nacimiento = NEW.fecha_nacimiento,
                fecha_alta = NEW.fecha_alta,
                fecha_baja = NEW.fecha_baja,
                CUIT = NEW.CUIT,
                activo = NEW.activo,
                mail = NEW.mail,
                telef_area = NEW.telef_area,
                telef_numero = NEW.telef_numero
            WHERE
                id_persona = NEW.id_cliente;
        END IF;
        IF NEW.saldo IS DISTINCT FROM OLD.saldo THEN
            UPDATE Cliente SET
                saldo = NEW.saldo
            WHERE
                id_cliente = NEW.id_cliente;
        END IF;
        IF (
            NEW.nombre_servicio != OLD.nombre_servicio OR
            NEW.costo != OLD.costo
        ) THEN
            UPDATE Servicio SET
                nombre = NEW.nombre_servicio,
                costo = NEW.costo
            WHERE
                id_servicio = NEW.id_servicio;
        END IF;
    END IF;
    RETURN NEW;
END $$ LANGUAGE 'plpgsql';

-- Funcion de eliminación de la Vista2
DROP FUNCTION IF EXISTS fn_delete_Vista2 CASCADE;
CREATE OR REPLACE FUNCTION fn_delete_Vista2()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Equipo
    WHERE id_cliente = OLD.id_cliente
      AND id_servicio = OLD.id_servicio;
    RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';

/* --------------------------------- DEFINICION DE TRIGGERS --------------------------------- */

-- TRIGGER : Equipo INSERT
DROP TRIGGER IF EXISTS tr_in_equipo ON Equipo;
CREATE OR REPLACE TRIGGER tr_in_equipo
AFTER INSERT ON Equipo
FOR EACH ROW
WHEN (
    NEW.id_cliente IS NOT NULL
    AND NEW.ip IS NOT NULL
)
EXECUTE FUNCTION fn_in_up_equipo();

-- TRIGGER : Equipo UPDATE
DROP TRIGGER IF EXISTS tr_up_equipo ON Equipo;
CREATE OR REPLACE TRIGGER tr_up_equipo
AFTER UPDATE OF id_cliente, ip ON Equipo
FOR EACH ROW
WHEN (
    NEW.ip IS NOT NULL AND
    NEW.id_cliente IS NOT NULL AND (
        NEW.ip IS DISTINCT FROM OLD.ip OR
        NEW.id_cliente IS DISTINCT FROM OLD.id_cliente
    )
)
EXECUTE FUNCTION fn_in_up_Equipo();

-- TRIGGER : Comprobante UPDATE
DROP TRIGGER IF EXISTS tr_up_comprobante ON Comprobante;
CREATE CONSTRAINT TRIGGER tr_up_comprobante
AFTER UPDATE OF importe ON comprobante
DEFERRABLE
INITIALLY DEFERRED
FOR EACH ROW
WHEN (NEW.id_tcomp = 1 AND NEW.importe != OLD.importe)
EXECUTE FUNCTION fn_up_comprobante();
-- TRIGGER : LineaComprobante UPDATE
DROP TRIGGER IF EXISTS tr_up_linea_comprobante ON Comprobante;
CREATE CONSTRAINT TRIGGER tr_up_linea_comprobante
AFTER UPDATE OF id_comp, id_tcomp, importe, cantidad
ON LineaComprobante
DEFERRABLE
INITIALLY DEFERRED
FOR EACH ROW
WHEN (( -- si cambia alguno entonces me fijo si la tupla
        -- anterior o la nueva era una factura
        NEW.id_tcomp != OLD.id_tcomp OR
        NEW.id_comp != OLD.id_comp OR
        NEW.importe != OLD.importe OR
        NEW.cantidad != OLD.cantidad
    ) AND (NEW.id_tcomp = 1 OR OLD.id_tcomp = 1)
)
EXECUTE FUNCTION fn_up_linea_comprobante();

-- TRIGGER : LineaComprobante DELETE
DROP TRIGGER IF EXISTS tr_del_linea_comprobante ON Comprobante;
CREATE CONSTRAINT TRIGGER tr_del_linea_comprobante
AFTER DELETE ON LineaComprobante
DEFERRABLE
INITIALLY DEFERRED
FOR EACH ROW
-- me importa solo si era una factura
WHEN (OLD.id_tcomp = 1)
EXECUTE FUNCTION fn_indel_linea_comprobante();

-- TRIGGER : LineaComprobante INSERT
DROP TRIGGER IF EXISTS tr_in_linea_comprobante ON Comprobante;
CREATE CONSTRAINT TRIGGER tr_in_linea_comprobante
AFTER INSERT ON LineaComprobante
DEFERRABLE
INITIALLY DEFERRED
FOR EACH ROW
-- me importa solo si es una factura
WHEN (NEW.id_tcomp = 1)
EXECUTE FUNCTION fn_indel_linea_comprobante();

-- TRIGGER : Vista2 UPDATE
DROP TRIGGER IF EXISTS tr_update_Vista2 ON Vista2;
CREATE OR REPLACE TRIGGER tr_update_Vista2
INSTEAD OF UPDATE ON Vista2
FOR EACH ROW
EXECUTE FUNCTION fn_update_Vista2();

-- TRIGGER : Vista2 DELETE
DROP TRIGGER IF EXISTS tr_delete_Vista2 ON Vista2;
CREATE OR REPLACE TRIGGER tr_delete_Vista2
INSTEAD OF DELETE ON Vista2
FOR EACH ROW
EXECUTE FUNCTION fn_delete_Vista2();

/* --------------------------------- MODIFICACION DE TABLAS --------------------------------- */

-- modificacion de comprobacion de trigger tr_in_up_equipo
-- (se inserta 2 equipos de mismo cliente e ip y luego, se cambia el id_cliente)
INSERT INTO Equipo (
    id_equipo,
    nombre,
    MAC,
    id_cliente,
    ip,
    id_servicio,
    ap,
    fecha_alta,
    fecha_baja,
    tipo_conexion,
    tipo_asignacion
) VALUES
    (1000, 'eq1000', 1, 34, '34', 1, NULL, CURRENT_TIMESTAMP, NULL, NULL, NULL),
    (1001, 'eq1001', 1, 34, '34', 1, NULL, CURRENT_TIMESTAMP, NULL, NULL, NULL);
UPDATE Equipo SET
    id_cliente = 35
WHERE
    id_equipo = 1001;
-- recuperacion
DELETE FROM Equipo
WHERE id_equipo = 1000
   OR id_equipo = 1001;

-- modificacion de comprobacion de pr_generar_informe(timestamp, timestamp)
-- (se inserta un empleado sin turno para ver como responde a nulos)
INSERT INTO Personal
VALUES (40, 1);

-- modificacion de comprobacion de Vista1
-- (todos los clientes son de Napoli)
UPDATE Direccion SET
    id_barrio = 77
WHERE id_persona IN (
    SELECT id_cliente
    FROM Cliente
);

-- modificacion de comprobacion de Vista1
-- (todos los clientes, que cumplen la condicion, tienen menos de 30 años)
UPDATE Persona SET
    fecha_nacimiento = CURRENT_TIMESTAMP
WHERE id_persona IN (
    SELECT id_cliente
    FROM Equipo
    WHERE id_servicio IS NOT NULL
    GROUP BY id_cliente
    HAVING COUNT(DISTINCT id_servicio) > 3
        INTERSECT
    SELECT id_persona
    FROM Direccion
    WHERE id_barrio IN (
        SELECT id_barrio
        FROM Barrio
        WHERE id_ciudad = (
            SELECT id_ciudad
            FROM Ciudad
            WHERE nombre ilike 'napoli'
        )
    )
);

-- modificacion de comprobacion de Vista2
-- (todos los clientes, que cumplen la condicion, tienen fecha_alta de este año)
UPDATE Persona SET
    fecha_alta = CURRENT_TIMESTAMP
WHERE id_persona IN (
    SELECT id_cliente
    FROM Equipo
);

-- modificacion de comprobacion de Vista3
-- (la mitad de los servicios son NO periodicos)
UPDATE Servicio SET
    periodico = FALSE
WHERE id_servicio < (
    SELECT COUNT(*) / 2
    FROM Servicio
);
UPDATE Servicio SET
    periodico = TRUE
WHERE id_servicio >= (
    SELECT COUNT(*) / 2
    FROM Servicio
);

-- actualizaciones sobre Vista2
-- modificacion de comprobacion de Triggers sobre Vista2

-- se insertan datos de un servicio
INSERT INTO Servicio (
    id_servicio,
    nombre,
    periodico,
    costo,
    intervalo,
    tipo_intervalo,
    activo,
    id_cat
) VALUES
    (1000,'serv1,','false','37.52','5','semana','true',2),
    (2000,'serv2,','false','40.52','5','semana','true',2);
-- se insertan datos de personas
INSERT INTO Persona (
    id_persona,
    tipo,
    tipodoc,
    nrodoc,
    nombre,
    apellido,
    fecha_nacimiento,
    activo
) VALUES
    (1000,'P','DNI',24872875,'nom1','app1','2003-1-1',true),
    (2000,'P','DNI',24872875,'nom2','app2','2004-1-1',true);
-- se insertan datos de clientes
INSERT INTO Cliente (
    id_cliente,
    saldo
)  VALUES
    (1000, 4000),
    (2000, 3000);
-- se insertan datos de equipos
INSERT INTO Equipo (
    id_equipo,
    nombre,
    MAC,
    id_servicio,
    id_cliente,
    fecha_alta
) VALUES
    (1000,'pede.', 'MAC1',1000,1000, CURRENT_TIMESTAMP),
    (2000,'pede.', 'MAC1',1000,2000, CURRENT_TIMESTAMP),
    (3000,'pede.', 'MAC1',2000,1000, CURRENT_TIMESTAMP),
    (4000,'pede.', 'MAC1',2000,2000, CURRENT_TIMESTAMP);

-- sentencias de actualización
--(1)
UPDATE Vista2 SET
    id_cliente = 2000,
    saldo = 5000,
    nombre = 'cambie'
WHERE
    id_cliente = 1000;
--(2)
DELETE FROM Vista2
WHERE id_cliente = 2000
  AND id_servicio = 1000;
--(3)
UPDATE Vista2 SET
    id_cliente = 1000,
    nombre_servicio = 'cambie'
WHERE
    id_cliente = 2000;

-- sentencias de recuperación
DELETE FROM Equipo
WHERE id_cliente = 1000
   OR id_cliente = 2000;
DELETE FROM Servicio
WHERE id_servicio = 1000
   OR id_servicio = 2000;
DELETE FROM Cliente
WHERE id_cliente = 1000
   OR id_cliente = 2000;
DELETE FROM Persona
WHERE id_persona = 1000
   OR id_persona = 2000;

-- modificacion de comprobacion de pr_generar_facturas
-- (se agregan los comprobantes)
CALL pr_generar_facturas(
'La fecha de carga es ' || current_date,
'La fecha de carga es ' || current_date
);
CALL pr_generar_facturas_antes(
'La fecha de carga es ' || current_date,
'La fecha de carga es ' || current_date
);

-- sentencias de recuperación
-- (se borran las lineas)
DELETE FROM LineaComprobante
WHERE descripcion ILIKE 'la fecha de carga es %';
-- (se borran los comprobantes)
DELETE FROM Comprobante
WHERE comentario ILIKE 'la fecha de carga es %';

/* ---------------------------------- CONSULTAS DE TABLAS ----------------------------------- */

----------- RESULTADOS DE INFORME

-- Resultado de pr_generar_informe(timestamp, timestamp) luego de las modificaciones
CALL pr_generar_informe(
MAKE_TIMESTAMP(2000, 10, 30, 0, 0, 0),
  MAKE_TIMESTAMP(2024, 10, 31, 0, 0, 0)
);
SELECT * FROM Informe;

-- Resultado de pr_generar_informe_alt(timestamp, timestamp)
CALL pr_generar_informe_alt(
MAKE_TIMESTAMP(2000, 10, 30, 0, 0, 0),
  MAKE_TIMESTAMP(2024, 10, 31, 0, 0, 0)
);
SELECT * FROM Informe;

----------- RESULTADOS DE VISTA1

-- ANTES
SELECT * FROM Vista1_anterior;

-- DESPUES
SELECT * FROM Vista1;

-- ALTERNATIVA
SELECT * FROM Vista1_alternativa;

-- Rendimiento ANTES
EXPLAIN ANALYZE SELECT * FROM Vista1_anterior;

-- Rendimiento DESPUES
EXPLAIN ANALYZE SELECT * FROM Vista1;

-- Rendimiento ALTERNATIVA
EXPLAIN ANALYZE SELECT * FROM Vista1_alternativa;

----------- RESULTADOS DE VISTA2

-- ANTES
SELECT * FROM Vista2_anterior;

-- DESPUES
SELECT * FROM Vista2;

-- Rendimiento ANTES
EXPLAIN ANALYZE SELECT * FROM Vista2_anterior;

-- Rendimiento DESPUES
EXPLAIN ANALYZE SELECT * FROM Vista2;

----------- RESULTADOS DE VISTA3

-- ANTES
SELECT * FROM Vista3_anterior;

-- DESPUES
SELECT * FROM Vista3;

-- ALTERNATIVA
SELECT * FROM Vista3_alternativa;

-- Rendimiento ANTES
EXPLAIN ANALYZE SELECT * FROM Vista3_anterior;

-- Rendimiento DESPUES
EXPLAIN ANALYZE SELECT * FROM Vista3;

-- Rendimiento ALTERNATIVA
EXPLAIN ANALYZE SELECT * FROM Vista3_alternativa;

----------- CONSULTAS

-- consulta que muestra nuevos comprobantes
SELECT
    id_comp,
    id_tcomp,
    fecha,
    comentario,
    fecha_vencimiento,
    importe,
    id_cliente
FROM Comprobante
WHERE comentario ILIKE 'La fecha de carga es %';

-- consulta que muestra nuevas lineas_comprobantes
SELECT *
FROM LineaComprobante
WHERE descripcion ILIKE 'La fecha de carga es %';

/* ------------------------------------- TRANSACCIONES -------------------------------------- */

-- consulta de comprobación
SELECT id_comp, id_tcomp, Comprobante.importe, nro_linea, LineaComprobante.importe, cantidad
FROM LineaComprobante
JOIN Comprobante USING (id_comp, id_tcomp)
WHERE id_tcomp = 1
ORDER BY id_comp;

-- esta transacción comprueba el insert en LineaComprobante
START TRANSACTION ;
-- inserta nueva linea
INSERT INTO LineaComprobante (
    nro_linea,
    id_comp,
    id_tcomp,
    descripcion,
    cantidad,
    importe,
    id_servicio
) VALUES
(2, 11, 1, 'La fecha de carga es <null>', 1, 83, 1);
-- actualiza el importe del comprobante
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe + 83
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción comprueba el delete en LineaComprobante
START TRANSACTION;
-- borra una linea
DELETE FROM LineaComprobante
WHERE id_comp = 11 AND id_tcomp = 1 AND nro_linea = 2;
-- actualiza el importe del comprobante
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe - 83
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

START TRANSACTION;
UPDATE Comprobante SET importe = importe - 1
WHERE id_comp = 999 AND id_tcomp = 1;
UPDATE LineaComprobante SET importe = importe - 1
WHERE nro_linea = 1 AND id_comp = 999 AND id_tcomp = 1;
END;

-- esta transacción comprueba el update de cantidad en LineaComprobante
START TRANSACTION ;
-- actualiza la cantidad
UPDATE LineaComprobante SET
    cantidad = 2
WHERE id_comp = 11 AND id_tcomp = 1 AND nro_linea = 209;
-- actualiza el importe del comprobante
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe - 92 * 2
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción comprueba el update de importe en LineaComprobante
START TRANSACTION ;
-- actualiza el importe
UPDATE LineaComprobante SET
    importe = 20
WHERE id_comp = 11 AND id_tcomp = 1 AND nro_linea = 209;
-- actualiza el importe del comprobante
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe - 92 * 2 + 20 * 2
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción comprueba el update de ID en LineaComprobante
START TRANSACTION ;
-- actualiza el ID
UPDATE LineaComprobante SET
    id_comp = 13
WHERE id_comp = 11 AND id_tcomp = 1 AND nro_linea = 209;
-- actualiza los importes de los comprobantes
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe + 20 * 2
WHERE id_comp = 13
  AND id_tcomp = 1;
UPDATE Comprobante SET
    importe = importe - 20 * 2
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción comprueba el update de ID y cantidad en LineaComprobante
START TRANSACTION ;
-- actualiza el ID
UPDATE LineaComprobante SET
    cantidad = 6,
    id_comp = 11
WHERE id_comp = 13 AND id_tcomp = 1 AND nro_linea = 209;
-- actualiza los importes de los comprobantes
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe - 20 * 2
WHERE id_comp = 13
  AND id_tcomp = 1;
UPDATE Comprobante SET
    importe = importe + 20 * 6
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción comprueba el update de ID (no factura) y cantidad en LineaComprobante
START TRANSACTION ;
-- actualiza el ID
UPDATE LineaComprobante SET
    cantidad = 2,
    id_comp = 7,
    id_tcomp = 3
WHERE id_comp = 11 AND id_tcomp = 1 AND nro_linea = 209;
-- actualiza los importes de los comprobantes
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe - 20 * 6
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

START TRANSACTION ;
-- actualiza el ID
UPDATE LineaComprobante SET
    cantidad = 4,
    importe = 2,
    id_comp = 11,
    id_tcomp = 1
WHERE id_comp = 7 AND id_tcomp = 3 AND nro_linea = 209;
-- actualiza los importes de los comprobantes
-- (suma el de la nueva linea)
UPDATE Comprobante SET
    importe = importe + 8
WHERE id_comp = 11
  AND id_tcomp = 1;
END;

-- esta transacción permuta los comprobantes
-- nota: se puede hacer esto porque se pueden
-- dropear las restricciones fk.
START TRANSACTION ;
-- Realiza las operaciones que necesitas
-- se quita la restriccion fk
ALTER TABLE LineaComprobante DROP
    CONSTRAINT fk_lineacomprobante_comprobante;
-- ocurren las permutaciones
-- (997 => 999)
UPDATE Comprobante SET
    id_comp = 999
WHERE id_comp = 997
  AND id_tcomp = 1;
-- (998 => 997)
UPDATE Comprobante SET
    id_comp = 997
WHERE id_comp = 998
  AND id_tcomp = 1;
-- (999 => 998)
UPDATE Comprobante SET
    id_comp = 998
WHERE id_comp = 999
  AND id_tcomp = 1;
-- se vuelve a agregar la restriccion fk
ALTER TABLE LineaComprobante ADD
    CONSTRAINT fk_lineacomprobante_comprobante
    FOREIGN KEY (id_comp, id_tcomp)
    REFERENCES Comprobante (id_comp, id_tcomp)
    DEFERRABLE
    INITIALLY DEFERRED;
END;

-- sentencias de recuperación
-- (se borran las lineas)
DELETE FROM LineaComprobante
WHERE descripcion ILIKE 'la fecha de carga es %';
-- (se borran los comprobantes)
DELETE FROM Comprobante
WHERE comentario ILIKE 'la fecha de carga es %';
