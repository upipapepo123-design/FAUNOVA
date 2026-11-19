# FAUNOVA — Starter v0.1

FAUNOVA es un proyecto Flutter multiplataforma (Android/iOS).

## Incluido en esta primera base
- Navegación entre Inicio, Mi Dex, Capturar, Social y Perfil.
- Cámara y selector de imágenes mediante `image_picker`.
- Formulario para nombrar y categorizar un descubrimiento.
- Lista de descubrimientos en memoria mientras la app permanece abierta.
- Identidad visual inicial verde bosque / crema / dorado.

## Todavía no incluido
- Recorte automático ni editor manual de siluetas.
- Identificación automática de especies.
- Registro real con correo, Google o Apple.
- Firebase, sincronización en nube y persistencia.
- Funciones sociales reales.

Estas funciones requieren configuración de servicios, credenciales y pruebas adicionales.

## Requisitos
- Flutter SDK instalado.
- Android Studio o VS Code.
- Para compilar iOS: macOS con Xcode (o un servicio de compilación remota compatible).

## Cómo ejecutar
1. Instala Flutter siguiendo https://docs.flutter.dev/get-started/install
2. Descomprime este proyecto.
3. En la carpeta del proyecto ejecuta:
   `flutter create .`
4. Después ejecuta:
   `flutter pub get`
5. Conecta un dispositivo Android o inicia un emulador.
6. Ejecuta:
   `flutter run`

## Nota para Android
`image_picker` solicita el acceso a cámara/galería mediante los mecanismos del sistema. Prueba los permisos en un dispositivo real.

## Próxima etapa recomendada
Añadir persistencia local, luego integrar Firebase Auth y Storage; después incorporar segmentación de imágenes y reconocimiento de especies.
