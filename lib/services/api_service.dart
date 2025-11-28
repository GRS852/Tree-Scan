import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/denuncia_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Erro Login: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> register(String email, String password, String nome) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': password,
          'nome': nome,
        }),
      );

      if (response.statusCode == 201) { // 201 Created
        return jsonDecode(response.body);
      } else if (response.statusCode == 409) { // 409 Conflict (Email repetido)
        return jsonDecode(response.body);
      }

    } catch (e) {
      print('Erro ao registrar: $e');
    }
    return null;
  }

  // MÉTODO NECESSÁRIO (CORRIGE O ERRO 2)
  Future<String?> updateProfilePhoto(int userId, String base64Data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profile/photo/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'foto_base64': base64Data}), // ENVIANDO BASE64
      );

      if (response.statusCode == 200) {
        // Retorna a nova string Base64 salva pelo Flask
        return jsonDecode(response.body)['foto_perfil_base64'];
      }

    } catch (e) {
      print('Erro ao atualizar foto: $e');
    }
    return null;
  }

  Future<List<DenunciaModel>> getHistorico(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/historico/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DenunciaModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro Historico: $e');
    }
    return [];
  }

  Future<bool> enviarDenuncia({
    required String endereco,
    required String imagemBase64,
    int? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analisar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'endereco': endereco,
          'imagem_base64': imagemBase64,
          if (userId != null) 'user_id': userId,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao enviar denúncia: $e');
    }
    return false;
  }
}
