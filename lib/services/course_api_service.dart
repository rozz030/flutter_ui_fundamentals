// =============================================================
// Pertemuan 7 - Tahap 9
// Service: Course API Service
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  // =============================================================
  // HTTP GET
  // =============================================================
  @override
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data course. '
        'Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  // =============================================================
  // HTTP POST
  // =============================================================
  @override
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': course.title,
        'body': jsonEncode(course.toJson()),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      // JSONPlaceholder mengembalikan id, title, dan body.
      // Data Course yang dikirim tetap dipertahankan sebagai
      // representasi hasil POST.
      return Course(
        code: course.code,
        title: data['title'] as String? ?? course.title,
        credits: course.credits,
        status: course.status,
      );
    }

    throw Exception(
      'Gagal membuat course. '
      'Status code: ${response.statusCode}',
    );
  }

  // =============================================================
  // HTTP PUT
  // Memperbarui data course berdasarkan id.
  // =============================================================
  @override
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal memperbarui course. '
        'Status code: ${response.statusCode}',
      );
    }
  }

  // =============================================================
  // HTTP DELETE
  // Menghapus course berdasarkan id.
  // =============================================================
  @override
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal menghapus course. '
        'Status code: ${response.statusCode}',
      );
    }
  }
}
