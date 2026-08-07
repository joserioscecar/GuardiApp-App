import 'package:flutter/material.dart';
import '../theme/colores.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;
  bool _obscurePass = true;
  bool _obscurePass2 = true;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // Botón de regreso
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textoOscuro, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: AppColors.textoOscuro,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Es rápido y seguro, únete en un minuto.',
                      style: TextStyle(color: AppColors.textoGris, fontSize: 14),
                    ),

                    const SizedBox(height: 28),

                    _buildField(
                      controller: _nameCtrl,
                      hint: 'Nombre completo',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _emailCtrl,
                      hint: 'Correo electrónico',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _passCtrl,
                      hint: 'Contraseña',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscurePass,
                      toggleObscure: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _pass2Ctrl,
                      hint: 'Confirmar contraseña',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscurePass2,
                      toggleObscure: () => setState(() => _obscurePass2 = !_obscurePass2),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _acceptTerms,
                            activeColor: AppColors.primario,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Acepto los ',
                              style: TextStyle(color: AppColors.textoGris, fontSize: 13, height: 1.4),
                              children: [
                                TextSpan(
                                  text: 'Términos y Condiciones',
                                  style: TextStyle(color: AppColors.textoOscuro, fontWeight: FontWeight.w700),
                                ),
                                const TextSpan(text: ' y la '),
                                TextSpan(
                                  text: 'Política de Privacidad',
                                  style: TextStyle(color: AppColors.textoOscuro, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primario,
                          elevation: 3,
                          shadowColor: AppColors.primario.withOpacity(0.4),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          if (!_acceptTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Debes aceptar los términos')),
                            );
                            return;
                          }
                          if (_formKey.currentState?.validate() ?? false) {
                            // Aquí iría la lógica de registro
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                            );
                          }
                        },
                        child: const Text(
                          'Crear cuenta',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('¿Ya tienes una cuenta? ',
                            style: TextStyle(color: AppColors.textoGris, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Inicia Sesión',
                            style: TextStyle(
                              color: AppColors.primario,
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
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: TextStyle(color: AppColors.textoOscuro, fontSize: 15),
      validator: (v) {
        if ((v ?? '').isEmpty) return 'Campo requerido';
        return null;
      },
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}