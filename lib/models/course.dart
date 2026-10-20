// =============================================================
// Pertemuan 7 - Tahap 2
// Model Course - REST API
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
      code: 'COURSE-${json['id']}',
      title: json['title'] as String,
      credits: (json['userId'] as num).toInt(),
      status: 'active',
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
