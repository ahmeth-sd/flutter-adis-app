import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../dashboard/domain/symbol_item.dart';

import 'initial_content_service.dart';

class SymbolController extends StateNotifier<List<SymbolItem>> {
  SymbolController() : super([]) {
    _loadSymbols();
  }

  static const String boxName = 'symbolsBox';

  Future<void> _loadSymbols() async {
    final box = await Hive.openBox<SymbolItem>(boxName);
    if (box.isEmpty) {
      final initialData = InitialContentService.getInitialSymbols();
      await box.addAll(initialData);
    }
    state = box.values.toList();
  }

  Future<void> addSymbol(String label, String? imagePath, String? audioPath, String? categoryId, int? iconCode) async {
    final box = Hive.box<SymbolItem>(boxName);
    final newItem = SymbolItem(
      id: const Uuid().v4(),
      label: label,
      imagePath: imagePath,
      iconCode: iconCode ?? (imagePath == null ? Icons.star.codePoint : null),
      audioPath: audioPath,
      colorValue: Colors.blue.toARGB32(),
      categoryId: categoryId,
    );
    await box.add(newItem);
    state = box.values.toList();
  }

  Future<void> updateSymbol(SymbolItem item) async {
    final box = Hive.box<SymbolItem>(boxName);
    // Find key to update (Hive stores keys separately from values usually int if auto-increment)
    // Here we iterate to find the matching ID since we didn't store ID as key.
    final Map<dynamic, SymbolItem> map = box.toMap();
    dynamic keyToUpdate;
    map.forEach((key, value) {
      if (value.id == item.id) {
        keyToUpdate = key;
      }
    });

    if (keyToUpdate != null) {
      await box.put(keyToUpdate, item);
      state = box.values.toList();
    }
  }

  Future<void> deleteSymbol(String id) async {
    final box = Hive.box<SymbolItem>(boxName);
    final Map<dynamic, SymbolItem> map = box.toMap();
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

final symbolControllerProvider = StateNotifierProvider<SymbolController, List<SymbolItem>>((ref) {
  return SymbolController();
});
