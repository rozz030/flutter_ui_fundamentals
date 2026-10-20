// =============================================================
// Pertemuan 7 - Tahap 9
// Repository: Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  // =============================================================
  // GET
  // =============================================================
  Future<List<Course>> getCourses() {
    return dataSource.getCourses();
  }

  // =============================================================
  // POST
  // =============================================================
  Future<Course> createCourse(Course course) {
    return dataSource.createCourse(course);
  }

  // =============================================================
  // PUT
  // =============================================================
  Future<void> updateCourse(int id, Course course) {
    return dataSource.updateCourse(id, course);
  }

  // =============================================================
  // DELETE
  // =============================================================
  Future<void> deleteCourse(int id) {
    return dataSource.deleteCourse(id);
  }
}
