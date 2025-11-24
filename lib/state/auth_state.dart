import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  int? _userId;
  String? _userName;

  // NOVO CAMPO: Para armazenar a string Base64 da foto de perfil
  String? _profilePhotoBase64;

  // --- GETTERS ---
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  int? get userId => _userId;
  String? get userName => _userName;
  // Getter para a foto Base64, usado pelo MenuScreen
  String? get profilePhotoBase64 => _profilePhotoBase64;

  final ApiService _apiService = ApiService();

  // --- MÉTODOS DE AUTENTICAÇÃO ---

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.login(email, password);

    if (result != null && result['status'] == 'success') {
      _isAuthenticated = true;
      _userId = result['user_id'];
      _userName = result['nome'];

      // CARREGA A FOTO BASE64 AO FAZER LOGIN
      _profilePhotoBase64 = result['foto_perfil_base64'];

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String nome) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.register(email, password, nome);

    _isLoading = false;
    notifyListeners();

    if (result != null && result['status'] == 'success') {
      return true;
    }
    return false;
  }

  // NOVO MÉTODO: Envia o Base64 da nova foto para o Flask e atualiza o estado
  Future<void> updateProfilePhoto(String base64Data) async {
    // Garante que haja um usuário logado
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    // Chama o serviço para enviar o Base64 e salvar no PostgreSQL
    final updatedData = await _apiService.updateProfilePhoto(_userId!, base64Data);

    _isLoading = false;
    if (updatedData != null) {
      // O 'updatedData' é a nova string Base64 retornada pelo servidor
      _profilePhotoBase64 = updatedData;
      notifyListeners();
    }
  }

  // Placeholder para compatibilidade
  Future<bool> googleSignIn() async {
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _userId = null;
    _userName = null;
    // LIMPA O CAMPO BASE64 NO LOGOUT
    _profilePhotoBase64 = null;
    notifyListeners();
  }
}