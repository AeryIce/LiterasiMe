import 'package:flutter/material.dart';
import 'package:literasime/models/hybrid_book_model.dart';
//import '../models/nyt_book_model.dart';

class NYTProfileCarousel extends StatelessWidget {
  final List<HybridBook> books;

  const NYTProfileCarousel({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
          child: Text(
            '📚 Rekomendasi Mingguan untuk Kamu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Container(
                width: 110,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '#${book.rank}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
