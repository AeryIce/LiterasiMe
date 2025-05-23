class Book {
  final String isbn;
  final String title;
  final String subtitleOrSnippet;
  final String authors;
  final String description;
  final String thumbnail;
  final String publisher;
  final String publishedDate;
  final int pageCount;
  final String dimensions;
  final List<String> categories;

  Book({
    required this.isbn,
    required this.title,
    required this.subtitleOrSnippet,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.publisher,
    required this.publishedDate,
    required this.pageCount,
    required this.dimensions,
    required this.categories,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final searchInfo = json['searchInfo'] ?? {};

    // Combine dimension string
    final dim = volumeInfo['dimensions'];
    String dimensionString = '';
    if (dim != null) {
      final h = dim['height'] ?? '';
      final w = dim['width'] ?? '';
      final t = dim['thickness'] ?? '';
      dimensionString = '$h x $w x $t';
    }

    final identifiers = volumeInfo['industryIdentifiers'] ?? [];
    String isbn = 'unknown';
    if (identifiers.isNotEmpty) {
      final match = identifiers.firstWhere(
        (id) => id['type'] == 'ISBN_13',
        orElse: () => {'identifier': 'unknown'},
      );
      isbn = match['identifier'];
    }

    return Book(
      isbn: isbn,
      title: volumeInfo['title'] ?? 'Tanpa Judul',
      subtitleOrSnippet:
          volumeInfo['subtitle'] ??
          searchInfo['textSnippet'] ??
          'Tanpa subjudul',
      authors: (volumeInfo['authors'] ?? ['Tidak diketahui']).join(', '),
      description: volumeInfo['description'] ?? 'Tidak ada deskripsi.',
      thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      publisher: volumeInfo['publisher'] ?? 'Tidak diketahui',
      publishedDate: volumeInfo['publishedDate'] ?? 'Tidak tersedia',
      pageCount: volumeInfo['pageCount'] ?? 0,
      dimensions:
          dimensionString.isNotEmpty ? dimensionString : 'Tidak diketahui',
      categories:
          (volumeInfo['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
