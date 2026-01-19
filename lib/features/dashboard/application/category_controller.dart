import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../dashboard/domain/category_item.dart';

import 'initial_content_service.dart';

class CategoryController extends StateNotifier<List<CategoryItem>> {
  CategoryController() : super([]) {
    _loadCategories();
  }

  static const String boxName = 'categoriesBox';

  Future<void> _loadCategories() async {
    final box = await Hive.openBox<CategoryItem>(boxName);
    if (box.isEmpty) {
      final defaults = InitialContentService.getInitialCategories();
      await box.addAll(defaults);
    }
    state = box.values.toList();
  }

  Future<void> addCategory(String name, int colorValue) async {
    final box = Hive.box<CategoryItem>(boxName);
    final newItem = CategoryItem(
      id: const Uuid().v4(),
      name: name,
      colorValue: colorValue,
    );
    await box.add(newItem);
    state = box.values.toList();
  }

  Future<void> deleteCategory(String id) async {
    final box = Hive.box<CategoryItem>(boxName);
    final Map<dynamic, CategoryItem> map = box.toMap();
    dynamic keyToDelete;
    map.forEach((key, value) {
      if (value.id == id) {
        keyToDelete = key;
      }
    });

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
      state = box.values.toList();
    }
  }
}

final categoryControllerProvider = StateNotifierProvider<CategoryController, List<CategoryItem>>((ref) {
  return CategoryController();
});
