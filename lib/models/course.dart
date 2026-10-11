// =============================================================
// Pertemuan 6 - Tahap 8
// Model Course
// Nama : Komang Rossi Adi Utama
// NIM  : 2415051106
// =============================================================

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Aktif';
      default:
        return 'Direncanakan';
    }
  }

  bool get isDone => status == 'done';
  bool get isActive => status == 'active';
}
