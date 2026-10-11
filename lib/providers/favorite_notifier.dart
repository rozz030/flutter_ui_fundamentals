// =============================================================
// Pertemuan 6 - Tahap 13
// Shared Favorites di Beberapa Screen
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

import 'package:flutter/foundation.dart';

class FavoriteNotifier extends ChangeNotifier {
  // Set berisi kode course yang difavoritkan.
  final Set<String> _favorites = {};
  int _toggleCount = 0;

  Set<String> get favorites => Set.unmodifiable(_favorites);
  int get count => _favorites.length;
  int get toggleCount => _toggleCount;

  bool isFavorite(String code) => _favorites.contains(code);

  void toggle(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    _toggleCount++;
    notifyListeners();
  }

  void reset() {
    _favorites.clear();
    _toggleCount = 0;
    notifyListeners();
  }
}
