// =============================================================
// Pertemuan 6 - Tahap 9
// Service / Data Source
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class CourseService {
  // Membaca JSON asset dan mengembalikan List<Course>.
  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
