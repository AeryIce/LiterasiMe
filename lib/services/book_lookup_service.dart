import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book_history_model.dart';
import '../services/google_books_service.dart';
import '../utils/tagging_helper.dart';

Future<void> handleScanResult(BuildContext context, String isbn) async {
  if (isbn.isEmpty) return;

  final box = Hive.box<BookHistory>('book_history');
  final existing = box.get(isbn);

  if (existing != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buku sudah ada di riwayat 📚')),
    );
    return;
  }

  Future<void> saveBookToFirestore(BookHistory book) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("❌ UID kosong, user belum login.");
      return;
    }

    print("📌 UID saat ini: $uid");
    print("📘 Menyimpan buku: ${book.title}");

    final userHistoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('book_history')
        .doc(book.isbn);

    try {
      await userHistoryRef.set({
        'isbn': book.isbn,
        'title': book.title,
        'subtitle': book.subtitle ?? '',
        'authors': book.authors ?? [],
        'publisher': book.publisher ?? '',
        'publishedDate': book.publishedDate ?? '',
        'pageCount': book.pageCount ?? 0,
        'dimensions': book.dimensions ?? '',
        'categories': book.categories ?? [],
        'thumbnail': book.thumbnail ?? '',
        'scanCount': book.scanCount,
        'utm_links': book.utmLinks ?? {},
        'linkYoutube': book.linkYoutube ?? '',
        'keywords': book.keywords ?? [],
        'vector': book.vector ?? [],
        'tags': book.tags ?? [],
        'created_at': FieldValue.serverTimestamp(),
      });

      print("✅ Buku '${book.title}' berhasil disimpan ke Firestore.");
    } catch (e) {
      print("❌ ERROR saat simpan buku ke Firestore: $e");
    }
  }

  final result = await GoogleBooksService.fetchBookByISBN(isbn);
  if (result != null) {
    final tags = generateTagsFromBook(
      title: result.title,
      authors:
          result.authors is Iterable
              ? List<String>.from(result.authors as Iterable)
              : [result.authors.toString()],
      categories: result.categories,
      publisher: result.publisher,
      description: result.title,
    );

    final book = BookHistory(
      isbn: isbn,
      title: result.title,
      subtitle: '',
      authors:
          result.authors is Iterable
              ? List<String>.from(result.authors as Iterable)
              : [result.authors.toString()],
      publisher: result.publisher,
      publishedDate: result.publishedDate,
      pageCount: result.pageCount,
      dimensions: result.dimensions,
      categories: result.categories,
      thumbnail: result.thumbnail,
      scanCount: 1,
      utmLinks: {
        'periplus': 'https://periplus.com/p/$isbn?utm_source=literasime',
      },
      linkYoutube: '',
      keywords:
          result.title.trim().isEmpty ? [] : result.title.trim().split(' '),
      vector: [],
      tags: tags,
    );

    await box.put(isbn, book);
    await saveBookToFirestore(book);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buku berhasil disimpan dari Google Books ✅'),
      ),
    );
  }
}
