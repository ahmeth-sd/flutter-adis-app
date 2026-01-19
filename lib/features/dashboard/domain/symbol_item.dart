import 'package:hive/hive.dart';

class SymbolItem {
  final String id;
  final String label;
  final String? imagePath;
  final int? iconCode;
  final String? audioPath;
  final int colorValue;
  final String? categoryId;
  final String level;

  SymbolItem({
    required this.id,
    required this.label,
    this.imagePath,
    this.iconCode,
    this.audioPath,
    required this.colorValue,
    this.categoryId,
    this.level = 'basic',
  });

  SymbolItem copyWith({
    String? label,
    String? imagePath,
    int? iconCode,
    String? audioPath,
    int? colorValue,
    String? categoryId,
    String? level,
  }) {
    return SymbolItem(
      id: id,
      label: label ?? this.label,
      imagePath: imagePath ?? this.imagePath,
      iconCode: iconCode ?? this.iconCode,
      audioPath: audioPath ?? this.audioPath,
      colorValue: colorValue ?? this.colorValue,
      categoryId: categoryId ?? this.categoryId,
      level: level ?? this.level,
    );
  }
}

class SymbolItemAdapter extends TypeAdapter<SymbolItem> {
  @override
  final int typeId = 0;

  @override
  SymbolItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymbolItem(
      id: fields[0] as String,
      label: fields[1] as String,
      imagePath: fields[2] as String?,
      iconCode: fields[3] as int?,
      audioPath: fields[4] as String?,
      colorValue: fields[5] as int,
      categoryId: fields.containsKey(6) ? fields[6] as String? : null,
      level: fields.containsKey(7) ? fields[7] as String : 'basic',
    );
  }

  @override
  void write(BinaryWriter writer, SymbolItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.iconCode)
      ..writeByte(4)
      ..write(obj.audioPath)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.level);
  }
}
