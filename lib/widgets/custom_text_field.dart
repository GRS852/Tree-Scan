import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  // --- CORREÇÃO AQUI: Renomeando 'obscure' para 'isPassword' ---
  final bool isPassword;

  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboard,
    this.validator,
    // --- CORREÇÃO AQUI: Usando 'isPassword' no construtor ---
    this.isPassword = false,
    // --------------------------------------------------------
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      style: GoogleFonts.poppins(color: Colors.white),

      // --- USANDO O NOVO NOME DO PARÂMETRO ---
      obscureText: isPassword, // Usa 'isPassword' para definir obscureText
      // ----------------------------------------

      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)),

        prefixIcon: icon != null
            ? Icon(icon, color: Colors.white.withOpacity(0.7))
            : null,

        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7FAD9E)),
        ),
      ),
    );
  }
}