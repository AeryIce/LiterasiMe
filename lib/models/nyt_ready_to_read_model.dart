
class NYTReadyBook {
  final String title;
  final String subtitle;
  final String authors;
  final String thumbnail;
  final String isbn;
  final int rank;

  NYTReadyBook({
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.thumbnail,
    required this.isbn,
    required this.rank,
  });

  factory NYTReadyBook.fromNYT(Map<String, dynamic> json) {
    return NYTReadyBook(
      title: json['title'] ?? '',
      subtitle: json['description'] ?? '',
      authors: json['author'] ?? '',
      thumbnail: json['book_image'] ?? '',
      isbn: json['primary_isbn13'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }

  factory NYTReadyBook.fromJson(Map<String, dynamic> json) {
    return NYTReadyBook(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      authors: json['authors'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      isbn: json['isbn'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'thumbnail': thumbnail,
      'isbn': isbn,
      'rank': rank,
    };
  }

  NYTReadyBook enrichWithGoogleData(Map<String, dynamic> volumeInfo) {
    return NYTReadyBook(
      title: volumeInfo['title'] ?? this.title,
      subtitle: volumeInfo['subtitle'] ?? this.subtitle,
      authors: (volumeInfo['authors'] != null)
          ? (volumeInfo['authors'] as List).join(', ')
          : this.authors,
      thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? this.thumbnail,
      isbn: this.isbn,
      rank: this.rank,
    );
  }
}
