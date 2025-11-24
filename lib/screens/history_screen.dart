import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/denuncia_model.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;

  const HistoryScreen({super.key, required this.userId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<DenunciaModel>> _historicoFuture;

  @override
  void initState() {
    super.initState();
    _historicoFuture = _apiService.getHistorico(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Minhas Solicitações',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          color: const Color(0xFF0F1410).withOpacity(0.6),
          child: FutureBuilder<List<DenunciaModel>>(
            future: _historicoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF7FAD9E)));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhuma solicitação encontrada.',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                );
              }

              final denuncias = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                itemCount: denuncias.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = denuncias[index];
                  final statusColor = item.isPendente
                      ? const Color(0xFFE5BE01)
                      : const Color(0xFF7FAD9E);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.dataSolicitacao,
                              style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!item.isPendente) ...[
                          const SizedBox(height: 8),
                          Text('Protocolo: ${item.codigoProtocolo}', style: GoogleFonts.sourceCodePro(color: statusColor, fontSize: 12)),
                        ]
                      ],
                    ),
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