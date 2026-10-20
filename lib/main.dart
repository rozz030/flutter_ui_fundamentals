import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'providers/favorite_notifier.dart';
import 'repositories/course_repository.dart';
import 'screens/main_shell.dart';
import 'services/course_api_service.dart';

// Variabel Identitas (Wajib untuk bukti praktikum)
const String studentName = 'Komang Rossi Adi Utama';
const String studentId = '2415051106';

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
          create: (_) => CourseProvider(
            CourseRepository(
              CourseApiService('https://jsonplaceholder.typicode.com'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course Data Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}
