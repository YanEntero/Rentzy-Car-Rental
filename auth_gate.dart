import 'package:car_rental/login_and_signup/login.dart';
import 'package:car_rental/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // build appriate page based on auth state
      builder: (context, snapshot) {
        //loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        //check if there is a valid sessioncurrently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const Dashpage();
        } else {
          return const Login();
        }
      },
    );
  }
}
