// =============================================================
// Pertemuan 7 - Tahap 8
// Screen: CoursesPage
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_notifier.dart';
import '../widgets/course_card.dart';
import 'edit_course_page.dart';

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

                  return Column(
                    children: [
                      buildCourseCard(
                        context,
                        course,
                        isFavorite: favNotifier.isFavorite(course.code),
                        onFavoriteChanged: () {
                          favNotifier.toggle(course.code);
                        },
                      ),

                      const SizedBox(height: 8),

                      // -------- TOMBOL EDIT --------
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: course.id == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditCoursePage(
                                        course: course,
                                        courseId: course.id!,
                                      ),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // -------- TOMBOL DELETE --------
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: course.id == null
                              ? null
                              : () async {
                                  final courseProvider = context
                                      .read<CourseProvider>();

                                  final messenger = ScaffoldMessenger.of(
                                    context,
                                  );

                                  final bool wasFavorite = favNotifier
                                      .isFavorite(course.code);

                                  final bool? confirmed =
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Hapus Course?'),
                                            content: Text(
                                              'Apakah kamu yakin ingin '
                                              'menghapus "${course.title}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                    dialogContext,
                                                    false,
                                                  );
                                                },
                                                child: const Text('Batal'),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                    dialogContext,
                                                    true,
                                                  );
                                                },
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                  if (confirmed != true) {
                                    return;
                                  }

                                  try {
                                    await courseProvider.deleteCourse(
                                      course.id!,
                                      course.code,
                                    );

                                    if (wasFavorite) {
                                      favNotifier.toggle(course.code);
                                    }

                                    messenger
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Course berhasil dihapus.',
                                          ),
                                        ),
                                      );
                                  } catch (e) {
                                    messenger
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Gagal menghapus course: $e',
                                          ),
                                        ),
                                      );
                                  }
                                },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
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
