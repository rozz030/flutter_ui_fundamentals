// =============================================================
// Pertemuan 6 - Tahap 14
// MainShell: Bottom Navigation (Home, Courses, Favorites)
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_notifier.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga state tiap tab tetap hidup.
      body: IndexedStack(index: _currentIndex, children: _pages),
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
