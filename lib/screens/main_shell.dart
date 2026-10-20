import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_notifier.dart';
import 'add_course_page.dart';
import 'courses_page.dart';
import 'dashboard_page.dart';
import 'favorites_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Halaman yang ditampilkan sesuai tab.
  static const List<Widget> _pages = [
    DashboardPage(),
    CoursesPage(),
    FavoritesPage(),
  ];

  void _openAddCoursePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCoursePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER IDENTITAS MAHASISWA ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Text(
                'Komang Rossi Adi Utama • 2415051106',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            Expanded(
              child: IndexedStack(index: _currentIndex, children: _pages),
            ),
          ],
        ),
      ),

      // Tombol tambah course.
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddCoursePage,
        tooltip: 'Tambah Course',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: Consumer<FavoriteNotifier>(
        builder: (context, favNotifier, _) {
          final int favCount = favNotifier.count;

          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text('$favCount'),
                  isLabelVisible: favCount > 0,
                  child: const Icon(Icons.favorite),
                ),
                label: 'Favorites',
              ),
            ],
          );
        },
      ),
    );
  }
}
