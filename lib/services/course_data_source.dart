// =============================================================
// Pertemuan 7 - Tahap 9
// Data Source Contract
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();

  Future<Course> createCourse(Course course);

  Future<void> updateCourse(int id, Course course);

  Future<void> deleteCourse(int id);
}
