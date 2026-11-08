import 'package:supabase_flutter/supabase_flutter.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil daftar kos
  Future<List<Map<String, dynamic>>> getKosList() async {
    final data = await _client
        .from('kos')
        .select('id, name, address, price, owner_id')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // Menguji INSERT berdasarkan hak akses pengguna
  Future<void> testInsertKos() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    await _client.from('kos').insert({
      'owner_id': user.id,
      'name': 'Kos Pengujian RLS',
      'address': 'Singaraja, Bali',
      'price': 500000,
    });
  }

  // Menguji UPDATE berdasarkan kepemilikan data
  Future<void> testUpdateKos(String kosId) async {
    final updatedRows = await _client
        .from('kos')
        .update({'name': 'Kos Pengujian UPDATE', 'price': 600000})
        .eq('id', kosId)
        .select();

    if (updatedRows.isEmpty) {
      throw Exception('UPDATE ditolak RLS atau data tidak ditemukan.');
    }
  }

  // Menguji DELETE berdasarkan kepemilikan data
  Future<void> testDeleteKos(String kosId) async {
    final deletedRows = await _client
        .from('kos')
        .delete()
        .eq('id', kosId)
        .select();

    if (deletedRows.isEmpty) {
      throw Exception('DELETE ditolak RLS atau data tidak ditemukan.');
    }
  }

  // Menguji INSERT atas nama pengguna lain
  Future<void> testInsertAsOtherUser() async {
    await _client.from('kos').insert({
      'owner_id': '0fd4ed6e-f2df-451a-941c-4a1812a23389',
      'name': 'Kos Palsu User B',
      'address': 'Singaraja, Bali',
      'price': 400000,
    });
  }
}
