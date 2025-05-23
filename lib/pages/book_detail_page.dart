
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/google_books_service.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDetailPage extends StatefulWidget {
  final String isbn;

  const BookDetailPage({super.key, required this.isbn});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final unescape = HtmlUnescape();
  late Future<Book?> bookFuture;

  @override
  void initState() {
    super.initState();
    bookFuture = GoogleBooksService.fetchBookByISBN(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Buku")),
      body: FutureBuilder<Book?>(
        future: bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Gagal memuat detail buku."));
          }

          final book = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.thumbnail.isNotEmpty)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(book.thumbnail, height: 200),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  book.title,
                  style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  unescape.convert(book.subtitleOrSnippet),
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  color: Colors.blueGrey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(Icons.person, 'Penulis: ${book.authors}'),
                        _infoRow(Icons.business, 'Penerbit: ${book.publisher}'),
                        _infoRow(Icons.date_range, 'Terbit: ${book.publishedDate}'),
                        _infoRow(Icons.pages, 'Jumlah halaman: ${book.pageCount}'),
                        _infoRow(Icons.straighten, 'Ukuran buku: ${book.dimensions}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (book.categories.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Kategori:",
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: book.categories
                        .map((cat) => Chip(
                              label: Text(cat),
                              backgroundColor: Colors.indigo.shade50,
                              labelStyle: GoogleFonts.nunito(),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Deskripsi:",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                ),
                Html(data: unescape.convert(book.description)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo[400]),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.nunito())),
        ],
      ),
    );
  }
}
