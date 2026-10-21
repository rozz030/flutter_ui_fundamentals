// =============================================================
// Pertemuan 7 - Tahap 12
// Main: Supabase Client + Service → Repository → Provider
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
import 'screens/main_shell.dart';
import 'services/course_supabase_service.dart';

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

  // =============================================================
  // INISIALISASI SUPABASE
  // =============================================================
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  // =============================================================
  // SERVICE → REPOSITORY
  // =============================================================
  final repository = CourseRepository(CourseSupabaseService());

  // =============================================================
  // REPOSITORY → PROVIDER
  // =============================================================
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
      home: const MainShell(),
    );
  }
}
