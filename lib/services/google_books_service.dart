import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleBooksService {
  
  static final String _apiKey = dotenv.env['GOOGLE_BOOKS_API_KEY'] ?? '';

  static Future<Book?> fetchBookByISBN(String isbn) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('DATA API: $data'); // Debug

      if (data['totalItems'] > 0) {
        final json1 = data['items'][0];
        final selfLink = json1['selfLink'];

        // 🔁 Ambil data tambahan dari selfLink
        final volumeInfoDetail = await _fetchBookDetailsFromSelfLink(selfLink);

        // Gabungkan volumeInfo dari response awal + response detail
        json1['volumeInfo'] = {...?json1['volumeInfo'], ...volumeInfoDetail};

        return Book.fromJson(json1);
      }
    }

    return null;
  }

  static Future<List<Book>> fetchRecommendations(String genre) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=subject:$genre&maxResults=10&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    }
    return [];
  }

  // 🔍 Ambil volumeInfo tambahan dari selfLink
  static Future<Map<String, dynamic>> _fetchBookDetailsFromSelfLink(
    String selfLink,
  ) async {
    final response = await http.get(Uri.parse('$selfLink?key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['volumeInfo'] ?? {};
    } else {
      print('Gagal fetch selfLink: ${response.statusCode}');
      return {};
    }
  }

  static Future<List<Book>> fetchBooksByCategory(String category) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=subject:$category&maxResults=10&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0) {
        return (data['items'] as List)
            .map((item) => Book.fromJson(item))
            .where(
              (book) => book.thumbnail.isNotEmpty,
            ) // filter agar ada gambar
            .toList();
      }
    }

    return [];
  }
}
