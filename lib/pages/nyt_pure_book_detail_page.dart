// nyt_pure_book_detail_page.dart
import 'package:flutter/material.dart';

class NYTPureBookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const NYTPureBookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book['title'] ?? 'Detail Buku')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((book['book_image'] ?? '').isNotEmpty)
              Center(
                child: Image.network(
                  book['book_image'],
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              book['description'] ?? '(Tidak ada deskripsi)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('by ${book['author'] ?? 'Tidak diketahui'}'),
            const Divider(),
            const SizedBox(height: 8),
            _infoRow(Icons.menu_book, 'Penerbit: ${book['publisher'] ?? '-'}'),
            _infoRow(Icons.calendar_month, 'Terbit: ${book['published_date'] ?? '-'}'),
            _infoRow(Icons.star, 'Peringkat NYT: ${book['rank'] ?? '-'}'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
