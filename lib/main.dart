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

Widget buildCourseCard(Map<String, dynamic> course) {
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
      trailing: Text(statusText),
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

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
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

          final data = snapshot.data!;

          final student = data['student'] as Map<String, dynamic>;

          final courses = data['courses'] as List<dynamic>;

          final int totalCourses = courses.length;

          final int totalCredits = courses.fold(
            0,
            (sum, course) => sum + (course['credits'] as int),
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
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

              // Case A: Mengatasi teks panjang dalam Row
              const Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$studentId - $studentName - Ini adalah teks yang sangat panjang untuk menguji layout',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Daftar Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              ...courses.map(
                (course) => buildCourseCard(course as Map<String, dynamic>),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}
