// =============================================================
// Pertemuan 6 - Tahap 13
// Widget CourseCard
// =============================================================

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../screens/course_detail_page.dart';

Widget buildCourseCard(
  BuildContext context,
  Course course, {
  required bool isFavorite,
  required VoidCallback onFavoriteChanged,
}) {
  final IconData statusIcon = course.isDone
      ? Icons.check_circle
      : course.isActive
      ? Icons.play_circle
      : Icons.schedule;

  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(statusIcon),
      title: Text(
        course.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${course.code} • ${course.credits} SKS'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Toggle Favorit',
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteChanged,
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
    ),
  );
}
