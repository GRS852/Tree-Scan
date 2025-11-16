import 'package:flutter/foundation.dart';

/// Simples detentor de estado de autenticação sem backend.
/// Use AuthState.instance.isLoggedIn para ouvir as mudanças.
class AuthState {
  AuthState._internal();
  static final AuthState instance = AuthState._internal();

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }

  /// Fluxo de registro de espaço reservado sem backend.
  /// Retorna verdadeiro quando o registro simulado for bem-sucedido.
  Future<bool> register({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Em uma implementação real, chame seu backend (por exemplo, Firebase Auth)
    isLoggedIn.value = true;
    return true;
  }

  /// Placeholder do Google Sign-In. Retorna falso enquanto nenhum backend estiver configurado.
  /// Uma vez que a API esteja conectada, isso deve ser implementado para realizar
  /// o Google OAuth e definir [isLoggedIn] de acordo.
  Future<bool> googleSignIn() async {
    // Nenhum backend conectado: sinalize que não está disponível
    return false;
  }
}
