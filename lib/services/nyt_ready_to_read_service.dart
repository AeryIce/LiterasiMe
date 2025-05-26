
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:literasime/utils/nyt_to_profile_mapping.dart';
import '../models/nyt_ready_to_read_model.dart';
//import '../utils/book_category_to_nyt.dart'; // asumsi smartMapGenreToNYT ada di sini
import 'package:hive/hive.dart';


class NYTReadyToReadService {
  static Future<List<NYTReadyBook>> fetchBooksForUserGenres(
    List<String> genres,
  ) async {
    final cacheKey = 'nyt_\${genres.join("_")}';
    await Hive.deleteBoxFromDisk('nyt_ready_cache');
  final box = await Hive.openBox<List>('nyt_ready_cache');

    // 1. Tampilkan dari cache dulu kalau ada
    final cached = box.get(cacheKey);
    if (cached != null && cached is List<NYTReadyBook> && cached.isNotEmpty) {
      _updateCacheInBackground(genres, cacheKey, box);
      return cached.cast<NYTReadyBook>();
    }

    // 2. Kalau tidak ada cache → fetch seperti biasa
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

    final limited = allBooks.take(15).toList();
    await box.put(cacheKey, limited.map((b) => b.toJson()).toList());
    return limited;
  }

  static Future<void> _updateCacheInBackground(
      List<String> genres, String cacheKey, Box box) async {
    try {
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

      final limited = allBooks.take(15).toList();
      await box.put(cacheKey, limited.map((b) => b.toJson()).toList());
    } catch (_) {
      // Silent fail
    }
  }

  static Future<List<NYTReadyBook>> _fetchNYTBooks(String listName) async {
    final apiKey = dotenv.env['NYT_API_KEY'];
    final url = Uri.parse("https://api.nytimes.com/svc/books/v3/lists/current/$listName.json?api-key=$apiKey");


    final response = await http.get(url);

    print('Fetching NYT: $url');
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final books = result['results']['books'] as List;

      return books.map((json) => NYTReadyBook.fromNYT(json)).toList();
    } else {
      print('NYT API FAILED - CODE: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    return [];
    }
  }

  static Future<NYTReadyBook?> _enrichWithGoogle(NYTReadyBook book) async {
    try {
      final isbn = book.isbn;
      final url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';

      final response = await http.get(Uri.parse(url));
      print('Fetching NYT: $url');
    if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final items = result['items'] as List?;
        if (items != null && items.isNotEmpty) {
          return book.enrichWithGoogleData(items.first['volumeInfo']);
        }
      }
    } catch (_) {
      // Ignore error and return null
    }
    return null;
  }
}
