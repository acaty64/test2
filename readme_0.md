Laravel 12
PHP 8.3
========
This is a simple Laravel 12 project with Dusk and Docker configured to run Dusk tests using Chromium and ChromeDriver installed from the Debian repositories.
It includes a script to verify that Chromium and ChromeDriver are installed and compatible.

Construcciòn de la imagen Docker
-----------------------------
Run the `build` script to build the Docker image:
```bash
./build
```
Ejecuciòn de contenedor Docker
-----------------------------
Run the `indocker` script to start a Docker container and install Composer dependencies:
```bash
./indocker
```

Ejecuciòn de servidor web dentro del contenedor Docker
-------------------------------------------------------------
This will start the web server inside the Docker container. You can access the application at http://localhost:8000 
```bash
./dock start

Ejecuciòn de pruebas Dusk dentro del contenedor Docker
-------------------------------------------------------------
Run the `indocker` script to start a Docker container, ensure Chromium and ChromeDriver are installed and compatible, and run Dusk tests:   
```bash
docker exec -it app bash php artisan dusk

