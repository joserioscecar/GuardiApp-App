import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../config/api_config.dart';
import '../services/sesion_storage.dart';
import '../theme/colores.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _errorApi = false;

  @override
  void initState() {
    super.initState();
    _verificarApi();
  }

  Future<void> _verificarApi() async {
    try {
      final res = await http
          .get(Uri.parse(apiHealthUrl))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        if (mounted) _verificarSesion();
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _errorApi = true);
  }

  Future<void> _verificarSesion() async {
    final token = await SesionStorage().obtenerTokenValido();
    if (!mounted) return;

    final destino = (token != null && token.isNotEmpty)
        ? const HomeScreen()
        : const WelcomeScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_errorApi) {
      return Scaffold(
        backgroundColor: AppColors.fondoPantalla,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: AppColors.textoGris,
                ),
                const SizedBox(height: 20),
                Text(
                  'Sin conexión',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textoOscuro,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No se pudo conectar con el servidor.\nVerifica tu conexión e inténtalo de nuevo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textoGris,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _errorApi = false);
                    _verificarApi();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      ),
    );
  }
}
