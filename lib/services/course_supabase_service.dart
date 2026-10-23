// =============================================================
// Pertemuan 7 - Tahap 15
// Service: Course Supabase
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  // =============================================================
  // GET - MENGAMBIL DATA COURSE
  // =============================================================
  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =============================================================
  // INSERT - MENAMBAHKAN COURSE
  // =============================================================
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // =============================================================
  // UPDATE - MENGUBAH COURSE
  // =============================================================
  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  // =============================================================
  // DELETE - MENGHAPUS COURSE
  // =============================================================
  @override
  Future<void> deleteCourse(int id) async {
    await supabase.from('courses').delete().eq('id', id);
  }
}
