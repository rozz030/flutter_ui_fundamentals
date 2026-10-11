// =============================================================
// Pertemuan 6 - Tahap 10
// Repository Pattern
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  // Repository menerima Service lewat constructor (dependency injection).
  final CourseService service;

  CourseRepository(this.service);

  // API data sederhana untuk Provider.
  // Provider tidak perlu tahu apakah data dari JSON, REST API, atau DB.
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}
