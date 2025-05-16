import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final unescape = HtmlUnescape();
  BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.thumbnail.isNotEmpty)
              Center(child: Image.network(book.thumbnail, height: 200)),
            const SizedBox(height: 12),
            Text(
              unescape.convert(book.subtitleOrSnippet) ,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('by ${book.authors}'),
            const Divider(height: 24),
            Text('📚 Penerbit: ${book.publisher}'),
            Text('🕒 Terbit: ${book.publishedDate}'),
            Text('📄 Halaman: ${book.pageCount}'),
            Text('📐 Ukuran: ${book.dimensions}'),
            Text('🏷️ Kategori: ${book.categories.join(', ')}'),
            const SizedBox(height: 12),
            Html(
              data: book.description,
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  textAlign: TextAlign.justify,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
