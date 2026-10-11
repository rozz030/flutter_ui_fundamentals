// =============================================================
// Pertemuan 6 - Tahap 12
// Refactor Struktur Folder
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'providers/favorite_notifier.dart';
import 'repositories/course_repository.dart';
import 'screens/dashboard_page.dart';
import 'services/course_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteNotifier>(
          create: (_) => FavoriteNotifier(),
        ),
        ChangeNotifierProvider<CourseProvider>(
          create: (_) => CourseProvider(CourseRepository(CourseService())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learning Dashboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
