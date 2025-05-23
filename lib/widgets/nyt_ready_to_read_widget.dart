import 'package:flutter/material.dart';
import '../../models/nyt_ready_to_read_model.dart';
import '../../services/nyt_ready_to_read_service.dart';
import '../../widgets/book_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NYTReadyToReadWidget extends StatefulWidget {
  const NYTReadyToReadWidget({super.key});

  @override
  State<NYTReadyToReadWidget> createState() => _NYTReadyToReadWidgetState();
}

class _NYTReadyToReadWidgetState extends State<NYTReadyToReadWidget> {
  List<NYTReadyBook> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('user_meta').doc(uid).get();
    final genres = List<String>.from(doc['preferred_genres'] ?? []);

    final fetchedBooks = await NYTReadyToReadService.fetchBooksForUserGenres(
      genres,
    );
    setState(() {
      books = fetchedBooks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔄 Sedang menyiapkan rekomendasi terbaik untukmu...",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(),
          ],
        ),
      );
    }

    if (books.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🙏 Maaf, kami belum menemukan rekomendasi yang cocok untukmu saat ini.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Coba perbarui preferensi genremu di halaman profil, ya!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Cocok Buatmu 🌟",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                title: book.title,
                subtitle: book.subtitle,
                authors: book.authors,
                thumbnail: book.thumbnail,
                isbn: book.isbn,
                showBadge: book.rank == 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
