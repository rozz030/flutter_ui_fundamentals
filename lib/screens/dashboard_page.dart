// =============================================================
// Pertemuan 6 - Tahap 14
// Screen: DashboardPage
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_notifier.dart';
import '../services/student_service.dart';
import '../widgets/course_async_section.dart';
import '../widgets/read_demo_card.dart';
import '../widgets/watch_demo_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final StudentService studentService = StudentService();

  late Future<Map<String, dynamic>> studentFuture;

  bool showExtraInfo = false;

  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);
  final ValueNotifier<int> clickCounter = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    studentFuture = studentService.loadStudentData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  void dispose() {
    favoriteCount.dispose();
    clickCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data mahasiswa tidak tersedia.'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------- Profil mahasiswa ----------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 46,
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(student['nim'] as String),
                      const SizedBox(height: 4),
                      Text('Semester ${student['semester']}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------- Async Section ----------
              const CourseAsyncSection(),

              const SizedBox(height: 16),

              // ---------- Identitas ----------
              const Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$studentId - $studentName - '
                      'Ini adalah teks yang sangat panjang '
                      'untuk menguji layout',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ---------- LOCAL STATE ----------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contoh Local State',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Nama: Komang Rossi Adi Utama'),
                      const Text('NIM: 2415051106'),
                      const SizedBox(height: 8),
                      if (showExtraInfo)
                        const Text(
                          'Informasi tambahan: Local State '
                          'dikelola menggunakan setState() '
                          'dan hanya digunakan pada Dashboard.',
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              showExtraInfo = !showExtraInfo;
                            });
                          },
                          child: Text(
                            showExtraInfo
                                ? 'Sembunyikan Informasi'
                                : 'Tampilkan Informasi',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------- TAHAP 7 ----------
              const WatchDemoCard(),
              const SizedBox(height: 16),
              const ReadDemoCard(),
              const SizedBox(height: 16),

              // ---------- TAHAP 6 & 13 ----------
              Consumer<FavoriteNotifier>(
                builder: (context, notifier, _) {
                  final int count = notifier.count;

                  return Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consumer - Tahap 6 & 13',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Consumer rebuild hanya area card ini saja.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Jumlah favorit: $count',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.read<FavoriteNotifier>().reset();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset Favorit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------- TAHAP 4 ----------
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ValueNotifier - Tahap 4',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Satu nilai observable, listener sederhana.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: favoriteCount,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Jumlah Favorit: $value',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (favoriteCount.value > 0) {
                                  favoriteCount.value--;
                                }
                              },
                              icon: const Icon(Icons.remove),
                              label: const Text('Kurangi'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                favoriteCount.value++;
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Contoh 2: Penghitung Klik',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<int>(
                        valueListenable: clickCounter,
                        builder: (context, value, child) {
                          return Text(
                            'Total klik: $value kali',
                            style: const TextStyle(fontSize: 16),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: () {
                            clickCounter.value++;
                          },
                          child: const Text('Klik saya (tanpa setState)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
