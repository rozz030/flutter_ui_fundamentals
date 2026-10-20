// =============================================================
// Pertemuan 7 - State Management
// Provider: Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);

  final CourseRepository repository;

  // =============================================================
  // STATE UTAMA
  // =============================================================
  List<Course> courses = [];

  bool isLoading = false;

  bool isSaving = false;

  String? error;

  // =============================================================
  // GET COURSES
  // =============================================================
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

  // =============================================================
  // POST - CREATE COURSE
  // =============================================================
  Future<void> createCourse(Course course) async {
    if (isSaving) {
      return;
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);

      // Refresh data setelah POST berhasil.
      await loadCourses();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // =============================================================
  // PUT - UPDATE COURSE
  // =============================================================
  Future<void> updateCourse(int id, Course course) async {
    if (isSaving) {
      return;
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);

      // Update data lokal agar perubahan langsung terlihat
      // pada daftar course.
      final int index = courses.indexWhere((item) => item.code == course.code);

      if (index != -1) {
        courses[index] = course;
      }

      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // =============================================================
  // DELETE - DELETE COURSE
  // =============================================================
  Future<void> deleteCourse(int id, String courseCode) async {
    if (isSaving) {
      return;
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteCourse(id);

      // Hapus course dari list lokal agar perubahan
      // langsung terlihat pada halaman Courses.
      courses.removeWhere((course) => course.code == courseCode);

      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
