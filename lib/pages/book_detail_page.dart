
import 'package:flutter/material.dart';
import '../models/hybrid_book_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

class BookDetailPage extends StatelessWidget {
  final String isbn;
  final unescape = HtmlUnescape();

  BookDetailPage({super.key, required this.isbn});

  // Simulasi fetch HybridBook
  HybridBook getBookByISBN(String isbn) {
    return HybridBook(
      rank: 1,
      isbn: isbn,
      title: 'Judul Buku Simulasi',
      subtitle: 'Subjudul atau kutipan singkat dari buku',
      image: 'https://via.placeholder.com/150',
      authors: 'Penulis Simulasi',
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = getBookByISBN(isbn);

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.image.isNotEmpty)
              Center(child: Image.network(book.image, height: 200)),
            const SizedBox(height: 12),
            Text(
              unescape.convert(book.subtitle),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('by ${book.authors}'),
            const Divider(),
            const SizedBox(height: 8),
            _infoRow(Icons.menu_book, 'Penerbit: Simulasi Publisher'),
            _infoRow(Icons.access_time, 'Terbit: 2025'),
            _infoRow(Icons.description, 'Halaman: 300'),
            _infoRow(Icons.straighten, 'Ukuran: 14 x 21 cm'),
            _infoRow(Icons.label, 'Kategori: Fiksi, Drama'),
            const SizedBox(height: 12),
            const Text(
              'Deskripsi Buku:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Html(data: "<p>Ini adalah <b>deskripsi dummy</b> dari buku. Di versi nyata, ini bisa diambil dari Google Books API berdasarkan ISBN.</p>"),
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
          const SizedBox(width: 6),
          Flexible(child: Text(text, style: TextStyle(color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
