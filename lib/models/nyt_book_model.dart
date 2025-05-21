class NYTBook {
  final int rank;
  final String primaryIsbn13;
  final String? reviewLink; // nullable karena bisa kosong

  NYTBook({required this.rank, required this.primaryIsbn13, this.reviewLink});

  factory NYTBook.fromJson(Map<String, dynamic> json) {
    return NYTBook(
      rank: json['rank'] ?? 0,
      primaryIsbn13: json['primary_isbn13'] ?? '',
      reviewLink: json['book_review_link'] ?? '',
    );
  }
}
