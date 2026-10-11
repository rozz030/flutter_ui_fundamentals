// =============================================================
// Pertemuan 6 - Tahap 15
// Debug Panel Card - Demo 4 kasus debugging
// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

class DebugPanelCard extends StatelessWidget {
  const DebugPanelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, _) {
        return Card(
          color: Colors.pink.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Debug Panel - Tahap 15',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Panel untuk mensimulasikan bug state management.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // -------------------- KASUS A --------------------
                const Text(
                  'KASUS A: Lupa notifyListeners()',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'silentMode: ${provider.silentMode} '
                  '${provider.silentMode ? "(UI tidak akan update!)" : ""}',
                  style: TextStyle(
                    color: provider.silentMode ? Colors.red : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => provider.toggleSilentMode(),
                        icon: Icon(
                          provider.silentMode
                              ? Icons.volume_off
                              : Icons.volume_up,
                        ),
                        label: Text(
                          provider.silentMode
                              ? 'Matikan Silent'
                              : 'Aktifkan Silent',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => provider.loadCourses(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reload'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Aktifkan silent, lalu klik Reload. '
                  'Loading tidak muncul karena notifier diam.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const Divider(height: 32),

                // -------------------- KASUS B --------------------
                const Text(
                  'KASUS B: Context di atas Provider',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lihat catatan di worksheet. '
                  'Error muncul jika context dipanggil sebelum '
                  'ChangeNotifierProvider terpasang.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const Divider(height: 32),

                // -------------------- KASUS C --------------------
                const Text(
                  'KASUS C: Error pada Service',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => provider.simulateError(),
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    icon: const Icon(Icons.error_outline),
                    label: const Text('Simulasi Error'),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'error state saat ini: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  provider.error ?? 'tidak ada',
                  style: TextStyle(
                    fontSize: 12,
                    color: provider.error != null ? Colors.red : Colors.grey,
                  ),
                ),

                const Divider(height: 32),

                // -------------------- KASUS D --------------------
                const Text(
                  'KASUS D: Perubahan setelah async',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Contoh pola mounted check ditampilkan '
                  'di bagian catatan worksheet.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
