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
  // INSERT - CREATE COURSE
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

      // Refresh list dari database agar data yang tampil
      // benar-benar sesuai dengan data di Supabase.
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
  // UPDATE COURSE
  // =============================================================
  Future<void> updateCourse(int id, Course course) async {
    if (isSaving) {
      return;
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      // Kirim data course ke Supabase melalui repository.
      await repository.updateCourse(id, course);

      // Refresh list dari database agar data yang tampil
      // benar-benar sesuai dengan data di Supabase.
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
  // DELETE COURSE
  // =============================================================
  Future<void> deleteCourse(int id, String courseCode) async {
    if (isSaving) {
      return;
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      // Hapus course berdasarkan ID melalui repository.
      await repository.deleteCourse(id);

      // Refresh list dari database setelah DELETE berhasil.
      // Dengan cara ini, data yang tampil di aplikasi
      // benar-benar mengikuti data terbaru di Supabase.
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
}
