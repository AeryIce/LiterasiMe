import 'package:flutter/material.dart';
import '../../models/hybrid_book_model.dart';
import 'book_card.dart';

class NytCarouselWidget extends StatelessWidget {
  final List<HybridBook> books;
  final String title;
  final bool showNYTBadge;

  const NytCarouselWidget({
    Key? key,
    required this.books,
    required this.title,
    this.showNYTBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('📭 Belum ada rekomendasi untuk saat ini'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                title: book.title,
                subtitle: book.subtitle,
                authors: book.authors,
                thumbnail: book.image,
                isbn: book.isbn,
                showBadge: showNYTBadge,
              );
            },
          ),
        ),
      ],
    );
  }
}
