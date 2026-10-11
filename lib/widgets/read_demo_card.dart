// =============================================================
// Pertemuan 6 - Tahap 12
// Widget ReadDemoCard (Tahap 7)
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_notifier.dart';

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
