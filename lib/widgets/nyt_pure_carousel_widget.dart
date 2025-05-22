
// NYT Carousel dengan style Riwayat Pencarian
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../pages/nyt_pure_book_detail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NYTPureCarouselWidget extends StatefulWidget {
  const NYTPureCarouselWidget({super.key});

  @override
  State<NYTPureCarouselWidget> createState() => _NYTPureCarouselWidgetState();
}

class _NYTPureCarouselWidgetState extends State<NYTPureCarouselWidget> {
  List<dynamic> nytBooks = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchNYTBooks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchNYTBooks() async {
    final apiKey = dotenv.env['NYT_API_KEY'];
    const list = 'paperback-nonfiction';
    final url =
        'https://api.nytimes.com/svc/books/v3/lists/current/$list.json?api-key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      setState(() {
        nytBooks = data['results']['books'] ?? [];
      });
    } catch (e) {
      print('Error loading NYT data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nytBooks.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Best Seller Pilihan NYT Minggu Ini 🔥',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: nytBooks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = nytBooks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NYTPureBookDetailPage(book: book),
                    ),
                  );
                },
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.brown.shade100,
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(121, 85, 72, 0.15),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      book['book_image'] != null && book['book_image'] != ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                book['book_image'],
                                height: 80,
                              ),
                            )
                          : Icon(
                              Icons.book,
                              size: 60,
                              color: Colors.brown,
                            ),
                      const SizedBox(height: 6),
                      Text(
                        book['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
