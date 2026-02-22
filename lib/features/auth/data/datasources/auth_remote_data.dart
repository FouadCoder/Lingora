import 'package:lingora/features/auth/data/models/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteData {
  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> logout();
  Future<AuthModel?> checkSession();
}

class AuthRemoteDataImpl implements AuthRemoteData {
  final SupabaseClient supabaseClient;

  AuthRemoteDataImpl(this.supabaseClient);

  @override
  Future<void> login(String email, String password) async {
    await supabaseClient.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  @override
  Future<void> signUp(String email, String password) async {
    await supabaseClient.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<AuthModel?> checkSession() async {
    final session = supabaseClient.auth.currentSession;
    if (session?.user != null) {
      return AuthModel.fromJson({
        'user_id': session!.user.id,
        'email': session.user.email,
        'created_at': session.user.userMetadata?['created_at'],
        'updated_at': session.user.userMetadata?['updated_at'],
      });
    }
    return null;
  }
}
