import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../services/notification_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';
import 'kos_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();

    _profileFuture = ProfileService().getMyProfile();

    // Inisialisasi Notification Service
    NotificationService.instance.init();
  }

  // =============================================================
  // LOGOUT
  // =============================================================
  Future<void> _logout() async {
    try {
      await AuthService.instance.logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout gagal: $error')));
    }
  }

  // =============================================================
  // BUILD
  // =============================================================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data;

        if (snapshot.hasError || profile == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat profil pengguna')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${profile.role})'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: _logout,
              ),
            ],
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),

              const Icon(Icons.account_circle, size: 80),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Selamat Datang!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 24),

              // Informasi nama pengguna
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama'),
                subtitle: Text(profile.name.isEmpty ? '-' : profile.name),
              ),

              // Informasi email
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(profile.email),
              ),

              // Informasi role
              ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('Role'),
                subtitle: Text(profile.role),
              ),

              const Divider(height: 32),

              // Menu Daftar Kos untuk semua role
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Daftar Kos'),
                subtitle: const Text('Lihat daftar kos yang tersedia'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KosListPage()),
                  );
                },
              ),

              // Menu My Kos khusus owner dan admin
              RoleGuard(
                role: profile.role,
                allowed: const ['owner', 'admin'],
                child: const ListTile(
                  leading: Icon(Icons.home_work),
                  title: Text('My Kos'),
                  subtitle: Text('Kelola daftar kos milik Anda'),
                ),
              ),

              // Menu Admin khusus admin
              RoleGuard(
                role: profile.role,
                allowed: const ['admin'],
                child: const ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Menu Admin'),
                  subtitle: Text('Fitur administrasi'),
                ),
              ),
            ],
          ),

          // Tombol tambah kos khusus owner dan admin
          floatingActionButton: RoleGuard(
            role: profile.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Tambah Kos akan dikembangkan.'),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
