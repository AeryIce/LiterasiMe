// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookHistoryAdapter extends TypeAdapter<BookHistory> {
  @override
  final int typeId = 0;

  @override
  BookHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookHistory(
      isbn: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String?,
      authors: (fields[3] as List?)?.cast<String>(),
      publisher: fields[4] as String?,
      publishedDate: fields[5] as String?,
      pageCount: fields[6] as int?,
      dimensions: fields[7] as String?,
      categories: (fields[8] as List?)?.cast<String>(),
      thumbnail: fields[9] as String?,
      scanCount: fields[10] as int,
      utmLinks: (fields[11] as Map?)?.cast<String, String>(),
      linkYoutube: fields[12] as String?,
      vector: (fields[13] as List?)?.cast<double>(),
      keywords: (fields[14] as List?)?.cast<String>(),
      tags: (fields[15] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookHistory obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.isbn)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.authors)
      ..writeByte(4)
      ..write(obj.publisher)
      ..writeByte(5)
      ..write(obj.publishedDate)
      ..writeByte(6)
      ..write(obj.pageCount)
      ..writeByte(7)
      ..write(obj.dimensions)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.thumbnail)
      ..writeByte(10)
      ..write(obj.scanCount)
      ..writeByte(11)
      ..write(obj.utmLinks)
      ..writeByte(12)
      ..write(obj.linkYoutube)
      ..writeByte(13)
      ..write(obj.vector)
      ..writeByte(14)
      ..write(obj.keywords)
      ..writeByte(15)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
