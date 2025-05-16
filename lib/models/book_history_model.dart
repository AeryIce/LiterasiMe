import 'package:hive/hive.dart';

part 'book_history_model.g.dart';

@HiveType(typeId: 0)
class BookHistory extends HiveObject {
  @HiveField(0)
  String isbn;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? subtitle;

  @HiveField(3)
  List<String>? authors;

  @HiveField(4)
  String? publisher;

  @HiveField(5)
  String? publishedDate;

  @HiveField(6)
  int? pageCount;

  @HiveField(7)
  String? dimensions;

  @HiveField(8)
  List<String>? categories;

  @HiveField(9)
  String? thumbnail;

  @HiveField(10)
  int scanCount;

  @HiveField(11)
  Map<String, String>? utmLinks;

  @HiveField(12)
  String? linkYoutube;

  @HiveField(13)
  List<double>? vector;

  @HiveField(14)
  List<String>? keywords;

  @HiveField(15)
  List<String>? tags;

  BookHistory({
    required this.isbn,
    required this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.dimensions,
    this.categories,
    this.thumbnail,
    this.scanCount = 1,
    this.utmLinks,
    this.linkYoutube,
    this.vector,
    this.keywords,
    this.tags,

  });
}
