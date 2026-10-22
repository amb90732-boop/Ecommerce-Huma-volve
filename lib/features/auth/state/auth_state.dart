import 'package:ecommerce_app_huma_volve/features/auth/data/auth_repository.dart';
import 'package:flutter/foundation.dart';

enum AuthState { checkingSession, signedOut, loading, signedIn, error }

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  AuthState status = AuthState.checkingSession;
  String? errorMessage; //that nullable..

  Future<void> checkSession() async {
    try {
      final token = await _repository.readAccessToken();
      status = token == null || token.isEmpty ? AuthState.signedOut : AuthState.signedIn;

      errorMessage = null;
    } catch(_) {
      status = AuthState.signedOut;
      errorMessage = 'cannot read data';
    }

    notifyListeners();
  }

  Future<bool> login({
    required String password,
    required String email,
  }) async {
    status = AuthState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await  _repository.login(email: email, password: password);
      status = AuthState.signedIn;
      notifyListeners();
      return true;
    } on AuthException catch(error) {
      status = AuthState.error;
      errorMessage = error.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name, 
    required String email, 
    required String password,
  }) async {
    status = AuthState.loading;
    errorMessage = null;
    notifyListeners();
    
    try {
      await _repository.register(name: name, email: email, password: password);

      status = AuthState.signedOut;
      notifyListeners();
      return true;
    } on AuthException catch(error) {
      status = AuthState.error;
      errorMessage = error.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    status = AuthState.signedOut;
    errorMessage = null;
    notifyListeners();
  }
}
