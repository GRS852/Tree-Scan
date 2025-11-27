import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:green_tree/screens/camera_screen.dart';
import 'package:green_tree/state/auth_state.dart';
import 'package:green_tree/widgets/app_bottom_nav.dart';
import 'package:green_tree/widgets/transparent_card.dart';
import 'package:green_tree/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );
  }

  Widget _buildAvatar(AuthState authState) {
    final base64Data = authState.profilePhotoBase64;

    if (authState.isAuthenticated && base64Data != null && base64Data.isNotEmpty) {
      try {
        final cleanBase64 = base64Data.split(',').last;
        final bytes = base64Decode(cleanBase64);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
        );
      } catch (_) {
        // Ignora erros de conversão e volta para a imagem padrão
      }
    }

    return Image.asset(
      'assets/images/folha.jpg',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: Consumer<AuthState>(
        builder: (context, authState, _) {
          final userName = authState.isAuthenticated && authState.userName != null
              ? authState.userName!
              : 'Tree green';

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/folhas.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(child: _buildAvatar(authState)),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(flex: 1),
                  TransparentCard(
                    child: Column(
                      children: [
                        Text(
                          'Bem vindo!',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Denúnciar',
                          onPressed: () => _navigateToCamera(context),
                          isDark: true,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
