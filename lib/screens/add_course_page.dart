// =============================================================
// Pertemuan 7 - Tahap 9
// Screen: Add Course Page
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _selectedStatus = 'active';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    final provider = context.read<CourseProvider>();

    try {
      await provider.createCourse(course);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil ditambahkan.')),
      );

      // Kembali ke halaman Courses setelah POST berhasil.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan course: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Course')),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tambah Mata Kuliah',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Masukkan data mata kuliah baru.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // KODE COURSE
                  // =================================================
                  TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Kode Course',
                      hintText: 'Contoh: IF101',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode course wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // JUDUL COURSE
                  // =================================================
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Course',
                      hintText: 'Contoh: Pemrograman Mobile',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.menu_book),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul course wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // SKS
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
                        return 'SKS wajib diisi';
                      }

                      final credits = int.tryParse(value.trim());

                      if (credits == null) {
                        return 'SKS harus berupa angka';
                      }

                      if (credits <= 0) {
                        return 'SKS harus lebih dari 0';
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
                    onChanged: provider.isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            }
                          },
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // TOMBOL SIMPAN
                  // =================================================
                  FilledButton.icon(
                    onPressed: provider.isSaving ? null : _saveCourse,
                    icon: provider.isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      provider.isSaving ? 'Menyimpan...' : 'Simpan Course',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
