import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para os campos de texto
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Cadastro', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folhas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          // Adiciona um overlay escuro para melhorar a legibilidade
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Consumer<AuthState>(
                builder: (context, authState, _) {
                  return Column(
                    children: [
                      Text(
                          'Crie sua conta',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      // CAMPO NOME
                      CustomTextField(
                          controller: _nameController,
                          label: 'Nome Completo',
                          icon: Icons.person
                      ),
                      const SizedBox(height: 15),

                      // CAMPO EMAIL
                      CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email
                      ),
                      const SizedBox(height: 15),

                      // CAMPO SENHA
                      CustomTextField(
                          controller: _passController,
                          label: 'Senha',
                          icon: Icons.lock,
                          isPassword: true
                      ),
                      const SizedBox(height: 30),

                      if (authState.isLoading)
                        const CircularProgressIndicator(color: Color(0xFF7FAD9E))
                      else
                        CustomButton(
                          text: 'CADASTRAR',
                          onPressed: () async {
                            // Chamada à API de Registro
                            bool ok = await authState.register(
                              _nameController.text,
                              _emailController.text,
                              _passController.text,
                            );

                            if (ok && mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const HomePage()),
                                (route) => false,
                              );
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Falha: Email já existe ou erro no servidor.')),
                              );
                            }
                          },
                        ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()), // ou LoginScreen
                                (route) => false,
                          ); // Volta para Login
                        },
                        child: Text(
                          'Cancelar e Voltar para Login',
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}