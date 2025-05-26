
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literasime/pages/book_detail_page.dart';
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
      print('Error loading NYT data: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nytBooks.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Best Seller Pilihan NYT Minggu Ini",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: nytBooks.length,
            itemBuilder: (context, index) {
              final book = nytBooks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailPage(
                        isbn: book['primary_isbn13'],
                        source: "nyt",
                        rank: book['rank'],
                        title: book['title'],
                        imageUrl: book['book_image'],
                        author: book['author'],
                        description: book['description'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          book['book_image'],
                          width: 110,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Text(
                      //   "#${book['rank']} - ${book['title']}",
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: const TextStyle(fontWeight: FontWeight.w600),
                      // ),
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
