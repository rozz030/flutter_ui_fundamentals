# Course Explorer v2

Aplikasi Flutter hasil praktikum Pertemuan 6 — State Management & Mobile Application Architecture.

**Nama:** Komang Rossi Adi Utama  
**NIM:** 2415051106  
**Kelas:** PTI 5A

---

## Arsitektur Aplikasi

Arah dependency (dari luar ke dalam):

**Aturan penting:** Layer atas boleh memanggil layer di bawahnya, tapi **tidak sebaliknya**. UI tidak boleh tahu apakah data berasal dari JSON, REST API, atau database.

---

## Struktur Folder & Tanggung Jawab

| Folder | Tanggung Jawab |
|---|---|
| `lib/models/` | Struktur data (class `Course`). Parsing JSON (`Course.fromJson`). |
| `lib/services/` | Ambil data mentah dari sumber (JSON asset, API, DB). Titik masuk `rootBundle` dan `jsonDecode`. |
| `lib/repositories/` | Abstraksi sumber data untuk Provider. Menyembunyikan detail Service. |
| `lib/providers/` | State + logic UI (`ChangeNotifier`). Panggil `notifyListeners()`. **Tidak boleh** berisi widget atau `BuildContext`. |
| `lib/screens/` | Halaman aplikasi (`DashboardPage`, `CoursesPage`, `FavoritesPage`, `CourseDetailPage`, `MainShell`). |
| `lib/widgets/` | Komponen UI yang bisa dipakai ulang (`CourseCard`, `SummaryCard`, `DebugPanelCard`, dll). |
| `lib/constants.dart` | Konstanta identitas (Nama, NIM). |
| `lib/main.dart` | Root app. Setup `MultiProvider`, `MaterialApp`, dan `home: MainShell()`. |

---

## Alur Data Courses

1. `DashboardPage` memanggil `CourseProvider.loadCourses()` via `context.read`.
2. `CourseProvider` memanggil `CourseRepository.getCourses()`.
3. `CourseRepository` memanggil `CourseService.loadCourses()`.
4. `CourseService` membaca JSON asset dan mem-parse tiap item menjadi `Course`.
5. Hasil dikembalikan ke Provider, yang memanggil `notifyListeners()`.
6. UI yang `Consumer<CourseProvider>` rebuild dengan data terbaru.

---

## Alur Data Favorites

1. `FavoriteNotifier` menyimpan `Set<String>` kode course favorit — sebagai **single source of truth**.
2. Dashboard, Courses, Favorites, dan Detail membaca dari notifier yang sama.
3. Toggle di mana pun langsung konsisten di seluruh screen.

---

## Audit Hasil

- [x] UI tidak memanggil `rootBundle` / `jsonDecode` langsung.
- [x] `CourseService` hanya berisi logika data, tanpa widget/UI.
- [x] `CourseProvider` dan `FavoriteNotifier` tidak menyimpan `BuildContext`.
- [x] Arah dependency: Screen → Provider → Repository → Service → JSON.
- [x] Folder dipisah berdasarkan tanggung jawab.
- [x] Nama dan NIM tampil di UI dan di setiap file.