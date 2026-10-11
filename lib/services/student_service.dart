// =============================================================
// Pertemuan 6 - Tahap 12
// Service untuk data mahasiswa
// =============================================================

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class StudentService {
  Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
