~~=========================================~~

~~TABLA: USUARIOS~~

~~=========================================~~

|<del>**Nombre**</del>|<del>**tipo**</del>|<del>**Restricción**</del>|<del>**Descripción**</del>|
|-|-|-|-|
|~~id\_clie~~|~~NUMBER~~|~~PK~~|~~Identificador del usuario~~|
|~~nombre~~|~~VARCHAR2(50)~~|~~NOT NULL~~|~~Nombre del usuario~~|
|~~apellido~~|~~VARCHAR2(50)~~|~~NOT NULL~~|~~Apellido del usuario~~|
|~~correo~~|~~VARCHAR2(100)~~|~~NOT NULL, UNIQUE~~|~~Correo de ingreso~~|
|~~password\_hash~~|~~VARCHAR2(255)~~|~~NOT NULL~~|~~Hash de la contraseña del usuario~~|
|~~telefono~~|~~VARCHAR2(10)~~|~~NULL, CHECK (<br />    telefono IS NULL<br />    OR REGEXP\_LIKE(telefono, '^\[0-9]{10}$')<br />)~~|~~Teléfono contacto usuario~~|



=========================================

TABLA: VENTAS

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_venta|NUMBER|PK|Identificador venta|
|id\_clie|NUMBER|FK, NOT NULL|Identificador usuario|
|fecha|DATE|NOT NULL|Fecha de la venta|
|monto\_total|NUMBER(10,2)|NOT NULL, CHECK(monto\_total >= 0)|Cantidad a pagar por el usuario|
|calle\_envio|VARCHAR2(100)|NOT NULL||
|numero\_ext\_envio|VARCHAR2(15)|NOT NULL||
|numero\_int\_envio|VARCHAR2(15)|NULL||
|colonia\_envio|VARCHAR2(100)|NOT NULL||
|municipio\_envio|VARCHAR2(100)|NOT NULL||
|estado\_envio|VARCHAR2(100)|NOT NULL||
|cp\_envio|VARCHAR2(5)|NOT NULL, CHECK (REGEXP\_LIKE(cp\_envio, '^\[0-9]{5}$'))||
|referencia\_envio|VARCHAR2(255)|NULL||
|estatus|VARCHAR2(15)|NOT NULL, DEFAULT 'PENDIENTE',<br />CHECK (estatus IN ('PENDIENTE','PAGADO','ENVIADO','ENTREGADO','CANCELADO'))||

=========================================

TABLA: DETALLE\_VENTA

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_venta|NUMBER|PK, FK|Identificador de venta|
|id\_producto|NUMBER|PK, FK|Identificador del producto|
|cantidad|NUMBER(5)|NOT NULL, CHECK(cantidad > 0)|Cantidad de productos|
|precio\_unitario|NUMBER(10,2)|NOT NULL, CHECK(precio\_unitario > 0)|Precio por unidad|
|subtotal|NUMBER(10,2)|NOT NULL, GENERATED ALWAYS AS<br />(cantidad \* precio\_unitario) VIRTUAL|total sin envió|



~~=========================================~~

~~TABLA: ESTADOS~~

~~=========================================~~

|<del>**Nombre**</del>|<del>**tipo**</del>|<del>**Restricción**</del>|<del>**Descripción**</del>|
|-|-|-|-|
|~~id\_estado~~|~~NUMBER~~|~~PK~~|~~Identificador del estado~~|
|~~nombre~~|~~VARCHAR2(50)~~|~~NOT NULL, UNIQUE~~|~~Nombre del estado~~|

=========================================

~~TABLA: MUNICIPIOS~~

~~=========================================~~

|<del>**Nombre**</del>|<del>**tipo**</del>|<del>**Restricción**</del>|<del>**Descripción**</del>|
|-|-|-|-|
|~~id\_municipio~~|~~NUMBER~~|~~PK~~|~~Identificador del municipio~~|
|~~id\_estado~~|~~NUMBER~~|~~FK, PK~~|~~Llave compuesta~~|
|~~nombre~~|~~VARCHAR2(50)~~|~~NOT NULL~~|~~Nombre del municipio~~|

~~PK (id\_estado, id\_municipio)~~

~~FK (id\_estado) → ESTADOS(id\_estado)~~

~~UNIQUE (id\_estado, nombre)~~

=========================================

TABLA: DIRECCIONES

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_direccion|NUMBER|PK|Identificador de la dirección|
|id\_clie|NUMBER|FK, NOT NULL|Identificador del usuario|
|calle|VARCHAR2(50)|NOT NULL|Nombre de la calle donde se encuentra en domicilio|
|numero\_ext|VARCHAR2(15)|NOT NULL|Numero de la casa o edificio|
|numero\_int|VARCHAR2(15)|NULL|Numero interior del edificio|
|colonia|VARCHAR2(50)|NOT NULL|Colonia del domicilio|
|cp|VARCHAR2(5)|NOT NULL, CHECK (REGEXP\_LIKE(cp, '^\[0-9]{5}$'))|Código postal|
|referencia|VARCHAR2(255)|NULL|Información adicional para facilitar la localización del domicilio|
|id\_municipio|NUMBER|FK compuesta, NOT NULL||
|id\_estado|NUMBER|FK compuesta, NOT NULL||

FK (id\_estado, id\_municipio)

→ MUNICIPIOS(id\_estado, id\_municipio)

=========================================

TABLA: CARRITO

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_carrito|NUMBER|PK|Identificador del carrito|
|id\_clie|NUMBER|FK, NOT NULL|Identificador del usuario (cliente)|
|fecha\_creacion|DATE|NOT NULL, DEFAULT SYSDATE|Fecha en la que se inicio el carrito|
|estatus|NUMBER(1)|NOT NULL, DEFAULT 1, CHECK (estatus IN (0,1))|Indica si el carrito sigue activo:<br />1 = activo<br />0 = cerrado o convertido en venta|

=========================================

TABLA: DETALLE\_CARRITO

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_carrito|NUMBER|PK, FK|Identificador del carrito|
|id\_producto|NUMBER|PK, FK|Identificador del producto|
|cantidad|NUMBER(5)|NOT NULL, CHECK(cantidad > 0)|Cantidad que se tiene de cada producto|

=========================================

TABLA: PRODUCTOS

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_producto|NUMBER|PK|Identificador del producto|
|id\_categoria|NUMBER|FK, NOT NULL|Identificador de la categoría|
|nombre|VARCHAR2(100)|NOT NULL|Nombre del producto|
|codigo\_barras|VARCHAR2(14)|UNIQUE, NULL|Código de barras del fabricante|
|presentacion|VARCHAR2(50)|NOT NULL|Presentación comercial del producto|
|descripcion|VARCHAR2(500)|NULL|Descripción del producto|
|precio|NUMBER(10,2)|NOT NULL, CHECK (precio >= 0)|Precio actual de venta|
|stock|NUMBER(5)|NOT NULL, CHECK (stock >= 0)|Cantidad disponible en tienda|
|img|VARCHAR2(255)|NULL|Ruta donde se almacena la imagen del producto|
|estatus|NUMBER(1)|NOT NULL, CHECK (estatus IN (0,1)), DEFAULT 1|1 = producto activo<br />0 = producto inactivo o descontinuado|

=========================================

TABLA: CATEGORIAS

=========================================

|**Nombre**|**tipo**|**Restricción**|**Descripción**|
|-|-|-|-|
|id\_categoria|NUMBER|PK|Identificador de categoría|
|nombre|VARCHAR2(50)|NOT NULL, UNIQUE|Nombre de la categoría|
|descripcion|VARCHAR2(255)|NULL|Descripción de esa categoría|



