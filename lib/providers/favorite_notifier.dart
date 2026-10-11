// =============================================================
// Pertemuan 6 - Tahap 12
// ChangeNotifier untuk state favorit
// =============================================================

import 'package:flutter/foundation.dart';

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
