// =============================================================
// Pertemuan 6 - Tahap 4
// ValueNotifier & ValueListenableBuilder
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
// TAHAP 3: buildCourseCard menerima isFavorite dan onFavoriteChanged.
// =============================================================
Widget buildCourseCard(
  BuildContext context,
  Map<String, dynamic> course, {
  required bool isFavorite,
  required VoidCallback onFavoriteChanged,
}) {
  final String status = course['status'] as String;

  final bool isDone = status == 'done';
  final bool isActive = status == 'active';

  final IconData statusIcon = isDone
      ? Icons.check_circle
      : isActive
      ? Icons.play_circle
      : Icons.schedule;

  final String statusText = isDone
      ? 'Selesai'
      : isActive
      ? 'Aktif'
      : 'Direncanakan';

  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(statusIcon),
      title: Text(
        course['title'] as String,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${course['code']} • ${course['credits']} SKS'),
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
            builder: (context) =>
                CourseDetailPage(course: course, statusText: statusText),
          ),
        );
      },
    ),
  );
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  // Local State (Tahap 1)
  bool showExtraInfo = false;

  // Tahap 3: single source of truth untuk status favorit
  bool isFavorite = false;

  // ===========================================================
  // TAHAP 4: ValueNotifier<int>
  // Wadah untuk satu nilai (jumlah favorit).
  // Siapa pun yang mendengarkan akan otomatis di-rebuild
  // saat nilainya berubah - TANPA memanggil setState().
  // ===========================================================
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  // ValueNotifier kedua untuk demo perbandingan: penghitung klik.
  final ValueNotifier<int> clickCounter = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  void dispose() {
    // WAJIB: bersihkan ValueNotifier agar tidak memory leak.
    favoriteCount.dispose();
    clickCounter.dispose();
    super.dispose();
  }

  // Method yang memakai setState() - untuk perbandingan.
  void incrementWithSetState() {
    setState(() {
      // Tidak ada state int di sini, kita pakai dummy supaya
      // setState benar-benar rebuild seluruh halaman.
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
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
          final courses = data['courses'] as List<dynamic>;

          final int totalCourses = courses.length;

          final int totalCredits = courses.fold<int>(
            0,
            (sum, course) => sum + (course['credits'] as int),
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

              // ---------- LOCAL STATE (Tahap 1) ----------
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

              // ---------- TAHAP 3: Lifting State Up ----------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lifting State Up - Tahap 3',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Satu sumber state (parent), tiga widget pembaca.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      FavoriteStatusChild(isFavorite: isFavorite),
                      const SizedBox(height: 8),
                      FavoriteToggleChild(
                        isFavorite: isFavorite,
                        onToggle: toggleFavorite,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nilai saat ini: '
                        '${isFavorite ? "FAVORIT" : "BUKAN FAVORIT"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =================================================
              // TAHAP 4: ValueNotifier & ValueListenableBuilder
              // -------------------------------------------------
              // Bandingkan dengan setState():
              // - setState()   -> rebuild SELURUH halaman
              // - ValueNotifier -> rebuild HANYA widget pembungkusnya
              //
              // Buktikan: tambahkan print() di build() parent,
              // lalu klik tombol setState vs tombol ValueNotifier.
              // =================================================
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

                      // ---------- ValueNotifier #1: favoriteCount ----------
                      const Text(
                        'Contoh 1: Jumlah Favorit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // ValueListenableBuilder HANYA membungkus Text ini.
                      // Saat favoriteCount berubah, hanya Text ini yang rebuild.
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

                      // ---------- ValueNotifier #2: clickCounter ----------
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
                            // Perubahan nilai TANPA setState().
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

              ...courses.map(
                (course) => buildCourseCard(
                  context,
                  course as Map<String, dynamic>,
                  isFavorite: isFavorite,
                  onFavoriteChanged: toggleFavorite,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================
// CHILD 1: hanya menerima nilai.
// =============================================================
class FavoriteStatusChild extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatusChild({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Text('Status Favorites: ${isFavorite ? "Aktif" : "Tidak aktif"}');
  }
}

// =============================================================
// CHILD 2: menerima nilai + callback.
// =============================================================
class FavoriteToggleChild extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteToggleChild({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onToggle,
        child: Text(
          isFavorite ? 'Ubah menjadi Tidak Aktif' : 'Ubah menjadi Aktif',
        ),
      ),
    );
  }
}

// =============================================================
// Halaman Detail Mata Kuliah.
// =============================================================
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  final String statusText;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.statusText,
  });

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
                    course['title'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  _detailRow('Kode Mata Kuliah', course['code'].toString()),
                  _detailRow('Jumlah SKS', '${course['credits']} SKS'),
                  _detailRow('Status', statusText),
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
// Root App.
// =============================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}
