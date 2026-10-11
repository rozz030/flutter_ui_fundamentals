// =============================================================
// Pertemuan 6 - Tahap 13
// Screen: FavoritesPage
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_notifier.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer2<CourseProvider, FavoriteNotifier>(
        builder: (context, courseProvider, favNotifier, _) {
          // Ambil hanya course yang ada di daftar favorit.
          final List<Course> favoriteCourses = courseProvider.courses
              .where((c) => favNotifier.isFavorite(c.code))
              .toList();

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada mata kuliah favorit.\n'
                  'Tambahkan dari Dashboard atau Detail.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Total favorit: ${favoriteCourses.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...favoriteCourses.map((course) {
                return buildCourseCard(
                  context,
                  course,
                  isFavorite: true,
                  onFavoriteChanged: () => favNotifier.toggle(course.code),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
