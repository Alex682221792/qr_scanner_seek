# qr_scanner_app

Reto técnico para el proceso de seleccion de la empresa SEEK.

## Introducción

Esta aplicacion permite el escaneo de códigos QR y para poder acceder a esta funcionalidad se requiere de autenticación biométrica.

Estructura:

- apps: aplicación principal en la que se encuentran implemetandas las vistas, dominios, lógica de negocio
- packages: en esta carpeta se encuentran los plugins de las funcionalidades nativas para autenticación biométrica y para el escaneo de códigos QR


## Detalles técnicos

Las funcionalidades de autenticación son nativas, esto se logró mediante la creación de plugins y el uso de Pigeon para exponer el código nativo de cada plugin, por cierto en este caso se utilizó Kotlin y Swift para Android e iOS respectivamente.

Adicional en nuestra aplicación principales hemos implementado las siguientes librerias externas:
- get_it: para el manejo de inyección de dependencias
- flutter_bloc: para el manejo de estados dentro de la app
- go_router: para gestionar la navegación entre las pantallas de la aplicación
- hive_flutter: para almacenamiento de datos de forma local

Como último detalle cabe mencionar la implementación de Clean Architecture, para lograr una estructura más organizada y con responsabilidades mejor definidas entras las diferentes capas que componen la aplicación.

## Cómo ejecutarlo?

Para el manejo de microfrontends en este proyecto se ha usado Melos por lo cual necesitamos asegurar que este se encuentre activo:
-   dart pub global activate melos

Luego ejecutamos el comando:
-   melos bootstrap

Esto resolverá las dependencias de nuestros packages y de nuestra aplicación principal

Por último para ejecutar la aplicación lo podemos hacer de la siguiente manera:
- cd apps/qr_scanner_seek
- flutter run
