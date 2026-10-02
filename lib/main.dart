import 'package:flutter/material.dart';

const String studentName = 'Komang Rossi Adi Utama';
const String studentId = '2415051106';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 16 - Debugging Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DebuggingPage(),
    );
  }
}

class DebuggingPage extends StatefulWidget {
  const DebuggingPage({super.key});

  @override
  State<DebuggingPage> createState() => _DebuggingPageState();
}

class _DebuggingPageState extends State<DebuggingPage> {
  final TextEditingController commentController = TextEditingController();

  bool isLoading = false;
  bool isFavorite = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // ==========================================================
  // KASUS D - MENCEGAH NAVIGASI GANDA
  // ==========================================================

  Future<void> openDetail() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailPage()),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 - Debugging'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // IDENTITAS
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Row(
                  children: [
                    const CircleAvatar(radius: 28, child: Icon(Icons.person)),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            studentName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text('NIM: $studentId'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Debugging Challenge',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // KASUS A
            // RenderFlex Overflow
            // ==================================================
            const Text(
              'Kasus A - RenderFlex Overflow',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: [
                    const Icon(Icons.info),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        '$studentId - '
                        '$studentName - '
                        'Teks panjang yang '
                        'sudah diperbaiki '
                        'menggunakan Expanded '
                        'agar tidak menyebabkan '
                        'RenderFlex overflow.',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // KASUS B
            // ListView + Expanded
            // ==================================================
            const Text(
              'Kasus B - Unbounded Height',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              height: 220,
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  const Text(
                    'ListView berada di '
                    'dalam ruang dengan '
                    'tinggi yang jelas.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,

                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,

                          leading: CircleAvatar(child: Text('${index + 1}')),

                          title: Text('Course ${index + 1}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // KASUS C
            // KEYBOARD OVERFLOW
            // ==================================================
            const Text(
              'Kasus C - Keyboard Overflow',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: commentController,

              maxLines: 4,

              decoration: const InputDecoration(
                labelText: 'Komentar',

                hintText: 'Ketik komentar di sini...',

                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.comment),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // KASUS D
            // NAVIGASI GANDA
            // ==================================================
            const Text(
              'Kasus D - Navigasi Ganda',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Tombol dinonaktifkan selama '
              'proses navigasi berlangsung '
              'untuk mencegah route '
              'ter-push berulang kali.',
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton.icon(
                onPressed: isLoading ? null : openDetail,

                icon: const Icon(Icons.open_in_new),

                label: Text(isLoading ? 'Membuka...' : 'Buka Detail'),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // FAVORITE
            // ==================================================
            Card(
              child: ListTile(
                leading: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),

                title: const Text('Course Favorite'),

                subtitle: const Text(
                  'Contoh perubahan state '
                  'sederhana.',
                ),

                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Course ditambahkan ke favorite'
                              : 'Course dihapus dari favorite',
                        ),
                      ),
                    );
                  },

                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL PAGE
// ============================================================

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.check_circle, size: 70),

              const SizedBox(height: 20),

              const Text(
                'Halaman Detail',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Nama: $studentName\n'
                'NIM: $studentId',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
