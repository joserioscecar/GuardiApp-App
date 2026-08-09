import 'package:flutter/material.dart';
import '../theme/colores.dart';
import '../widgets/auth_text_field.dart';
import '../controllers/signup_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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
  final _ctrl = SignupController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_actualizar);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_actualizar);
    _ctrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  Future<void> _registrar() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passCtrl.text != _pass2Ctrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _ctrl.registrar(
        nombreCompleto: _nameCtrl.text.trim(),
        correo: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada con éxito. Inicia sesión.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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

                    AuthTextField(
                      controller: _nameCtrl,
                      hint: 'Nombre completo',
                      validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _emailCtrl,
                      hint: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passCtrl,
                      hint: 'Contraseña',
                      obscure: _obscurePass,
                      toggleObscure: () => setState(() => _obscurePass = !_obscurePass),
                      validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _pass2Ctrl,
                      hint: 'Confirmar contraseña',
                      obscure: _obscurePass2,
                      toggleObscure: () => setState(() => _obscurePass2 = !_obscurePass2),
                      validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null,
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
                        onPressed: _ctrl.cargando ? null : _registrar,
                        child: _ctrl.cargando
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
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
}
