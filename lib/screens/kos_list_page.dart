import 'package:flutter/material.dart';

import '../services/kos_service.dart';

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  late Future<List<Map<String, dynamic>>> _kosFuture;

  bool _isTestingInsert = false;
  bool _isTestingOtherInsert = false;
  String? _testingUpdateId;
  String? _testingDeleteId;

  @override
  void initState() {
    super.initState();
    _kosFuture = KosService().getKosList();
  }

  void _refreshData() {
    setState(() {
      _kosFuture = KosService().getKosList();
    });
  }

  Future<void> _testInsert() async {
    setState(() => _isTestingInsert = true);

    try {
      await KosService().testInsertKos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('INSERT berhasil dilakukan!'),
          backgroundColor: Colors.green,
        ),
      );

      _refreshData();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('INSERT ditolak oleh Supabase RLS: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isTestingInsert = false);
      }
    }
  }

  // Menguji INSERT menggunakan owner_id milik User A
  Future<void> _testInsertAsOtherUser() async {
    setState(() => _isTestingOtherInsert = true);

    try {
      await KosService().testInsertAsOtherUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GAGAL: INSERT atas nama User A berhasil dilakukan!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );

      _refreshData();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PASS: INSERT ditolak oleh RLS. $error'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isTestingOtherInsert = false);
      }
    }
  }

  Future<void> _testUpdate(String kosId) async {
    setState(() => _testingUpdateId = kosId);

    try {
      await KosService().testUpdateKos(kosId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UPDATE berhasil dilakukan!'),
          backgroundColor: Colors.green,
        ),
      );

      _refreshData();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('UPDATE ditolak oleh Supabase RLS: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _testingUpdateId = null);
      }
    }
  }

  Future<void> _testDelete(String kosId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi DELETE'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus data kos pengujian ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _testingDeleteId = kosId);

    try {
      await KosService().testDeleteKos(kosId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DELETE berhasil dilakukan!'),
          backgroundColor: Colors.green,
        ),
      );

      _refreshData();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('DELETE ditolak oleh Supabase RLS: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _testingDeleteId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTesting =
        _isTestingInsert ||
        _isTestingOtherInsert ||
        _testingUpdateId != null ||
        _testingDeleteId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kos'),
        actions: [
          IconButton(
            onPressed: isTesting ? null : _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isTesting ? null : _testInsert,
                icon: const Icon(Icons.security),
                label: Text(
                  _isTestingInsert ? 'Sedang Menguji...' : 'Uji INSERT RLS',
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isTesting ? null : _testInsertAsOtherUser,
                icon: const Icon(Icons.person_off),
                label: Text(
                  _isTestingOtherInsert
                      ? 'Sedang Menguji...'
                      : 'Uji INSERT Atas Nama User A',
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _kosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal mengambil data kos:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final kosList = snapshot.data ?? [];

                if (kosList.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data kos tersedia.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kosList.length,
                  itemBuilder: (context, index) {
                    final kos = kosList[index];
                    final kosId = kos['id'].toString();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                child: Icon(Icons.home_work),
                              ),
                              title: Text(kos['name'].toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(kos['address'].toString()),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${kos['price']} / bulan',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: isTesting
                                    ? null
                                    : () => _testUpdate(kosId),
                                icon: const Icon(Icons.edit),
                                label: Text(
                                  _testingUpdateId == kosId
                                      ? 'Sedang Menguji...'
                                      : 'Uji UPDATE RLS',
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: isTesting
                                    ? null
                                    : () => _testDelete(kosId),
                                icon: const Icon(Icons.delete_outline),
                                label: Text(
                                  _testingDeleteId == kosId
                                      ? 'Sedang Menguji...'
                                      : 'Uji DELETE RLS',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
