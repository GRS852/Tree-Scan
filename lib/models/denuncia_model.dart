class DenunciaModel {
  final int id;
  final String? codigoProtocolo; // Se null, é pendente
  final String descricao;
  final String dataSolicitacao;
  final bool riscoQueda;
  final String? imgDenBase64;

  DenunciaModel({
    required this.id,
    this.codigoProtocolo,
    required this.descricao,
    required this.dataSolicitacao,
    required this.riscoQueda,
    this.imgDenBase64,
  });

  bool get isPendente => codigoProtocolo == null || codigoProtocolo!.isEmpty;

  // Corrige o erro de conversão de tipos
  factory DenunciaModel.fromJson(Map<String, dynamic> json) {
    return DenunciaModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      codigoProtocolo: json['codigo_protocolo'],
      descricao: json['descricao'] ?? 'Sem descrição',
      dataSolicitacao: json['data_solicitacao'] ?? '',
      riscoQueda: json['risco_queda'] ?? false,
      imgDenBase64: json['img_den'],
    );
  }
}
