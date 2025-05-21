import 'package:flutter/material.dart';
import '../../pages/book_detail_page.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String authors;
  final String thumbnail;
  final String isbn;
  final bool showBadge;

  const BookCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.thumbnail,
    required this.isbn,
    this.showBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => BookDetailPage(isbn: isbn),
        ));
      },
      child: Stack(
        children: [
          Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(thumbnail),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          if (showBadge)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Update Minggu Ini',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            )
        ],
      ),
    );
  }
}
