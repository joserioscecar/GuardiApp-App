import 'package:flutter/material.dart';
import '../theme/colores.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Stack(
        children: [
          // Arco decorativo sutil de fondo
          Positioned(
            bottom: -90,
            right: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secundario.withOpacity(0.16),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),

                      Text(
                        '¡Bienvenido de nuevo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textoOscuro,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia sesión para continuar.',
                        style: TextStyle(color: AppColors.textoGris, fontSize: 14),
                      ),

                      const SizedBox(height: 32),

                      _buildField(
                        hint: 'Correo electrónico',
                        icon: Icons.mail_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        hint: 'Contraseña',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscure,
                        toggleObscure: () => setState(() => _obscure = !_obscure),
                      ),

                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(color: AppColors.textoGris, fontSize: 13),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secundario,
                            elevation: 3,
                            shadowColor: AppColors.secundario.withOpacity(0.5),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            // No validar credenciales, navegar a Home
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                            );
                          },
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: AppColors.textoOscuro,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.textoGris.withOpacity(0.3))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'o continúa con',
                              style: TextStyle(color: AppColors.textoGris, fontSize: 13),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.textoGris.withOpacity(0.3))),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.facebook_rounded,
                              iconColor: const Color(0xFF1877F2),
                              label: 'Facebook',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SocialButton(
                              customIcon: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textoOscuro,
                                ),
                              ),
                              label: 'Google',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: TextStyle(color: AppColors.textoGris, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            ),
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                color: AppColors.textoOscuro,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return TextField(
      obscureText: obscure,
      style: TextStyle(color: AppColors.textoOscuro, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textoGris, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textoGris, size: 20),
        suffixIcon: toggleObscure == null
            ? null
            : IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textoGris,
                  size: 20,
                ),
                onPressed: toggleObscure,
              ),
        filled: true,
        fillColor: AppColors.fondoCampo,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primario, width: 1.4),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    Key? key,
    this.icon,
    this.customIcon,
    this.iconColor,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: AppColors.textoOscuro.withOpacity(0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customIcon ?? Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textoOscuro,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}