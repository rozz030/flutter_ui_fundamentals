// =============================================================
// Pertemuan 6 - Tahap 15
// Debugging State Management
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

  // ===========================================================
  // KASUS A: mode "silent" untuk demo lupa notifyListeners().
  // Kalau silentMode = true, notifyListeners() TIDAK dipanggil.
  // UI tidak akan update walau state berubah.
  // ===========================================================
  bool silentMode = false;

  void _safeNotify() {
    if (silentMode) {
      // BUG DEMO: sengaja tidak memanggil notifyListeners().
      debugPrint('[KASUS A] State berubah, tapi notifyListeners() dilewati.');
      return;
    }
    notifyListeners();
  }

  void toggleSilentMode() {
    silentMode = !silentMode;
    // Panggil notifyListeners langsung (bukan _safeNotify)
    // supaya tombolnya tetap update.
    notifyListeners();
  }

  // ===========================================================
  // Fungsi utama: load courses.
  // ===========================================================
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    _safeNotify();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
      courses = [];
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  // ===========================================================
  // KASUS C: simulasi error pada service.
  // ===========================================================
  Future<void> simulateError() async {
    isLoading = true;
    error = null;
    notifyListeners();

    // Simulasi delay + error.
    await Future.delayed(const Duration(milliseconds: 800));

    error = 'Simulasi error: koneksi ke server gagal.';
    courses = [];
    isLoading = false;
    notifyListeners();
  }
}
