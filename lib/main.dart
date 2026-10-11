// =============================================================
// Pertemuan 6 - Tahap 3
// Lifting State Up & Single Source of Truth
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
// Child TIDAK menyimpan state sendiri - hanya menerima dan mengirim aksi.
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

  // Local State (Tahap 1) - hanya dipakai Dashboard.
  bool showExtraInfo = false;

  // ===========================================================
  // TAHAP 3: SINGLE SOURCE OF TRUTH.
  // Satu-satunya tempat nilai favorit disimpan.
  // Semua widget di bawah membaca dari sini.
  // ===========================================================
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // Satu-satunya method yang mengubah state favorit.
  // Dipanggil oleh child lewat callback onToggle / onFavoriteChanged.
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

              // ---------- Ringkasan pembelajaran ----------
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

              // =================================================
              // TAHAP 3: LIFTING STATE UP & SINGLE SOURCE OF TRUTH.
              // Parent memegang satu nilai `isFavorite`.
              // Tiga widget berbeda membaca dari nilai yang sama:
              //   (1) FavoriteStatusChild   -> menampilkan teks status
              //   (2) FavoriteToggleChild   -> tombol pengubah
              //   (3) Semua CourseCard      -> ikon hati
              // =================================================
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

                      // (1) Child hanya menerima data.
                      FavoriteStatusChild(isFavorite: isFavorite),

                      const SizedBox(height: 8),

                      // (2) Child menerima data + callback.
                      FavoriteToggleChild(
                        isFavorite: isFavorite,
                        onToggle: toggleFavorite,
                      ),

                      const SizedBox(height: 8),

                      // Info tambahan untuk membuktikan konsistensi.
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

              // ---------- Daftar Mata Kuliah ----------
              const Text(
                'Daftar Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // (3) Setiap CourseCard juga membaca `isFavorite`
              //     yang sama dari parent.
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
// CHILD 1: hanya menerima nilai, tidak menyimpan state.
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
// CHILD 2: menerima nilai + callback, tidak menyimpan state.
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
// Halaman Detail Mata Kuliah (tetap sama seperti sebelumnya).
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
