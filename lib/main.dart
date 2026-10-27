import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bhgakovyfctxsrzdpogw.supabase.co',
    // The trailing special character has been removed from the key below
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ2Frb3Z5ZmN0eHNyemRwb2d3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1MzgzNzgsImV4cCI6MjA3OTExNDM3OH0.1sMo3WylxisHvfXcXdtPAbiP8EONlNhFxowNkdHmSA8',
  );

  runApp(const MyApp());
}

// Helper untuk akses mudah ke Supabase client di seluruh aplikasi
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aset Manajemen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
