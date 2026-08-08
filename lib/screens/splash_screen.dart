import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final token = await SesionStorage().obtenerToken();
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
    return const Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      ),
    );
  }
}
