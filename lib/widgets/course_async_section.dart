// =============================================================
// Pertemuan 6 - Tahap 13
// Widget CourseAsyncSection
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_notifier.dart';
import 'course_card.dart';
import 'summary_card.dart';

class CourseAsyncSection extends StatelessWidget {
  const CourseAsyncSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, _) {
        // -------- 1. LOADING --------
        if (provider.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Memuat data courses...'),
                ],
              ),
            ),
          );
        }

        // -------- 2. ERROR --------
        if (provider.error != null) {
          return Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terjadi kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(provider.error!),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<CourseProvider>().loadCourses();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // -------- 3. SUCCESS --------
        final List<Course> courses = provider.courses;

        final int totalCourses = courses.length;

        final int totalCredits = courses.fold<int>(
          0,
          (sum, course) => sum + course.credits,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                buildSummaryCard(
                  '$totalCourses',
                  'Mata Kuliah',
                  Icons.menu_book,
                ),
                buildSummaryCard('$totalCredits', 'Total SKS', Icons.school),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- TAHAP 11/13: Status Provider ----------
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CourseProvider - Tahap 11',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Loading / Error / Success dikelola '
                      'di satu tempat.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text('Jumlah course: ${courses.length}'),
                    const SizedBox(height: 4),
                    Text('isLoading: ${provider.isLoading}'),
                    Text('error: ${provider.error ?? "tidak ada"}'),
                    if (courses.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Contoh: '
                        '${courses.first.code} - '
                        '${courses.first.title} '
                        '(${courses.first.statusLabel})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Daftar Mata Kuliah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ---------- TAHAP 13: Favorites lintas screen ----------
            Consumer<FavoriteNotifier>(
              builder: (context, favNotifier, _) {
                return Column(
                  children: courses.map((course) {
                    return buildCourseCard(
                      context,
                      course,
                      isFavorite: favNotifier.isFavorite(course.code),
                      onFavoriteChanged: () => favNotifier.toggle(course.code),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
