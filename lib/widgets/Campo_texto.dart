
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    required this.valor,
    required this.placeholder,
    required this.onValorChange,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.isInvalid = false,
  });

  final String valor;
  final String placeholder;
  final ValueChanged<String> onValorChange;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: valor,
          selection: TextSelection.collapsed(offset: valor.length),
        ),
      ),
      onChanged: onValorChange,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: AppColors.textoOscuro),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.inter(color: AppColors.textoGris),
        filled: true,
        fillColor: AppColors.fondoCampo,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isInvalid ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isInvalid ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isInvalid ? Colors.red : AppColors.primario,
            width: 2,
          ),
        ),
      ),
    );
  }
}
