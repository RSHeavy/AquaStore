CREATE TABLE estados(
    id_estado NUMBER,
    nombre VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_estados PRIMARY KEY(id_estado),
    CONSTRAINT uk_estado_nombre UNIQUE(nombre)
);

CREATE TABLE municipios(
    id_municipio NUMBER,
    id_estado NUMBER,
    nombre VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_municipios PRIMARY KEY(id_estado, id_municipio),
    CONSTRAINT fk_municipios_estados
       FOREIGN KEY (id_estado)
    REFERENCES estados(id_estado),
    CONSTRAINT uk_municipio_nombre UNIQUE(id_estado, nombre)
);

CREATE TABLE usuarios(
    id_clie NUMBER,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(50) NOT NULL,
    correo VARCHAR2(100) NOT NULL,
    password_hash VARCHAR2(255) NOT NULL,
    telefono VARCHAR2(10),

    CONSTRAINT pk_usuarios PRIMARY KEY(id_clie),
    CONSTRAINT uk_usuarios_correo UNIQUE(correo),
    CONSTRAINT chk_usuarios_telefono CHECK(telefono IS NULL
                                       OR REGEXP_LIKE(telefono, '^[0-9]{10}$'))
);

CREATE TABLE categorias(
    id_categoria
);

CREATE TABLE ventas(
    id_venta NUMBER,
    id_clie NUMBER NOT NULL,
    fecha DATE DEFAULT SYSDATE NOT NULL,
    monto_total NUMBER(10,2) NOT NULL,
    calle_envio VARCHAR2(100) NOT NULL,
    numero_ext_envio VARCHAR2(15) NOT NULL,
    numero_int_envio VARCHAR2(15),
    colonia_envio VARCHAR2(100) NOT NULL,
    municipio_envio VARCHAR2(100) NOT NULL,
    estado_envio VARCHAR2(100) NOT NULL,
    cp_envio VARCHAR2(5) NOT NULL,
    referencia_envio VARCHAR2(255),
    estatus VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL,

    CONSTRAINT pk_ventas PRIMARY KEY(id_venta),
    CONSTRAINT fk_ventas_usuarios
       FOREIGN KEY(id_clie)
    REFERENCES usuarios(id_clie),
    CONSTRAINT chk_ventas_monto_total CHECK(monto_total >= 0),
    CONSTRAINT chk_ventas_cp_envio CHECK(REGEXP_LIKE(cp_envio, '^[0-9]{5}$')),
    CONSTRAINT chk_ventas_estatus CHECK (estatus IN ('PENDIENTE','PAGADO','ENVIADO','ENTREGADO','CANCELADO'))
);

CREATE TABLE detalle_venta(
    id_venta NUMBER,
    id_producto NUMBER,
    cantidad NUMBER(5) NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    subtotal NUMBER(10,2) GENERATED ALWAYS AS(cantidad * precio_unitario) VIRTUAL,

    CONSTRAINT pk_detalle_venta PRIMARY KEY(id_venta, id_producto),
    CONSTRAINT fk_detalle_venta_ventas
       FOREIGN KEY (id_venta)
    REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_venta_productos
       FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto),
    CONSTRAINT chk_detalle_venta_cantidad CHECK(cantidad > 0),
    CONSTRAINT chk_detalle_venta_precio_unitario CHECK(precio_unitario > 0)
);