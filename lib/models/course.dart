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
    // Mendukung data Course maupun data dari JSONPlaceholder /posts.
    if (json.containsKey('code')) {
      return Course(
        code: json['code'] as String,
        title: json['title'] as String,
        credits: json['credits'] as int,
        status: json['status'] as String,
      );
    }

    // Mapping response JSONPlaceholder menjadi Course.
    final int id = json['id'] as int;

    return Course(
      code: 'COURSE-$id',
      title: json['title'] as String,
      credits: 3,
      status: 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'title': title, 'credits': credits, 'status': status};
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
