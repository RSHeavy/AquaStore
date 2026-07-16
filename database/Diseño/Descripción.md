Realizar el modelado relacional de una base de datos de un aquario, donde se tenga las siguientes entidades



Entidades

* ~~Clientes (usuarios)~~

  * ~~id\_clie (PK)~~
  * ~~nombre(s)~~
  * ~~apellido(s)~~
  * ~~correo~~
  * ~~password\_hash~~
  * ~~teléfono~~



* ~~Direcciones~~

  * ~~id\_direccion (PK)~~
  * ~~id\_clie (FK)~~
  * ~~calle~~
  * ~~numero~~
  * ~~colonia~~
  * ~~ciudad~~
  * ~~estado~~
  * ~~c.p~~
  * ~~referencia~~



* ~~Ventas (pedido)~~

  * ~~id\_venta (PK)~~
  * ~~id\_clie (FK)~~
  * ~~fecha~~
  * ~~monto\_total~~
  * ~~direccion\_envio~~



* ~~Detalle venta~~

  * ~~id\_detalle\_venta (PK)~~
  * ~~id\_venta (FK)~~
  * ~~id\_producto (FK)~~
  * ~~cantidad~~
  * ~~precio\_unitario~~
  * ~~subtotal~~



* ~~Productos~~

  * ~~id\_producto (PK)~~
  * ~~id\_categoria (FK)~~
  * ~~nombre~~
  * ~~descripción~~
  * ~~precio~~
  * ~~stock~~
  * ~~img~~
  * ~~activo~~



* ~~Categorías~~

  * ~~id\_categoria~~
  * ~~nombre~~
  * ~~descripción~~



* ~~Carrito~~

  * ~~id\_carrito (PK)~~
  * ~~id\_clie (FK)~~
  * ~~fecha\_ceacion~~
  * ~~estado~~



* ~~Detalle carrito~~

  * ~~id\_detalle\_carrito (PK)~~
  * ~~id\_carrito (FK)~~
  * ~~id\_producto (FK)~~
  * ~~cantidad~~
  * ~~subtotal~~

