import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nyt_book_model.dart';
import '../models/hybrid_book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/book_category_to_nyt.dart';

class NYTBooksService {
  static String get _apiKey => dotenv.env['NYT_API_KEY'] ?? '';

  // Fetch NYT books and enrich with Google Books metadata
  static Future<List<HybridBook>> fetchHybridBooks({
    String listName = 'paperback-nonfiction',
    String date = 'current',
  }) async {
    final nytUrl = Uri.parse(
      'https://api.nytimes.com/svc/books/v3/lists/$date/$listName.json?api-key=$_apiKey',
    );

    try {
      final nytResponse = await http.get(nytUrl);
      if (nytResponse.statusCode != 200)
        throw Exception('Failed to load NYT data');
      final nytData = json.decode(nytResponse.body);
      final List<dynamic> booksJson = nytData['results']['books'];

      List<HybridBook> hybridBooks = [];

      for (var bookJson in booksJson) {
        final nytBook = NYTBook.fromJson(bookJson);
        final googleBook = await _fetchGoogleBookByISBN(nytBook.primaryIsbn13);

        if (googleBook != null) {
          hybridBooks.add(
            HybridBook(
              authors: googleBook['authors']?.join(', ') ?? 'Tanpa Penulis',
              rank: nytBook.rank,
              isbn: nytBook.primaryIsbn13,
              title: googleBook['title'] ?? '',
              subtitle: googleBook['subtitle'] ?? '',
              image: googleBook['thumbnail'] ?? '',
            ),
          );
        }
      }

      return hybridBooks;
    } catch (e) {
      print('Error in fetchHybridBooks: \$e');
      return [];
    }
  }

  // Fetch metadata from Google Books using ISBN
  static Future<Map<String, dynamic>?> _fetchGoogleBookByISBN(
    String isbn,
  ) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:\$isbn',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final volume = data['items'][0]['volumeInfo'];
          return {
            'title': volume['title'] ?? '',
            'subtitle': volume['subtitle'] ?? '',
            'thumbnail': volume['imageLinks']?['thumbnail'] ?? '',
          };
        }
      }
    } catch (e) {
      print('Error fetching from Google Books: \$e');
    }

    return null;
  }

  // Fetch multiple genres and combine results (deduplicated)
  static Future<List<HybridBook>> fetchCombinedHybridBooks(
    List<String> genres,
  ) async {
    final Set<String> seenIsbns = {};
    final List<HybridBook> combinedBooks = [];

    for (String genre in genres) {
      final listName = smartMapGenreToNYT(genre);
      // uses mapping + fallback
      final books = await fetchHybridBooks(listName: listName!);

      for (var book in books) {
        if (!seenIsbns.contains(book.isbn)) {
          seenIsbns.add(book.isbn);
          combinedBooks.add(book);
        }
      }
    }

    return combinedBooks;
  }
}
