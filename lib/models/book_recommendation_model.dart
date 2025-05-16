import 'package:hive/hive.dart';

part 'book_recommendation_model.g.dart';

@HiveType(typeId: 2)
class BookRecommendation extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String authors;

  @HiveField(2)
  String thumbnail;

  BookRecommendation({
    required this.title,
    required this.authors,
    required this.thumbnail,
  });
}
