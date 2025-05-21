import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nyt_book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NYTBooksService {
  static String get _apiKey => dotenv.env['NYT_API_KEY'] ?? '';

  static Future<List<NYTBook>> fetchNYTBooks({
    String listName = 'paperback-nonfiction',
    String date = 'current',
  }) async {
    final url = Uri.parse(
      'https://api.nytimes.com/svc/books/v3/lists/$date/$listName.json?api-key=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> booksJson = data['results']['books'];
        return booksJson.map((json) => NYTBook.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load NYT books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching NYT books: $e');
      return [];
    }
  }

  static Future<List<String>> fetchAvailableLists() async {
    final url = Uri.parse(
      'https://api.nytimes.com/svc/books/v3/lists/overview.json?api-key=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> lists = data['results']['lists'];
        return lists.map((e) => e['list_name_encoded'] as String).toList();
      } else {
        throw Exception('Failed to load NYT list names');
      }
    } catch (e) {
      print('Error fetching NYT list names: $e');
      return [];
    }
  }
}
