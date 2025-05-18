--AGROFARM
CREATE database agrofarm1;

\c agrofarm1;

CREATE SCHEMA seguridad;
CREATE SCHEMA produccion;
CREATE SCHEMA inventario;
CREATE SCHEMA comercial;
CREATE SCHEMA administracion;

-- Secuencias
CREATE SEQUENCE seq_rol;
CREATE SEQUENCE seq_tipo_documento;
CREATE SEQUENCE seq_persona;
CREATE SEQUENCE seq_usuario;
CREATE SEQUENCE seq_usuario_foto;
CREATE SEQUENCE seq_usuario_rol;
CREATE SEQUENCE seq_procedimiento_general;
CREATE SEQUENCE seq_raza;
CREATE SEQUENCE seq_vaca;
CREATE SEQUENCE seq_vaca_foto;
CREATE SEQUENCE seq_procedimiento_vaca;
CREATE SEQUENCE seq_sesion_ordeno;
CREATE SEQUENCE seq_inventario_leche;
CREATE SEQUENCE seq_vaca_ordeno;
CREATE SEQUENCE seq_sesion_medicamento;
CREATE SEQUENCE seq_tipo_medicamento;
CREATE SEQUENCE seq_medicamento;
CREATE SEQUENCE seq_tratamiento;
CREATE SEQUENCE seq_tratamiento_medicamento;
CREATE SEQUENCE seq_cliente;
CREATE SEQUENCE seq_precio_litro;
CREATE SEQUENCE seq_tipo_entrega;
CREATE SEQUENCE seq_venta_leche;
CREATE SEQUENCE seq_metodo_pago;
CREATE SEQUENCE seq_factura;

-- Tabla de roles
CREATE TABLE rol (
  idrol INT PRIMARY KEY DEFAULT nextval('seq_rol'),
  nombrerol VARCHAR(50) NOT NULL UNIQUE
);

-- Tipos de documento
CREATE TABLE tipo_documento (
  idtipodocumento INT PRIMARY KEY DEFAULT nextval('seq_tipo_documento'),
  nombretipodocumento VARCHAR(50) NOT NULL UNIQUE,
  estado BOOLEAN NOT NULL
);

-- Personas
CREATE TABLE persona (
  idpersona INT PRIMARY KEY DEFAULT nextval('seq_persona'),
  documento VARCHAR(30) NOT NULL UNIQUE,
  nombreuno VARCHAR(30) NOT NULL,
  nombredos VARCHAR(30),
  apellidouno VARCHAR(30) NOT NULL,
  apellidodos VARCHAR(30),
  telefono VARCHAR(20),
  tipodocumento INT NOT NULL,
  CONSTRAINT fk_persona_tipo_documento FOREIGN KEY (tipodocumento) REFERENCES tipo_documento (idtipodocumento)
);

-- Usuarios
CREATE TABLE usuario (
  idusuario INT PRIMARY KEY DEFAULT nextval('seq_usuario'),
  correo VARCHAR(100) NOT NULL UNIQUE,
  contrasenausuario VARCHAR(255) NOT NULL,
  idpersona INT NOT NULL UNIQUE,
  CONSTRAINT fk_usuario_persona FOREIGN KEY (idpersona) REFERENCES persona (idpersona)
);

-- Foto del usuario


-- Asignación de roles
CREATE TABLE usuario_rol (
  idusuariorol INT PRIMARY KEY DEFAULT nextval('seq_usuario_rol'),
  idusuario INT NOT NULL,
  idrol INT NOT NULL,
  fechaasignacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado BOOLEAN NOT NULL,
  CONSTRAINT fk_usuario_rol_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario),
  CONSTRAINT fk_usuario_rol_rol FOREIGN KEY (idrol) REFERENCES rol (idrol)
);

-- Procedimientos generales
CREATE TABLE procedimiento_general (
  idprocedimientogeneral INT PRIMARY KEY DEFAULT nextval('seq_procedimiento_general'),
  idusuario INT NOT NULL,
  fechahora TIMESTAMP NOT NULL,
  nombreprocedimiento VARCHAR(100) NOT NULL,
  horainicio TIME NOT NULL,
  horafin TIME NOT NULL,
  observaciones TEXT,
  CONSTRAINT fk_proc_general_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario)
);

-- Razas
CREATE TABLE raza (
  idraza INT PRIMARY KEY DEFAULT nextval('seq_raza'),
  nombreraza VARCHAR(50) NOT NULL UNIQUE
);

-- Vacas
CREATE TABLE vaca (
  idvaca INT PRIMARY KEY DEFAULT nextval('seq_vaca'),
  nombrevaca VARCHAR(50) NOT NULL,
  descripcion TEXT,
  fechanacimiento DATE NOT NULL,
  idraza INT NOT NULL,
  CONSTRAINT fk_vaca_raza FOREIGN KEY (idraza) REFERENCES raza (idraza)
);

-- Fotos de vacas


-- Procedimientos por vaca
CREATE TABLE procedimiento_vaca (
  idsesionprocedimiento INT PRIMARY KEY DEFAULT nextval('seq_procedimiento_vaca'),
  idvaca INT NOT NULL,
  idusuario INT NOT NULL,
  idprocedimientogeneral INT NOT NULL,
  fechahora TIMESTAMP NOT NULL,
  observaciones TEXT,
  dosis VARCHAR(50),
  CONSTRAINT fk_proc_vaca_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario),
  CONSTRAINT fk_proc_vaca_vaca FOREIGN KEY (idvaca) REFERENCES vaca (idvaca),
  CONSTRAINT fk_proc_vaca_procgeneral FOREIGN KEY (idprocedimientogeneral) REFERENCES procedimiento_general (idprocedimientogeneral)
);

-- Sesiones de ordeño
CREATE TABLE sesion_ordeno (
  idsesionordeno INT PRIMARY KEY DEFAULT nextval('seq_sesion_ordeno'),
  idusuario INT NOT NULL,
  horainicio TIME NOT NULL,
  horafin TIME NOT NULL,
  observaciones TEXT,
  CONSTRAINT fk_sesionordeno_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario)
);

-- Inventario de leche
CREATE TABLE inventario_leche (
  idinventario INT PRIMARY KEY DEFAULT nextval('seq_inventario_leche'),
  fechainicio DATE NOT NULL,
  cantidaddisponible DECIMAL(10,2) NOT NULL CHECK (cantidaddisponible >= 0),
  estado BOOLEAN NOT NULL,
  ultimaactualizacion TIMESTAMP NOT NULL,
  idsesionordeno INT NOT NULL,
  CONSTRAINT fk_inventario_sesion FOREIGN KEY (idsesionordeno) REFERENCES sesion_ordeno (idsesionordeno)
);

-- Detalle de ordeño por vaca
CREATE TABLE vaca_ordeno (
  idvacaordeno INT PRIMARY KEY DEFAULT nextval('seq_vaca_ordeno'),
  idvaca INT NOT NULL,
  idsesionordeno INT NOT NULL,
  cantidadleche DECIMAL(10,2) NOT NULL CHECK (cantidadleche >= 0),
  hora TIME NOT NULL,
  observaciones TEXT,
  CONSTRAINT fk_vacaordeno_vaca FOREIGN KEY (idvaca) REFERENCES vaca (idvaca),
  CONSTRAINT fk_vacaordeno_sesion FOREIGN KEY (idsesionordeno) REFERENCES sesion_ordeno (idsesionordeno)
);

-- Sesiones de medicamentos
CREATE TABLE sesion_medicamento (
  idsesionmedicamento INT PRIMARY KEY DEFAULT nextval('seq_sesion_medicamento'),
  idusuario INT NOT NULL,
  justificacion TEXT,
  CONSTRAINT fk_sesionmed_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario)
);

-- Tipos de medicamento
CREATE TABLE tipo_medicamento (
  idtipomedicamento INT PRIMARY KEY DEFAULT nextval('seq_tipo_medicamento'),
  tipomedicamento VARCHAR(100) NOT NULL UNIQUE
);

-- Medicamentos
CREATE TABLE medicamento (
  idmedicamento INT PRIMARY KEY DEFAULT nextval('seq_medicamento'),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  marca VARCHAR(100),
  fechavencimiento DATE,
  tipomedicamento INT NOT NULL,
  CONSTRAINT fk_medicamento_tipo FOREIGN KEY (tipomedicamento) REFERENCES tipo_medicamento (idtipomedicamento)
);

-- Tratamientos
CREATE TABLE tratamiento (
  idtratamiento INT PRIMARY KEY DEFAULT nextval('seq_tratamiento'),
  fechainicio DATE NOT NULL,
  descripcion TEXT,
  justificacion TEXT,
  idvaca INT NOT NULL,
  CONSTRAINT fk_tratamiento_vaca FOREIGN KEY (idvaca) REFERENCES vaca (idvaca)
);

-- Relación tratamiento-medicamento
CREATE TABLE tratamiento_medicamento (
  idtratamientomed INT PRIMARY KEY DEFAULT nextval('seq_tratamiento_medicamento'),
  idtratamiento INT NOT NULL,
  idmedicamento INT NOT NULL,
  CONSTRAINT fk_trat_med_trat FOREIGN KEY (idtratamiento) REFERENCES tratamiento (idtratamiento),
  CONSTRAINT fk_trat_med_med FOREIGN KEY (idmedicamento) REFERENCES medicamento (idmedicamento)
);

-- Clientes
CREATE TABLE cliente (
  idcliente INT PRIMARY KEY DEFAULT nextval('seq_cliente'),
  razonsocial VARCHAR(100) NOT NULL,
  ubicacion TEXT,
  idpersona INT NOT NULL,
  CONSTRAINT fk_cliente_persona FOREIGN KEY (idpersona) REFERENCES persona (idpersona)
);

-- Precio por litro de leche
CREATE TABLE precio_litro (
  idpreciolitro INT PRIMARY KEY DEFAULT nextval('seq_precio_litro'),
  fecha DATE NOT NULL,
  preciolitro DECIMAL(10,2) NOT NULL CHECK (preciolitro >= 0)
);

-- Tipos de entrega
CREATE TABLE tipo_entrega (
  idtipoentrega INT PRIMARY KEY DEFAULT nextval('seq_tipo_entrega'),
  nombretipoentrega VARCHAR(50) NOT NULL
);

-- Ventas de leche
CREATE TABLE venta_leche (
  idventa INT PRIMARY KEY DEFAULT nextval('seq_venta_leche'),
  idcliente INT NOT NULL,
  fechaventa DATE NOT NULL,
  cantidadlitros DECIMAL(10,2) NOT NULL CHECK (cantidadlitros > 0),
  idusuario INT NOT NULL,
  idinventario INT NOT NULL,
  idpreciolitro INT NOT NULL,
  idtipoentrega INT NOT NULL,
  CONSTRAINT fk_venta_cliente FOREIGN KEY (idcliente) REFERENCES cliente (idcliente),
  CONSTRAINT fk_venta_usuario FOREIGN KEY (idusuario) REFERENCES usuario (idusuario),
  CONSTRAINT fk_venta_inventario FOREIGN KEY (idinventario) REFERENCES inventario_leche (idinventario),
  CONSTRAINT fk_venta_precio FOREIGN KEY (idpreciolitro) REFERENCES precio_litro (idpreciolitro),
  CONSTRAINT fk_venta_entrega FOREIGN KEY (idtipoentrega) REFERENCES tipo_entrega (idtipoentrega)
);

-- Métodos de pago
CREATE TABLE metodo_pago (
  idmetodopago INT PRIMARY KEY DEFAULT nextval('seq_metodo_pago'),
  nombremetodopago VARCHAR(50) NOT NULL UNIQUE
);

-- Facturas
CREATE TABLE factura (
  idfactura INT PRIMARY KEY DEFAULT nextval('seq_factura'),
  idventa INT NOT NULL UNIQUE,
  fechafactura DATE NOT NULL,
  estadopago VARCHAR(50) NOT NULL,
  total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
  idmetodopago INT NOT NULL,
  CONSTRAINT fk_factura_venta FOREIGN KEY (idventa) REFERENCES venta_leche (idventa),
  CONSTRAINT fk_factura_metodopago FOREIGN KEY (idmetodopago) REFERENCES metodo_pago (idmetodopago)
);


ALTER TABLE rol SET SCHEMA seguridad;
ALTER TABLE tipo_documento SET SCHEMA seguridad;
ALTER TABLE persona SET SCHEMA seguridad;
ALTER TABLE usuario SET SCHEMA seguridad;

ALTER TABLE usuario_rol SET SCHEMA seguridad;

ALTER TABLE raza SET SCHEMA produccion;
ALTER TABLE vaca SET SCHEMA produccion;

ALTER TABLE procedimiento_general SET SCHEMA produccion;
ALTER TABLE procedimiento_vaca SET SCHEMA produccion;
ALTER TABLE sesion_ordeno SET SCHEMA produccion;
ALTER TABLE vaca_ordeno SET SCHEMA produccion;

ALTER TABLE inventario_leche SET SCHEMA inventario;
ALTER TABLE tipo_medicamento SET SCHEMA inventario;
ALTER TABLE medicamento SET SCHEMA inventario;
ALTER TABLE sesion_medicamento SET SCHEMA inventario;
ALTER TABLE tratamiento SET SCHEMA inventario;
ALTER TABLE tratamiento_medicamento SET SCHEMA inventario;

ALTER TABLE cliente SET SCHEMA comercial;
ALTER TABLE precio_litro SET SCHEMA comercial;
ALTER TABLE tipo_entrega SET SCHEMA comercial;
ALTER TABLE venta_leche SET SCHEMA comercial;
ALTER TABLE factura SET SCHEMA comercial;
ALTER TABLE metodo_pago SET SCHEMA comercial;



----- vistas 
-- Vista para roles
CREATE VIEW seguridad.vw_roles AS
SELECT idrol, nombrerol
FROM seguridad.rol;

-- Vista para tipos de documento
CREATE VIEW seguridad.vw_tipos_documento AS
SELECT idtipodocumento, nombretipodocumento, estado
FROM seguridad.tipo_documento;

-- Vista para asignaciones de roles de usuario
CREATE VIEW seguridad.vw_usuarios_roles AS
SELECT ur.idusuariorol, u.correo, r.nombrerol, ur.fechaasignacion, ur.estado
FROM seguridad.usuario_rol ur
JOIN seguridad.usuario u ON ur.idusuario = u.idusuario
JOIN seguridad.rol r ON ur.idrol = r.idrol;

-- Vista para razas
CREATE VIEW produccion.vw_razas AS
SELECT idraza, nombreraza
FROM produccion.raza;

-- Vista para vacas
CREATE VIEW produccion.vw_vacas AS
SELECT v.idvaca, v.nombrevaca, v.descripcion, v.fechanacimiento, r.nombreraza
FROM produccion.vaca v
JOIN produccion.raza r ON v.idraza = r.idraza;

-- Vista para tipos de medicamentos
CREATE VIEW inventario.vw_tipos_medicamento AS
SELECT idtipomedicamento, tipomedicamento
FROM inventario.tipo_medicamento;

-- Vista para medicamentos
CREATE VIEW inventario.vw_medicamentos AS
SELECT m.idmedicamento, m.nombre, m.descripcion, m.marca, m.fechavencimiento, t.tipomedicamento
FROM inventario.medicamento m
JOIN inventario.tipo_medicamento t ON m.tipomedicamento = t.idtipomedicamento;

-- Vista para precios por litro
CREATE VIEW comercial.vw_precios_litro AS
SELECT idpreciolitro, fecha, preciolitro
FROM comercial.precio_litro;

-- Vista para tipos de entrega
CREATE VIEW comercial.vw_tipos_entrega AS
SELECT idtipoentrega, nombretipoentrega
FROM comercial.tipo_entrega;

-- Vista para métodos de pago
CREATE VIEW comercial.vw_metodos_pago AS
SELECT idmetodopago, nombremetodopago
FROM comercial.metodo_pago;


-- AUDITORIAS

CREATE SCHEMA auditoria;

CREATE OR REPLACE FUNCTION auditoria.log_auditoria_json()
RETURNS TRIGGER AS $$
DECLARE
  tabla TEXT := TG_TABLE_NAME;
BEGIN
  EXECUTE format('INSERT INTO auditoria.%I (operacion, usuario, fecha, datos_anteriores, datos_nuevos) VALUES ($1, $2, $3, $4, $5)', tabla)
  USING TG_OP, current_user, now(), row_to_json(OLD), row_to_json(NEW);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE auditoria.rol (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.tipo_documento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.persona (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.usuario (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);

CREATE TABLE auditoria.usuario_rol (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);

CREATE TABLE auditoria.procedimiento_general (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.raza (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.vaca (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.procedimiento_vaca (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.sesion_ordeno (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.inventario_leche (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.vaca_ordeno (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.sesion_medicamento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.tipo_medicamento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.medicamento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);




CREATE TABLE auditoria.tratamiento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.tratamiento_medicamento (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.cliente (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.precio_litro (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TABLE auditoria.tipo_entrega (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);

CREATE TABLE auditoria.venta_leche (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);




CREATE TABLE auditoria.metodo_pago (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);




CREATE TABLE auditoria.factura (
  id SERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datos_anteriores JSONB,
  datos_nuevos JSONB
);


CREATE TRIGGER tr_audit_rol
AFTER INSERT OR UPDATE OR DELETE ON seguridad.rol
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_tipo_documento
AFTER INSERT OR UPDATE OR DELETE ON seguridad.tipo_documento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_persona
AFTER INSERT OR UPDATE OR DELETE ON seguridad.persona
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_usuario
AFTER INSERT OR UPDATE OR DELETE ON seguridad.usuario
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();


CREATE TRIGGER tr_audit_usuario_rol
AFTER INSERT OR UPDATE OR DELETE ON seguridad.usuario_rol
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_procedimiento_general
AFTER INSERT OR UPDATE OR DELETE ON produccion.procedimiento_general
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_raza
AFTER INSERT OR UPDATE OR DELETE ON produccion.raza
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_vaca
AFTER INSERT OR UPDATE OR DELETE ON produccion.vaca
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();


CREATE TRIGGER tr_audit_procedimiento_vaca
AFTER INSERT OR UPDATE OR DELETE ON produccion.procedimiento_vaca
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_sesion_ordeno
AFTER INSERT OR UPDATE OR DELETE ON produccion.sesion_ordeno
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_inventario_leche
AFTER INSERT OR UPDATE OR DELETE ON inventario.inventario_leche
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_vaca_ordeno
AFTER INSERT OR UPDATE OR DELETE ON produccion.vaca_ordeno
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_sesion_medicamento
AFTER INSERT OR UPDATE OR DELETE ON inventario.sesion_medicamento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_tipo_medicamento
AFTER INSERT OR UPDATE OR DELETE ON inventario.tipo_medicamento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_medicamento
AFTER INSERT OR UPDATE OR DELETE ON inventario.medicamento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_tratamiento
AFTER INSERT OR UPDATE OR DELETE ON inventario.tratamiento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_tratamiento_medicamento
AFTER INSERT OR UPDATE OR DELETE ON inventario.tratamiento_medicamento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_cliente
AFTER INSERT OR UPDATE OR DELETE ON comercial.cliente
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_precio_litro
AFTER INSERT OR UPDATE OR DELETE ON comercial.precio_litro
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_tipo_entrega
AFTER INSERT OR UPDATE OR DELETE ON comercial.tipo_entrega
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_venta_leche
AFTER INSERT OR UPDATE OR DELETE ON comercial.venta_leche
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_metodo_pago
AFTER INSERT OR UPDATE OR DELETE ON comercial.metodo_pago
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();

CREATE TRIGGER tr_audit_factura
AFTER INSERT OR UPDATE OR DELETE ON comercial.factura
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria_json();



INSERT INTO seguridad.rol (nombrerol)
VALUES ('Veterinario');

SELECT * FROM auditoria.rol
ORDER BY fecha DESC
LIMIT 1;
INSERT INTO seguridad.tipo_documento (nombretipodocumento, estado)
VALUES ('Cédula de Ciudadanía', true)
ON CONFLICT (nombretipodocumento) DO NOTHING;

INSERT INTO seguridad.persona (
  documento, nombreuno, nombredos, apellidouno, apellidodos, telefono, tipodocumento
)
VALUES (
  '1111111111', 'Juan', 'Carlos', 'Pérez', 'López', '3115554444',
  (SELECT idtipodocumento FROM seguridad.tipo_documento WHERE nombretipodocumento = 'Cédula de Ciudadanía')
)
RETURNING idpersona;

INSERT INTO seguridad.usuario (
  correo, contrasenausuario, idpersona
)
VALUES (
  'juan.perez@correo.com', '123456',  -- Usa una contraseña encriptada en producción
  (SELECT idpersona FROM seguridad.persona WHERE documento = '1111111111')
)
RETURNING idusuario;


-- Insertar una sesión de ordeño
INSERT INTO produccion.sesion_ordeno (idusuario, horainicio, horafin, observaciones)
VALUES (1, '06:00', '07:00', 'Ordeño de prueba') RETURNING idsesionordeno;

select * from produccion.sesion_ordeno;

-- Suponiendo que retornó el id 1
-- Insertar en inventario vinculado a esa sesión
INSERT INTO inventario.inventario_leche (fechainicio, cantidaddisponible, estado, ultimaactualizacion, idsesionordeno)
VALUES (CURRENT_DATE, 0, true, CURRENT_TIMESTAMP, 4);

-- Insertar vacas ordeñadas
INSERT INTO produccion.vaca_ordeno (idvaca, idsesionordeno, cantidadleche, hora, observaciones)
VALUES (1, 4, 5.2, '06:15', 'sin novedad'),
       (2, 4, 4.8, '06:30', 'sin novedad');

INSERT INTO produccion.raza (nombreraza)
VALUES ('Holstein')
ON CONFLICT (nombreraza) DO NOTHING;

INSERT INTO produccion.vaca (
  nombrevaca, descripcion, fechanacimiento, idraza
)
VALUES (
  'Lunaaa',
  'Vaca joven en buen estado de salud',
  '2021-08-15',
  (SELECT idraza FROM produccion.raza WHERE nombreraza = 'Holstein')
)
RETURNING idvaca;



--- PROCEDIMIENTO DE ORDEÑO

CREATE OR REPLACE PROCEDURE produccion.procesar_sesion_ordeno(
    p_idsesionordeno INT,
    p_idinventario   INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_leche DECIMAL(10,2);
BEGIN
    -- Validar que la sesión exista
    IF NOT EXISTS (
        SELECT 1
        FROM produccion.sesion_ordeno
        WHERE idsesionordeno = p_idsesionordeno
    ) THEN
        RAISE EXCEPTION 'La sesión de ordeño % no existe', p_idsesionordeno;
    END IF;

    -- Validar que el inventario exista
    IF NOT EXISTS (
        SELECT 1
        FROM inventario.inventario_leche
        WHERE idinventario = p_idinventario
    ) THEN
        RAISE EXCEPTION 'El inventario % no existe', p_idinventario;
    END IF;

    -- Calcular la leche ordeñada en la sesión
    SELECT COALESCE(SUM(cantidadleche), 0)
    INTO v_total_leche
    FROM produccion.vaca_ordeno
    WHERE idsesionordeno = p_idsesionordeno;

    -- Actualizar el inventario sumando la leche de esta sesión
    UPDATE inventario.inventario_leche
    SET cantidaddisponible = cantidaddisponible + v_total_leche,
        ultimaactualizacion = NOW()
    WHERE idinventario = p_idinventario;

    RAISE NOTICE 'Procesada sesión %: %.2f litros agregados al inventario %',
        p_idsesionordeno, v_total_leche, p_idinventario;
END;
$$;

CALL produccion.procesar_sesion_ordeno(4, 2);

select * from inventario.inventario_leche
select * from produccion.vaca_ordeno where idsesionordeno = 4

---- funcion para el login 
CREATE OR REPLACE FUNCTION seguridad.autenticar_usuario(
    p_correo TEXT,
    p_contrasenausuario TEXT
)
RETURNS TABLE (
    idusuario INT,
    correo TEXT,
    idpersona INT,
    documento TEXT,
    nombreuno TEXT,
    nombredos TEXT,
    apellidouno TEXT,
    apellidodos TEXT,
    telefono TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.idusuario,
        u.correo::TEXT,
        p.idpersona,
        p.documento::TEXT,
        p.nombreuno::TEXT,
        p.nombredos::TEXT,
        p.apellidouno::TEXT,
        p.apellidodos::TEXT,
        p.telefono::TEXT
    FROM seguridad.usuario u
    JOIN seguridad.persona p ON u.idpersona = p.idpersona
    WHERE u.correo = p_correo
      AND u.contrasenausuario = p_contrasenausuario;
END;
$$;



SELECT * 
FROM seguridad.autenticar_usuario('juan.perez@correo.com', '123456');



-- proceso de venta de leche -- 1. Tipo de documento
INSERT INTO seguridad.tipo_documento (nombretipodocumento, estado)
VALUES ('Cédula de Ciudadanía', true)
ON CONFLICT (nombretipodocumento) DO NOTHING;

-- 2. Persona
INSERT INTO seguridad.persona (
  documento, nombreuno, nombredos, apellidouno, apellidodos, telefono, tipodocumento
)
VALUES (
  '1234567890', 'Carlos', 'Andrés', 'Gómez', 'López', '3104567890',
  (SELECT idtipodocumento FROM seguridad.tipo_documento WHERE nombretipodocumento = 'Cédula de Ciudadanía')
)
RETURNING idpersona;

-- 3. Cliente
INSERT INTO comercial.cliente (razonsocial, ubicacion, idpersona)
VALUES (
  'Lácteos El Paraíso',
  'Vereda El Silencio, km 4',
  (SELECT idpersona FROM seguridad.persona WHERE documento = '1234567890')
)
RETURNING idcliente;

-- 4. Usuario (quien realiza la venta)
INSERT INTO seguridad.usuario (
  correo, contrasenausuario, idpersona
)
VALUES (
  'vendedor@agrofarm.com', '123456',
  (SELECT idpersona FROM seguridad.persona WHERE documento = '1234567890')
)
RETURNING idusuario;

-- 5. Precio por litro
INSERT INTO comercial.precio_litro (fecha, preciolitro)
VALUES (CURRENT_DATE, 2000)
RETURNING idpreciolitro;

-- 6. Tipo de entrega
INSERT INTO comercial.tipo_entrega (nombretipoentrega)
VALUES ('A domicilio')
RETURNING idtipoentrega;

-- 7. Método de pago
INSERT INTO comercial.metodo_pago (nombremetodopago)
VALUES ('Efectivo')
RETURNING idmetodopago;




CREATE OR REPLACE PROCEDURE comercial.registrar_venta_leche(
    p_idcliente INT,
    p_cantidadlitros DECIMAL(10,2),
    p_idusuario INT,
    p_idinventario INT,
    p_idpreciolitro INT,
    p_idtipoentrega INT,
    p_idmetodopago INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_disponible DECIMAL(10,2);
    v_preciolitro DECIMAL(10,2);
    v_total DECIMAL(10,2);
    v_idventa INT;
BEGIN
    -- 1. Validar inventario
    SELECT cantidaddisponible
    INTO v_disponible
    FROM inventario.inventario_leche
    WHERE idinventario = p_idinventario;

    IF v_disponible < p_cantidadlitros THEN
        RAISE EXCEPTION 'Inventario insuficiente: %.2f disponibles, %.2f requeridos',
            v_disponible, p_cantidadlitros;
    END IF;

    -- 2. Obtener precio por litro
    SELECT preciolitro
    INTO v_preciolitro
    FROM comercial.precio_litro
    WHERE idpreciolitro = p_idpreciolitro;

    -- 3. Calcular total
    v_total := v_preciolitro * p_cantidadlitros;

    -- 4. Insertar venta
    INSERT INTO comercial.venta_leche (
        idcliente,
        fechaventa,
        cantidadlitros,
        idusuario,
        idinventario,
        idpreciolitro,
        idtipoentrega
    )
    VALUES (
        p_idcliente,
        CURRENT_DATE,
        p_cantidadlitros,
        p_idusuario,
        p_idinventario,
        p_idpreciolitro,
        p_idtipoentrega
    )
    RETURNING idventa INTO v_idventa;

    -- 5. Insertar factura
    INSERT INTO comercial.factura (
        idventa,
        fechafactura,
        estadopago,
        total,
        idmetodopago
    )
    VALUES (
        v_idventa,
        CURRENT_DATE,
        'Pagado',
        v_total,
        p_idmetodopago
    );

    -- 6. Actualizar inventario
    UPDATE inventario.inventario_leche
    SET cantidaddisponible = cantidaddisponible - p_cantidadlitros,
        ultimaactualizacion = NOW()
    WHERE idinventario = p_idinventario;

    RAISE NOTICE 'Venta % registrada con total %.2f. Inventario actualizado.', v_idventa, v_total;
END;
$$;


CALL comercial.registrar_venta_leche(
    1,      -- p_idcliente
    9.5,   -- p_cantidadlitros
    1,      -- p_idusuario
    2,      -- p_idinventario
    1,      -- p_idpreciolitro
    1,      -- p_idtipoentrega
    1       -- p_idmetodopago
);

select * from inventario.inventario_leche where idinventario = 2;

select * from comercial.factura;