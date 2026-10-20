// =============================================================
// Pertemuan 7 - Tahap 2
// Service / REST API Data Source
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Mengambil data courses dari REST API menggunakan HTTP GET.
  Future<List<Course>> loadCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
