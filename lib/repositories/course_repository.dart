// =============================================================
// Pertemuan 6 - Tahap 10
// Repository Pattern
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.service);

  final CourseApiService service;

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  // Membuat course baru melalui API Service.
  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }
}
