import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final SupabaseClient _client = Supabase.instance.client;

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _client.auth.currentUser;

  // Mendapatkan session pengguna
  Session? get currentSession => _client.auth.currentSession;

  // Memeriksa apakah pengguna sudah login
  bool get isLoggedIn => currentSession != null;

  // Registrasi pengguna
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  // Login pengguna
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  // Logout pengguna
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
