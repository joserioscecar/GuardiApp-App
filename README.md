# test_flutter

A new Flutter project.

## Build web y API

La app usa `https://guardiapp.cecar.cloud` por defecto. Para otro servidor:

```sh
flutter build web --dart-define=API_HOST=https://guardiapp.cecar.cloud
```

`API_HOST` debe ser el origen del API, sin `/api` ni barra final. Una web
servida por HTTPS debe usar un API HTTPS. Si la web y el API tienen orígenes
distintos, el backend debe permitir el origen de la web mediante CORS tanto
en `/healthz` como en `/api/*`, incluyendo las solicitudes OPTIONS y los
headers `Authorization` y `Content-Type`. La pantalla inicial comprueba
`/healthz`: un bloqueo CORS en esa ruta también muestra «Sin conexión».

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
