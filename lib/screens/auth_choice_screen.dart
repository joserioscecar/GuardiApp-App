import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import '../theme/colores.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Stack(
        children: [
          // Formas decorativas sutiles de fondo
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secundario.withOpacity(0.25),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -70,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primario.withOpacity(0.12),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Encabezado / bienvenida
                      Theme(
                        data: ThemeData(
                          iconTheme: IconThemeData(color: AppColors.primario),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/logos/N1.svg',
                          height: 172,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            AppColors.primario,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bienvenido de nuevo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textoOscuro.withOpacity(0.65),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Botón principal
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secundario,
                            elevation: 3,
                            shadowColor: AppColors.secundario.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          icon: Icon(Icons.person_add_alt_1_rounded,
                              color: AppColors.textoOscuro, size: 20),
                          label: Text(
                            'Registrarse',
                            style: TextStyle(
                              color: AppColors.textoOscuro,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botón secundario
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.textoOscuro.withOpacity(0.25),
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          icon: Icon(Icons.login_rounded,
                              color: AppColors.textoOscuro, size: 20),
                          label: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: AppColors.textoOscuro,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}