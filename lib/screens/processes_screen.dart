import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/denuncia_model.dart';
import '../services/api_service.dart';
import '../state/auth_state.dart';

class ProcessesScreen extends StatefulWidget {
  const ProcessesScreen({super.key});

  @override
  State<ProcessesScreen> createState() => _ProcessesScreenState();
}

class _ProcessesScreenState extends State<ProcessesScreen> {
  final ApiService _apiService = ApiService();
  Future<List<DenunciaModel>>? _processesFuture;
  int? _loadedUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = Provider.of<AuthState>(context);

    if (authState.userId != null && authState.userId != _loadedUserId) {
      _loadedUserId = authState.userId;
      _processesFuture = _apiService.getHistorico(authState.userId!);
    }
  }

  Widget _buildPreview(DenunciaModel item) {
    final placeholder = Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: const Icon(Icons.image_not_supported, color: Colors.white70),
    );

    if (item.imgDenBase64 == null || item.imgDenBase64!.isEmpty) {
      return placeholder;
    }

    try {
      final cleanBase64 = item.imgDenBase64!.split(',').last;
      final bytes = base64Decode(cleanBase64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      );
    } catch (_) {
      return placeholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processos em andamento'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folhas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Builder(
            builder: (context) {
              if (authState.userId == null) {
                return Center(
                  child: Text(
                    'Faça login para acompanhar suas denúncias.',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                );
              }

              if (_processesFuture == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7FAD9E)),
                );
              }

              return FutureBuilder<List<DenunciaModel>>(
                future: _processesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF7FAD9E)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum processo encontrado.',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    );
                  }

                  final processos = snapshot.data!;

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: processos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = processos[index];
                      final statusColor = item.isPendente
                          ? const Color(0xFFE5BE01)
                          : const Color(0xFF7FAD9E);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPreview(item),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.dataSolicitacao,
                                        style: GoogleFonts.inter(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: statusColor),
                                        ),
                                        child: Text(
                                          item.isPendente ? 'PENDENTE' : 'PROTOCOLADO',
                                          style: GoogleFonts.poppins(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.descricao,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!item.isPendente) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Protocolo: ${item.codigoProtocolo}',
                                      style: GoogleFonts.sourceCodePro(
                                        color: statusColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
