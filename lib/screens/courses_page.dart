// =============================================================
// Pertemuan 6 - Tahap 14
// Screen: CoursesPage (daftar semua mata kuliah)
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_notifier.dart';
import '../widgets/course_card.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          // -------- LOADING --------
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // -------- ERROR --------
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(provider.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<CourseProvider>().loadCourses(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------- SUCCESS --------
          final List<Course> courses = provider.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('Belum ada mata kuliah.'));
          }

          return Consumer<FavoriteNotifier>(
            builder: (context, favNotifier, _) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final Course course = courses[index];
                  return buildCourseCard(
                    context,
                    course,
                    isFavorite: favNotifier.isFavorite(course.code),
                    onFavoriteChanged: () => favNotifier.toggle(course.code),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
