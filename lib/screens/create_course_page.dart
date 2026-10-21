// =============================================================
// Pertemuan 7 - Tahap 13
// Screen: Create Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _status = 'planned';

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

    final provider = context.read<CourseProvider>();

    final course = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      await provider.createCourse(course);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil ditambahkan.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) {
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
      appBar: AppBar(title: const Text('Create Course')),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Tambah Course Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Isi data course yang akan disimpan ke database Supabase.',
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                    hintText: 'Contoh: MOB05',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Code wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Contoh: Pemrograman Mobile',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _creditsController,
                  decoration: const InputDecoration(
                    labelText: 'Credits',
                    hintText: 'Contoh: 3',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Credits wajib diisi';
                    }

                    final credits = int.tryParse(value.trim());

                    if (credits == null) {
                      return 'Credits harus berupa angka';
                    }

                    if (credits <= 0) {
                      return 'Credits harus lebih dari 0';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'planned', child: Text('Planned')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'done', child: Text('Done')),
                  ],
                  onChanged: provider.isSaving
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _status = value;
                            });
                          }
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status wajib dipilih';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: provider.isSaving ? null : _saveCourse,
                    icon: provider.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      provider.isSaving ? 'Menyimpan...' : 'Simpan Course',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
