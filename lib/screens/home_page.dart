import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_tree/screens/camera_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: Container(
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
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/folha.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Tree green',
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
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Identificador de planta',
                      onPressed: () => _navigateToCamera(context),
                      isDark: false,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
