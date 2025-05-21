// nyt_pure_carousel_widget.dart (refined for UI alignment)
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
  int _currentPage = 0;
  late PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
    fetchNYTBooks();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients && nytBooks.isNotEmpty) {
        int nextPage = (_currentPage + 1) % nytBooks.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchNYTBooks() async {
    final apiKey = dotenv.env['NYT_API_KEY'];
    //const apiKey = 'API_KEY_MU';
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            "🔥 Best Seller Pilihan NYT Minggu Ini",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 115,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: nytBooks.length,
            itemBuilder: (context, index) {
              final book = nytBooks[index];
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NYTPureBookDetailPage(book: book),
                      ),
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            book['book_image'] ?? '',
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                book['title'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book['author'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
