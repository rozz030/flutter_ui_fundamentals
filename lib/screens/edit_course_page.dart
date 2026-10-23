// =============================================================
// Pertemuan 7 - Tahap 7
// Screen: Edit Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({
    super.key,
    required this.course,
    required this.courseId,
  });

  final Course course;
  final int courseId;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  late String _selectedStatus;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(text: widget.course.code);

    _titleController = TextEditingController(text: widget.course.title);

    _creditsController = TextEditingController(
      text: widget.course.credits.toString(),
    );

    // =============================================================
    // NORMALISASI STATUS
    // =============================================================
    final String status = widget.course.status.toLowerCase().trim();

    if (status == 'active' || status == 'aktif') {
      _selectedStatus = 'active';
    } else if (status == 'done' || status == 'selesai') {
      _selectedStatus = 'done';
    } else {
      _selectedStatus = 'planned';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();

    super.dispose();
  }

  // =============================================================
  // UPDATE COURSE
  // =============================================================
  Future<void> _updateCourse() async {
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final Course updatedCourse = Course(
      // Kode course tidak diubah.
      code: widget.course.code,

      // Data yang dapat diubah.
      title: _titleController.text.trim(),

      credits: int.parse(_creditsController.text.trim()),

      status: _selectedStatus,
    );

    try {
      // =========================================================
      // DEBUG UPDATE
      // =========================================================
      debugPrint('UPDATE COURSE ID: ${widget.courseId}');

      debugPrint('UPDATE COURSE DATA: ${updatedCourse.toJson()}');

      // =========================================================
      // UPDATE KE SUPABASE
      // =========================================================
      await context.read<CourseProvider>().updateCourse(
        widget.courseId,
        updatedCourse,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil diperbarui.')),
      );

      // Kembali ke halaman Courses.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui course: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================================
              // JUDUL HALAMAN
              // =================================================
              const Text(
                'Edit Mata Kuliah',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ubah data mata kuliah yang dipilih.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // =================================================
              // KODE COURSE
              // =================================================
              TextFormField(
                controller: _codeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Kode Course',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
              ),

              const SizedBox(height: 16),

              // =================================================
              // TITLE
              // =================================================
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Judul Course',
                  hintText: 'Contoh: Pemrograman Mobile',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul course wajib diisi.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================
              // CREDITS / SKS
              // =================================================
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS',
                  hintText: 'Contoh: 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'SKS wajib diisi.';
                  }

                  final int? credits = int.tryParse(value.trim());

                  if (credits == null) {
                    return 'SKS harus berupa angka.';
                  }

                  if (credits <= 0) {
                    return 'SKS harus lebih dari 0.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================
              // STATUS
              // =================================================
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Aktif')),
                  DropdownMenuItem(value: 'done', child: Text('Selesai')),
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('Direncanakan'),
                  ),
                ],
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _selectedStatus = value;
                        });
                      },
              ),

              const SizedBox(height: 24),

              // =================================================
              // TOMBOL SIMPAN PERUBAHAN
              // =================================================
              FilledButton.icon(
                onPressed: _isSubmitting ? null : _updateCourse,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSubmitting ? 'Menyimpan...' : 'Simpan Perubahan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
