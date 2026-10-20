// =============================================================
// Pertemuan 7 - Repository Pattern
// Repository: Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.service);

  final CourseApiService service;

  // =============================================================
  // GET
  // =============================================================
  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  // =============================================================
  // POST
  // =============================================================
  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }

  // =============================================================
  // PUT
  // =============================================================
  Future<void> updateCourse(int id, Course course) {
    return service.updateCourse(id, course);
  }
}
