import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../state/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/transparent_card.dart';
import 'home_page.dart';

class DenunciaFormScreen extends StatefulWidget {
  final String imagePath;

  const DenunciaFormScreen({super.key, required this.imagePath});

  @override
  State<DenunciaFormScreen> createState() => _DenunciaFormScreenState();
}

class _DenunciaFormScreenState extends State<DenunciaFormScreen> {
  final TextEditingController _addressController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSending = false;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _prepareBase64();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _prepareBase64() async {
    try {
      final bytes = await File(widget.imagePath).readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    } catch (e) {
      debugPrint('Erro ao converter imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível processar a imagem.')),
      );
    }
  }

  Future<void> _submit() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o endereço da denúncia.')),
      );
      return;
    }

    if (_imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem ainda não processada. Aguarde.')),
      );
      return;
    }

    setState(() => _isSending = true);

    final authState = Provider.of<AuthState>(context, listen: false);
    final success = await _apiService.enviarDenuncia(
      endereco: _addressController.text,
      imagemBase64: 'data:image/jpeg;base64,$_imageBase64',
      userId: authState.userId,
    );

    if (!mounted) return;

    setState(() => _isSending = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Denúncia enviada com sucesso!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar denúncia. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folhas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TransparentCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(widget.imagePath),
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Endereço de denúncia',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _addressController,
                              label: 'Digite o endereço completo',
                              icon: Icons.map_outlined,
                            ),
                            const SizedBox(height: 24),
                            _isSending
                                ? const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : CustomButton(
                                    text: 'Enviar',
                                    onPressed: _submit,
                                    isDark: true,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
