// Override at build time with --dart-define=API_HOST=https://your-api.example.
const String apiHost = String.fromEnvironment(
  'API_HOST',
  defaultValue: 'https://guardiapp.cecar.cloud',
);

const String apiBaseUrl = '$apiHost/api';

const String apiHealthUrl = '$apiHost/healthz';
