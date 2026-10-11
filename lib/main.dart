// =============================================================
// Pertemuan 6 - Tahap 8
// Membuat Model Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'models/course.dart';

const String studentName = 'Komang Rossi Adi Utama';
const String studentId = '2415051106';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

Widget buildSummaryCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// =============================================================
// TAHAP 5: CHANGE NOTIFIER
// =============================================================
class FavoriteNotifier extends ChangeNotifier {
  bool _isFavorite = false;
  int _toggleCount = 0;

  bool get isFavorite => _isFavorite;
  int get toggleCount => _toggleCount;

  void toggle() {
    _isFavorite = !_isFavorite;
    _toggleCount++;
    notifyListeners();
  }

  void reset() {
    _isFavorite = false;
    _toggleCount = 0;
    notifyListeners();
  }
}

// =============================================================
// TAHAP 8: buildCourseCard sekarang menerima Course object.
// =============================================================
Widget buildCourseCard(
  BuildContext context,
  Course course, {
  required bool isFavorite,
  required VoidCallback onFavoriteChanged,
}) {
  final IconData statusIcon = course.isDone
      ? Icons.check_circle
      : course.isActive
      ? Icons.play_circle
      : Icons.schedule;

  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(statusIcon),
      title: Text(
        course.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${course.code} • ${course.credits} SKS'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Toggle Favorit',
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteChanged,
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
    ),
  );
}

// =============================================================
// TAHAP 7: WATCH DEMO
// =============================================================
class WatchDemoCard extends StatelessWidget {
  const WatchDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<FavoriteNotifier>();

    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'context.watch - Tahap 7',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Widget ini rebuild saat state berubah.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              'Status: '
              '${notifier.isFavorite ? "FAVORIT" : "BUKAN FAVORIT"}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('Jumlah toggle: ${notifier.toggleCount} kali'),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// TAHAP 7: READ DEMO
// =============================================================
class ReadDemoCard extends StatelessWidget {
  const ReadDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'context.read - Tahap 7',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tombol hanya memanggil aksi, tidak listen.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<FavoriteNotifier>().toggle();
                    },
                    icon: const Icon(Icons.touch_app),
                    label: const Text('Toggle via read'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    context.read<FavoriteNotifier>().reset();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  bool showExtraInfo = false;

  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);
  final ValueNotifier<int> clickCounter = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
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

          // =================================================
          // TAHAP 8: Ubah data JSON menjadi List<Course>
          // dengan Course.fromJson().
          // =================================================
          final List<Course> courses = (data['courses'] as List<dynamic>)
              .map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList();

          final int totalCourses = courses.length;

          final int totalCredits = courses.fold<int>(
            0,
            (sum, course) => sum + course.credits,
          );

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

              // ---------- Ringkasan ----------
              const Text(
                'Ringkasan Pembelajaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  buildSummaryCard(
                    '$totalCourses',
                    'Mata Kuliah',
                    Icons.menu_book,
                  ),
                  buildSummaryCard('$totalCredits', 'Total SKS', Icons.school),
                ],
              ),

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

              // ---------- TAHAP 8: Model Course Demo ----------
              Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Model Course - Tahap 8',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Data JSON sudah di-parse ke object Course.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text('Jumlah course (object): ${courses.length}'),
                      if (courses.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Contoh: '
                          '${courses.first.code} - '
                          '${courses.first.title} '
                          '(${courses.first.statusLabel})',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------- TAHAP 7: watch & read ----------
              const WatchDemoCard(),
              const SizedBox(height: 16),
              const ReadDemoCard(),
              const SizedBox(height: 16),

              // ---------- TAHAP 6: Consumer ----------
              Consumer<FavoriteNotifier>(
                builder: (context, notifier, _) {
                  final bool fav = notifier.isFavorite;
                  final int count = notifier.toggleCount;

                  return Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consumer - Tahap 6 & 7',
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
                          Row(
                            children: [
                              Icon(
                                fav ? Icons.favorite : Icons.favorite_border,
                                color: fav ? Colors.red : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status: '
                                '${fav ? "FAVORIT" : "BUKAN FAVORIT"}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jumlah toggle: $count kali',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () {
                                    context.read<FavoriteNotifier>().toggle();
                                  },
                                  icon: const Icon(Icons.swap_horiz),
                                  label: const Text('Toggle Favorit'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  context.read<FavoriteNotifier>().reset();
                                },
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------- TAHAP 4: ValueNotifier ----------
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

              const SizedBox(height: 16),

              // ---------- Daftar Mata Kuliah ----------
              const Text(
                'Daftar Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Consumer<FavoriteNotifier>(
                builder: (context, notifier, _) {
                  return Column(
                    children: courses.map((course) {
                      return buildCourseCard(
                        context,
                        course,
                        isFavorite: notifier.isFavorite,
                        onFavoriteChanged: notifier.toggle,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================
// TAHAP 8: CourseDetailPage menerima Course object.
// =============================================================
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mata Kuliah')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.menu_book, size: 64)),
                  const SizedBox(height: 20),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  _detailRow('Kode Mata Kuliah', course.code),
                  _detailRow('Jumlah SKS', '${course.credits} SKS'),
                  _detailRow('Status', course.statusLabel),
                  const Divider(height: 32),
                  const Text(
                    'Identitas Mahasiswa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _detailRow('Nama', studentName),
                  _detailRow('NIM', studentId),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Root App
// =============================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoriteNotifier>(
      create: (_) => FavoriteNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learning Dashboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
