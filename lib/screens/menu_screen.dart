import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../state/auth_state.dart';
import 'login_screen.dart';
import 'history_screen.dart';
import 'register_screen.dart'; // NOVO: Importa a tela de Registro
import 'home_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _changeProfilePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      try {
        final bytes = await File(image.path).readAsBytes();

        // Converte para Base64 e adiciona prefixo (para Image.memory)
        final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        await Provider.of<AuthState>(context, listen: false).updateProfilePhoto(base64String);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil atualizada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar imagem: $e')),
        );
      }
    }
  }

  // Função que decide se exibe a foto (Base64) ou o ícone padrão
  Widget _buildProfileImage(String? base64Data) {
    if (base64Data == null || base64Data.isEmpty) {
      return const Icon(Icons.person, size: 30, color: Color(0xFF1A3D30));
    }

    try {
      String cleanBase64 = base64Data.split(',').last;
      final bytes = base64Decode(cleanBase64);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
      );
    } catch (e) {
      return const Icon(Icons.error, size: 30, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A3D30),
      child: Consumer<AuthState>(
        builder: (context, authState, _) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // CABEÇALHO (Foto de Perfil e Nome)
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF2C5F4F)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: authState.isAuthenticated ? () => _changeProfilePhoto(context) : null,
                      child: Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: _buildProfileImage(authState.profilePhotoBase64),
                            ),
                          ),
                          if (authState.isAuthenticated)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7FAD9E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, size: 14, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      authState.isAuthenticated
                          ? 'Olá, ${authState.userName}'
                          : 'Bem-vindo, Visitante',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // --- ITENS CONDIICIONAIS ---
              if (authState.isAuthenticated)
              // Se Logado: Histórico
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.white),
                  title: Text('Minhas Solicitações', style: GoogleFonts.poppins(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistoryScreen(userId: authState.userId!),
                      ),
                    );
                  },
                ),

              if (!authState.isAuthenticated)
              // Se NÃO Logado: Opção de REGISTRAR
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.white),
                  title: Text('Registrar', style: GoogleFonts.poppins(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                ),

              const Divider(color: Colors.white24),

              // Item de Login/Logout
              ListTile(
                leading: Icon(
                  authState.isAuthenticated ? Icons.logout : Icons.login,
                  color: Colors.white,
                ),
                title: Text(
                  authState.isAuthenticated ? 'Sair' : 'Entrar',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onTap: () {
                  if (authState.isAuthenticated) {
                    authState.logout();
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  } else {
                    // Navega para Login, se o usuário não estiver logado.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}