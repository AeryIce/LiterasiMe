// lib/utils/tagging_helper.dart

String cleanText(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '') // hapus tanda baca
      .replaceAll(RegExp(r'\s+'), ' ') // rapikan spasi
      .trim();
}

List<String> extractKeywordsNaif(String text) {
  final stopwords = {'yang', 'dan', 'dari', 'untuk', 'dalam', 'ini', 'itu', 'the', 'a', 'of', 'an', 'to'};
  final words = cleanText(text).split(' ');
  final keywords = words
      .where((word) => word.length > 3 && !stopwords.contains(word))
      .toSet()
      .toList();
  return keywords;
}

List<String> generateTagsFromBook({
  required String title,
  required List<String> authors,
  required List<String> categories,
  required String publisher,
  required String description,
}) {
  final List<String> rawTags = [];

  rawTags.addAll(cleanText(title).split(' '));
  rawTags.addAll(authors.map(cleanText));
  rawTags.addAll(categories.map(cleanText));
  rawTags.add(cleanText(publisher));
  rawTags.addAll(extractKeywordsNaif(description));

  final tags = rawTags
      .where((tag) => tag.length > 3)
      .map((tag) => tag.trim())
      .toSet()
      .toList();

  return tags;
}
