import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/denuncia_model.dart';
import '../widgets/custom_button.dart';

class ProcessDetailScreen extends StatelessWidget {
  final DenunciaModel process;

  const ProcessDetailScreen({super.key, required this.process});

  Widget _buildImage() {
    final placeholder = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/folha.jpg',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    );

    if (process.imgDenBase64 == null || process.imgDenBase64!.isEmpty) {
      return placeholder;
    }

    try {
      final cleanBase64 = process.imgDenBase64!.split(',').last;
      final bytes = base64Decode(cleanBase64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.memory(
          bytes,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    } catch (_) {
      return placeholder;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = process.isPendente
        ? const Color(0xFFE5BE01)
        : const Color(0xFF7FAD9E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do processo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folhas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImage(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              process.isPendente ? 'Pendente' : 'Protocolado',
                              style: GoogleFonts.poppins(
                                color: statusColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                process.dataSolicitacao,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          process.descricao,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Protocolo',
                          process.codigoProtocolo?.isNotEmpty == true
                              ? process.codigoProtocolo!
                              : 'Ainda não gerado',
                        ),
                        _buildDetailRow(
                          'Risco de queda',
                          process.riscoQueda ? 'Sim' : 'Não',
                        ),
                        _buildDetailRow(
                          'Identificador',
                          '#${process.id}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Voltar',
                    onPressed: () => Navigator.pop(context),
                    isDark: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
