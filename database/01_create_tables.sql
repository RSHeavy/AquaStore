CREATE TABLE estados(
    id_estado NUMBER,
    nombre VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_estados PRIMARY KEY (id_estado),
    CONSTRAINT uk_estado_nombre UNIQUE(nombre)
);

CREATE TABLE municipios(
    id_municipio NUMBER,
    id_estado NUMBER,
    nombre VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_municipios PRIMARY KEY (id_estado, id_municipio),
    CONSTRAINT fk_municipios_estados
       FOREIGN KEY  (id_estado)
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

    CONSTRAINT pk_usuarios PRIMARY KEY (id_clie),
    CONSTRAINT uk_usuarios_correo UNIQUE(correo),
    CONSTRAINT chk_usuarios_telefono CHECK(telefono IS NULL
                                       OR REGEXP_LIKE(telefono, '^[0-9]{10}$'))
);

CREATE TABLE carrito(
    id_carrito NUMBER,
    id_clie NUMBER NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE NOT NULL,
    estatus NUMBER(1) DEFAULT 1 NOT NULL,

    CONSTRAINT pk_carrito PRIMARY KEY (id_carrito),
    CONSTRAINT fk_carrito_usuarios 
       FOREIGN KEY (id_clie)
    REFERENCES usuarios(id_clie),
    CONSTRAINT chk_carrito_estatus CHECK (estatus IN (0,1))
);

CREATE TABLE direcciones(
    id_direccion NUMBER,
    id_clie NUMBER NOT NULL,
    calle VARCHAR2(50) NOT NULL,
    numero_ext VARCHAR2(15) NOT NULL,
    numero_int VARCHAR2(15),
    colonia VARCHAR2(50) NOT NULL,
    cp VARCHAR2(5) NOT NULL,
    referencia VARCHAR2(255),
    id_estado NUMBER NOT NULL,
    id_municipio NUMBER NOT NULL,

    CONSTRAINT pk_direcciones PRIMARY KEY (id_direccion),
    CONSTRAINT fk_direcciones_municipios
       FOREIGN KEY (id_estado, id_municipio)
    REFERENCES municipios(id_estado, id_municipio),
    CONSTRAINT fk_direcciones_usuarios
       FOREIGN KEY (id_clie)
    REFERENCES usuarios(id_clie),
    CONSTRAINT chk_direcciones_cp CHECK (REGEXP_LIKE(cp, '^[0-9]{5}$'))
);

CREATE TABLE categorias(
    id_categoria NUMBER,
    nombre  VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(255),

    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria),
    CONSTRAINT uk_categorias_nombre UNIQUE(nombre)
);

CREATE TABLE productos(
    id_producto NUMBER,
    id_categoria NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    codigo_barras VARCHAR2(14),
    presentacion VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(500),
    precio NUMBER(10,2) NOT NULL,
    stock NUMBER(5) NOT NULL,
    imagen VARCHAR2(255),
    estatus NUMBER(1) DEFAULT 1 NOT NULL,

    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT fk_productos_categoria 
       FOREIGN KEY (id_categoria)
    REFERENCES categorias(id_categoria),
    CONSTRAINT uk_productos_codigo_barras UNIQUE(codigo_barras),
    CONSTRAINT chk_productos_precio CHECK (precio >= 0),
    CONSTRAINT chk_productos_stock CHECK (stock >= 0),
    CONSTRAINT chk_productos_estatus CHECK (estatus IN (0,1))
);

CREATE TABLE detalle_carrito(
    id_carrito NUMBER,
    id_producto NUMBER,
    cantidad NUMBER(5) NOT NULL,

    CONSTRAINT pk_detalle_carrito PRIMARY KEY (id_carrito, id_producto),
    CONSTRAINT fk_detalle_carrito_carrito
       FOREIGN KEY (id_carrito)
    REFERENCES carrito(id_carrito),
    CONSTRAINT fk_detalle_carrito_producto
       FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto),
    CONSTRAINT chk_detalle_carrito_cantidad CHECK(cantidad > 0)
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

    CONSTRAINT pk_ventas PRIMARY KEY (id_venta),
    CONSTRAINT fk_ventas_usuarios
       FOREIGN KEY (id_clie)
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

    CONSTRAINT pk_detalle_venta PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT fk_detalle_venta_ventas
       FOREIGN KEY  (id_venta)
    REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_venta_productos
       FOREIGN KEY  (id_producto)
    REFERENCES productos(id_producto),
    CONSTRAINT chk_detalle_venta_cantidad CHECK(cantidad > 0),
    CONSTRAINT chk_detventa_precio CHECK(precio_unitario >= 0)
);