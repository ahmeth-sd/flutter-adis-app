import 'package:hive/hive.dart';

class CategoryItem {
  final String id;
  final String name;
  final int colorValue;

  CategoryItem({
    required this.id,
    required this.name,
    required this.colorValue,
  });
}

class CategoryItemAdapter extends TypeAdapter<CategoryItem> {
  @override
  final int typeId = 1;

  @override
  CategoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryItem(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue);
  }
}
