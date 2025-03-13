import 'package:car_rental/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future<dynamic>.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  await Supabase.initialize(
    url: 'https://voraqnafbetgvkpnpann.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvcmFxbmFmYmV0Z3ZrcG5wYW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0NjA0MTgsImV4cCI6MjA1NjAzNjQxOH0.mATbqhIcyCmt_SuxG7HyU2zRngN3x7zjtM2QPKBfMzU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rentzy',
      home: AuthGate(),
    );
  }
}
