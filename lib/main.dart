// =============================================================
// Pertemuan 7 - Praktik 1
// Main: Supabase Authentication + Provider
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'providers/favorite_notifier.dart';
import 'repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'services/course_supabase_service.dart';
import 'services/auth_service.dart';

// =============================================================
// IDENTITAS MAHASISWA
// =============================================================
const String studentName = 'Komang Rossi Adi Utama';
const String studentId = '2415051106';

// =============================================================
// BASE URL API
// =============================================================
const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

// =============================================================
// MAIN
// =============================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  // Service → Repository
  final repository = CourseRepository(CourseSupabaseService());

  // Repository → Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteNotifier>(
          create: (_) => FavoriteNotifier(),
        ),
        ChangeNotifierProvider<CourseProvider>(
          create: (_) => CourseProvider(repository)..loadCourses(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// =============================================================
// APPLICATION
// =============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

// =============================================================
// AUTHENTICATION GATE
// Memeriksa status login pengguna
// =============================================================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
