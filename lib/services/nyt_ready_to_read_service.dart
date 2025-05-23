import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:literasime/utils/nyt_to_profile_mapping.dart';
import '../models/nyt_ready_to_read_model.dart';
//import '../utils/book_category_to_nyt.dart'; // asumsi smartMapGenreToNYT ada di sini

class NYTReadyToReadService {
  static Future<List<NYTReadyBook>> fetchBooksForUserGenres(
    List<String> genres,
  ) async {
    List<NYTReadyBook> allBooks = [];

    for (final genre in genres) {
      final listName = mapProfileToNYT(genre);
      //if (listName == null) continue;

      final nytBooks = await _fetchNYTBooks(listName);
      for (final book in nytBooks.take(5)) {
        final enriched = await _enrichWithGoogle(book);
        if (enriched != null) {
          allBooks.add(enriched);
        }
      }
    }

    return allBooks.take(15).toList(); // Max total: 15 books
  }

  static Future<List<dynamic>> _fetchNYTBooks(String listName) async {
    final apiKey = dotenv.env['NYT_API_KEY'];
    final url =
        'https://api.nytimes.com/svc/books/v3/lists/current/$listName.json?api-key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        print('⚠️ NYT API returned \${response.statusCode}: \${response.body}');
        return [];
      }

      final data = json.decode(response.body);
      if (data == null ||
          data['results'] == null ||
          data['results']['books'] == null) {
        print('📛 NYT response kosong atau rusak: \$data');
        return [];
      }

      return data['results']['books'] ?? [];
    } catch (e) {
      print('❌ Error fetching NYT data: \$e');
      return [];
    }
  }

  static Future<NYTReadyBook?> _enrichWithGoogle(dynamic nytBook) async {
    final isbn = nytBook['primary_isbn13'];
    final googleUrl =
        'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';

    try {
      final response = await http.get(Uri.parse(googleUrl));
      final data = json.decode(response.body);

      final items = data['items'];
      final volumeInfo =
          items != null && items.isNotEmpty ? items[0]['volumeInfo'] : null;

      return NYTReadyBook(
        title: volumeInfo?['title'] ?? nytBook['title'],
        subtitle: volumeInfo?['subtitle'] ?? nytBook['description'] ?? '',
        authors: volumeInfo?['authors']?.join(', ') ?? '',
        thumbnail:
            volumeInfo?['imageLinks']?['thumbnail'] ??
            nytBook['book_image'] ??
            '',
        isbn: isbn,
        rank: nytBook['rank'] ?? 0,
      );
    } catch (e) {
      print('⚠️ Fallback NYT only: $e');
      return NYTReadyBook(
        title: nytBook['title'],
        subtitle: nytBook['description'] ?? '',
        authors: '',
        thumbnail: nytBook['book_image'] ?? '',
        isbn: nytBook['primary_isbn13'],
        rank: nytBook['rank'] ?? 0,
      );
    }
  }
}
