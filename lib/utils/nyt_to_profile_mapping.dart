
/// Bidirectional mapping antara list_name_encoded NYT dan genre LiterasiMe
/// Lengkap dengan fallback ke 'paperback-nonfiction'

String mapNYTtoProfile(String listNameEncoded) {
  const mapping = {
    'advice-how-to-and-miscellaneous': 'SelfHelp',
    'audio-fiction': 'Literature',
    'audio-nonfiction': 'NonFiction',
    'business-books': 'Economics',
    'childrens-middle-grade-hardcover': 'Children',
    'combined-print-and-e-book-fiction': 'Literature',
    'combined-print-and-e-book-nonfiction': 'NonFiction',
    'graphic-books-and-manga': 'Comics and Manga',
    'hardcover-fiction': 'Literature',
    'hardcover-nonfiction': 'NonFiction',
    'health': 'Health',
    'mass-market-monthly': 'Literature',
    'middle-grade-paperback-monthly': 'Children',
    'paperback-business-books': 'Economics',
    'paperback-nonfiction': 'NonFiction',
    'picture-books': 'Children',
    'series-books': 'Series Books',
    'young-adult-hardcover': 'Young Adult',
  };

  return mapping[listNameEncoded] ?? 'NonFiction';
}

String mapProfileToNYT(String genre) {
  const reverseMapping = {
    'SelfHelp': 'advice-how-to-and-miscellaneous',
    'Literature': 'hardcover-fiction',
    'NonFiction': 'paperback-nonfiction',
    'Economics': 'business-books',
    'Children': 'childrens-middle-grade-hardcover',
    'Comics and Manga': 'graphic-books-and-manga',
    'Health': 'health',
    'Series Books': 'series-books',
    'Young Adult': 'young-adult-hardcover',
  };

  return reverseMapping[genre] ?? 'paperback-nonfiction';
}
