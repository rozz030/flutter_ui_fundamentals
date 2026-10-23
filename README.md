# Course Explorer v2

Aplikasi Flutter hasil praktikum Pertemuan 7 — State Management & Mobile Application Architecture.

**Nama:** Komang Rossi Adi Utama  
**NIM:** 2415051106  
**Kelas:** PTI 5A

---

## Deskripsi Aplikasi

**Course Explorer v2** merupakan aplikasi Flutter untuk mengelola data mata kuliah. Aplikasi dikembangkan secara bertahap dengan menerapkan konsep **State Management**, **layered architecture**, dan integrasi **Supabase sebagai backend database**.

Aplikasi menyediakan fitur untuk:

- Menampilkan daftar mata kuliah.
- Menambahkan mata kuliah.
- Mengubah data mata kuliah.
- Menghapus data mata kuliah.
- Menampilkan status mata kuliah.
- Mengelola data favorit.
- Menangani kondisi error dan kegagalan request.
- Menerapkan RLS sebagai lapisan keamanan pada database Supabase.

---

## Arsitektur Aplikasi

Aplikasi menggunakan pendekatan **layered architecture** dengan alur:

**UI → Provider → Repository → Service → Supabase**

Setiap layer memiliki tanggung jawab yang berbeda.

**Aturan penting:** layer atas boleh memanggil layer di bawahnya, tetapi tidak sebaliknya. UI tidak menangani detail komunikasi langsung dengan database.

### Alur Data

1. **UI / Screen** menampilkan data dan menerima interaksi pengguna.
2. **CourseProvider** mengelola state aplikasi menggunakan `ChangeNotifier`.
3. **CourseRepository** menjadi abstraksi antara Provider dan sumber data.
4. **CourseSupabaseService** menangani komunikasi dengan Supabase.
5. **Supabase Database** menyimpan data `courses`.

---

## Struktur Folder & Tanggung Jawab

| Folder/File | Tanggung Jawab |
|---|---|
| `lib/models/` | Struktur data dan proses parsing model `Course`. |
| `lib/services/` | Menangani komunikasi dengan sumber data, termasuk Supabase. |
| `lib/repositories/` | Abstraksi sumber data untuk Provider. |
| `lib/providers/` | Mengelola state dan logic aplikasi menggunakan `ChangeNotifier`. |
| `lib/screens/` | Berisi halaman aplikasi dan tampilan utama. |
| `lib/widgets/` | Komponen UI yang dapat digunakan kembali. |
| `lib/config/` | Menyimpan konfigurasi koneksi Supabase yang digunakan aplikasi. |
| `lib/main.dart` | Root aplikasi, inisialisasi Supabase, `MultiProvider`, dan `MaterialApp`. |

---

## Backend dan Database

Aplikasi menggunakan **Supabase** sebagai backend database.

Database memiliki tabel:

`courses`

dengan kolom:

- `id`
- `code`
- `title`
- `credits`
- `status`
- `created_at`

Data course disimpan secara persisten pada database Supabase.

RLS (**Row Level Security**) digunakan sebagai lapisan keamanan backend untuk mengatur izin operasi terhadap tabel.

---

## Fitur CRUD

### SELECT

Aplikasi mengambil data course dari tabel `courses` pada Supabase dan menampilkannya pada halaman Courses.

### INSERT

Pengguna dapat menambahkan course baru melalui form **Create Course**.

Data dikirim melalui alur:

**CreateCoursePage → CourseProvider → CourseRepository → CourseSupabaseService → Supabase**

### UPDATE

Pengguna dapat mengubah data course melalui halaman **Edit Course**.

Update dilakukan berdasarkan **ID course** yang tersimpan pada database.

### DELETE

Pengguna dapat menghapus course melalui tombol **Delete**.

Sebelum penghapusan dilakukan, aplikasi menampilkan **dialog konfirmasi**.

Penghapusan dilakukan berdasarkan ID dan setelah berhasil data pada aplikasi diperbarui.

---

## State Management

State aplikasi dikelola menggunakan **Provider**.

`CourseProvider` bertanggung jawab terhadap:

- daftar course;
- status loading;
- status penyimpanan;
- error handling;
- proses mengambil data;
- proses menambahkan data;
- proses mengubah data;
- proses menghapus data.

`FavoriteNotifier` digunakan untuk mengelola data course favorit.

---

## Error Handling

Aplikasi memiliki penanganan error untuk mencegah aplikasi mengalami crash ketika terjadi kegagalan request.

Pengujian dilakukan terhadap beberapa kondisi:

- HTTP 404 / endpoint tidak valid.
- Tidak ada koneksi internet.
- Kesalahan mapping JSON.
- RLS / permission Supabase.
- Data tidak valid atau melanggar constraint.

Pada kondisi error, aplikasi menampilkan informasi kesalahan kepada pengguna dan menyediakan mekanisme **retry** pada halaman yang relevan.

---

## Security Checklist

- [x] Tidak menggunakan `service_role` key pada source code aplikasi.
- [x] Tidak menyimpan password atau token pribadi pada repository.
- [x] File `.env` yang berisi secret tidak di-commit.
- [x] Data sensitif tidak ditampilkan pada screenshot.
- [x] RLS/policy dipahami sebagai lapisan keamanan backend.
- [x] Validasi UI tidak dianggap sebagai pengganti validasi dan authorization backend.

---

## Cara Menjalankan Aplikasi

Pastikan Flutter dan environment development sudah terpasang.

Clone repository:

```bash
git clone https://github.com/rozz030/flutter_ui_fundamentals.git
```

Masuk ke folder project:

```bash
cd flutter_ui_fundamentals
```

Install dependencies:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Pastikan konfigurasi Supabase pada project sudah tersedia sebelum menjalankan aplikasi.

---

## Git Checkpoint

Pengembangan aplikasi dilakukan secara bertahap dan setiap tahap penting dicatat menggunakan Git.

Checkpoint mencakup proses:

- konfigurasi Supabase;
- pembacaan data;
- INSERT;
- UPDATE;
- DELETE;
- error handling;
- security hardening;
- finalisasi repository.

Repository telah di-push ke GitHub dan digunakan sebagai tempat pengumpulan source code praktikum.

---

## Repository

**GitHub Repository:**

https://github.com/rozz030/flutter_ui_fundamentals.git

---

## Kesimpulan

Course Explorer v2 telah dikembangkan menjadi aplikasi **Course Data Manager CRUD** yang terintegrasi dengan Supabase.

Aplikasi menerapkan pemisahan tanggung jawab melalui arsitektur:

**Service → Repository → Provider → UI**

serta mendukung operasi:

**SELECT → INSERT → UPDATE → DELETE**

Data dapat diverifikasi melalui aplikasi Flutter maupun tabel `courses` pada Supabase.