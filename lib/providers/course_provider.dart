// =============================================================
// Pertemuan 6 - Tahap 6
// Course Provider
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // State utama
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // State saat menyimpan course baru
  bool isSaving = false;

  // Mengambil data courses melalui Repository.
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
      courses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Membuat course baru melalui Repository.
  Future<void> createCourse(Course course) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);

      // Refresh data setelah berhasil membuat course.
      await loadCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
