// =============================================================
// Pertemuan 7 - Tahap 17
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
    try {
      final data = await supabase.from('courses').select().order('id');

      return (data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data course: $e');
    }
  }

  // =============================================================
  // INSERT - MENAMBAHKAN COURSE
  // =============================================================
  @override
  Future<Course> createCourse(Course course) async {
    try {
      final row = await supabase
          .from('courses')
          .insert(course.toJson())
          .select()
          .single();

      return Course.fromJson(row);
    } catch (e) {
      throw Exception('Gagal menambahkan course: $e');
    }
  }

  // =============================================================
  // UPDATE - MENGUBAH COURSE
  // =============================================================
  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      final updatedRows = await supabase
          .from('courses')
          .update(course.toJson())
          .eq('id', id)
          .select();

      if ((updatedRows as List).isEmpty) {
        throw Exception(
          'UPDATE ditolak atau data dengan ID $id tidak ditemukan. '
          'Periksa RLS policy Supabase.',
        );
      }
    } catch (e) {
      throw Exception('Gagal memperbarui course: $e');
    }
  }

  // =============================================================
  // DELETE - MENGHAPUS COURSE
  // =============================================================
  @override
  Future<void> deleteCourse(int id) async {
    try {
      final deletedRows = await supabase
          .from('courses')
          .delete()
          .eq('id', id)
          .select();

      if ((deletedRows as List).isEmpty) {
        throw Exception(
          'DELETE ditolak atau data dengan ID $id tidak ditemukan. '
          'Periksa RLS policy Supabase.',
        );
      }
    } catch (e) {
      throw Exception('Gagal menghapus course: $e');
    }
  }
}
