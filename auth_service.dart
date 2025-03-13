import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print(
        'Login Success: ${response.user}',
      ); // Debugging: Check what is returned
      return response.user;
    } catch (e) {
      print('Login Error: $e'); // Debugging: Print the real error
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUpwithEmailPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'firstName': firstName, 'lastName': lastName},
      );

      if (response.user != null) {
        // Store user data in a separate `users` table
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
        });
      }

      return response.user;
    } catch (e) {
      print('Sign-Up Error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user email
  String? getCurrentUserEmail() {
    final user = _supabase.auth.currentUser;
    print("Current User: $user"); // Debugging
    return user?.email;
  }
}
