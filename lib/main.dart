import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'theme/colores.dart';

void main() {
  runApp(const GuardiApp());
}

class GuardiApp extends StatelessWidget {
  const GuardiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardiApp',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('es'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primario),
        useMaterial3: true,
        // Configuración global de fuentes
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

