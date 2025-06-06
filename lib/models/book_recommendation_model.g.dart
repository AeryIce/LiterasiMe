// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_recommendation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookRecommendationAdapter extends TypeAdapter<BookRecommendation> {
  @override
  final int typeId = 2;

  @override
  BookRecommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookRecommendation(
      title: fields[0] as String,
      authors: fields[1] as String,
      thumbnail: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookRecommendation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.authors)
      ..writeByte(2)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookRecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
