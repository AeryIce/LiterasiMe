import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_history_model.dart';

class FirestoreBooksService {
  static Future<List<BookHistory>> fetchBooksByTag(String tag) async {
    final query = await FirebaseFirestore.instance
        .collection('books')
        .where('tags', arrayContains: tag)
        .orderBy('count', descending: true)
        .limit(20)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return BookHistory(
        isbn: doc.id,
        title: data['title'] ?? '',
        subtitle: data['subtitle'],
        authors: List<String>.from(data['authors'] ?? []),
        publisher: data['publisher'],
        publishedDate: data['publishedDate'],
        pageCount: data['pageCount'],
        dimensions: data['dimensions'],
        categories: List<String>.from(data['categories'] ?? []),
        thumbnail: data['thumbnail'],
        scanCount: data['count'] ?? 1,
        utmLinks: Map<String, String>.from(data['utm_links'] ?? {}),
        linkYoutube: data['linkYoutube'],
        vector: (data['vector'] as List?)?.map((e) => double.tryParse(e.toString()) ?? 0.0).toList(),
        keywords: List<String>.from(data['keywords'] ?? []),
      );
    }).toList();
  }
}
