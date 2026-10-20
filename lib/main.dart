// =============================================================
// Pertemuan 7 - Tahap 9
// Main: Service → Repository → Provider
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'providers/favorite_notifier.dart';
import 'repositories/course_repository.dart';
import 'screens/main_shell.dart';
import 'services/course_api_service.dart';

// =============================================================
// IDENTITAS MAHASISWA
// =============================================================
const String studentName = 'Komang Rossi Adi Utama';
const String studentId = '2415051106';

// =============================================================
// BASE URL API
// Tanpa /courses sesuai instruksi Tahap 9.
// =============================================================
const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

void main() {
  // =============================================================
  // SERVICE → REPOSITORY
  // =============================================================
  final repository = CourseRepository(CourseApiService(apiBaseUrl));

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
