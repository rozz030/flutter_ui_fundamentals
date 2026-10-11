// =============================================================
// Pertemuan 6 - Tahap 12
// Widget WatchDemoCard (Tahap 7)
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_notifier.dart';

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
