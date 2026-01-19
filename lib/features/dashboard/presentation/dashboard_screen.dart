import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../tts/application/tts_service.dart';
import '../../tts/presentation/sentence_bar.dart';
import '../application/symbol_controller.dart';
import 'widgets/symbol_card.dart';
import 'dialogs/edit_symbol_dialog.dart';
import '../domain/symbol_item.dart';
import '../application/category_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _crossAxisCount = 4;
  late final Box _settingsBox;
  final List<String> _selectedWords = [];
  bool _isEditMode = false;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadGridConfig();
  }

  void _loadGridConfig() {
    _settingsBox = Hive.box(AppConstants.settingsBox);
    final level = _settingsBox.get(AppConstants.userLevelKey, defaultValue: 'basic');
    
    switch (level) {
      case 'basic':
        _crossAxisCount = 4; 
        break;
      case 'intermediate':
        _crossAxisCount = 5; 
        break;
      case 'advanced':
        _crossAxisCount = 6; 
        break;
      default:
        _crossAxisCount = 4;
    }
    setState(() {});
  }

  void _addWord(String word) {
    setState(() {
      _selectedWords.add(word);
    });
    ref.read(ttsServiceProvider).speak(word);
  }

  void _removeWord(int index) {
    setState(() {
      _selectedWords.removeAt(index);
    });
  }

  void _clearWords() {
    setState(() {
      _selectedWords.clear();
    });
  }

  void _playSentence() {
    final sentence = _selectedWords.join(" ");
    ref.read(ttsServiceProvider).speak(sentence);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
    // SnackBar logic removed for cleaner UX or keep if desired
  }

  void _showEditDialog(BuildContext context, {SymbolItem? item}) {
    showDialog(
      context: context,
      builder: (context) => EditSymbolDialog(
        item: item,
        categories: ref.read(categoryControllerProvider),
        onSave: (label, imagePath, audioPath, categoryId, iconCode) {
          if (item == null) {
             ref.read(symbolControllerProvider.notifier).addSymbol(label, imagePath, audioPath, categoryId, iconCode);
          } else {
            final updated = item.copyWith(
              label: label, 
              imagePath: imagePath, 
              audioPath: audioPath,
              categoryId: categoryId,
              iconCode: iconCode
            );
            ref.read(symbolControllerProvider.notifier).updateSymbol(updated);
          }
        },
        onDelete: item != null 
          ? () {
              ref.read(symbolControllerProvider.notifier).deleteSymbol(item.id);
              Navigator.pop(context);
            } 
          : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSymbols = ref.watch(symbolControllerProvider);
    final categories = ref.watch(categoryControllerProvider);
    
    final level = _settingsBox.get(AppConstants.userLevelKey, defaultValue: 'basic');
    
    final levelSymbols = allSymbols.where((s) {
      if (level == 'basic') return s.level == 'basic';
      if (level == 'intermediate') return s.level == 'basic' || s.level == 'intermediate';
      return true; // Advanced shows all
    }).toList();

    final filteredSymbols = _selectedCategoryId == null 
        ? levelSymbols 
        : levelSymbols.where((s) => s.categoryId == _selectedCategoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Düzenleme Modu' : 'İletişim Paneli'),
        backgroundColor: _isEditMode ? Colors.orange[100] : null,
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.edit_off : Icons.edit),
            tooltip: 'Düzenle',
            onPressed: _toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: () {
              context.go('/keyboard');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _settingsBox.delete(AppConstants.userLevelKey);
              context.go('/onboarding');
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Category List
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: const Text('Tümü'),
                    selected: _selectedCategoryId == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = null;
                      });
                    },
                  ),
                ),
                ...categories.map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category.name),
                    selected: _selectedCategoryId == category.id,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = selected ? category.id : null;
                      });
                    },
                  ),
                )),
              ],
            ),
          ),
          
          if (!_isEditMode)
            SentenceBar(
              words: _selectedWords,
              onPlay: _playSentence,
              onClear: _clearWords,
              onRemoveWord: _removeWord,
            ),
          
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: filteredSymbols.length + (_isEditMode ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isEditMode && index == filteredSymbols.length) {
                  return Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      onTap: () => _showEditDialog(context),
                      borderRadius: BorderRadius.circular(16),
                      child: const Center(child: Icon(Icons.add, size: 48)),
                    ),
                  );
                }

                final item = filteredSymbols[index];
                return SymbolCard(
                  label: item.label,
                  imagePath: item.imagePath,
                  iconCode: item.iconCode,
                  color: Color(item.colorValue),
                  onTap: _isEditMode 
                    ? () => _showEditDialog(context, item: item)
                    : () => _addWord(item.label),
                );
              },
            ),
          ),
          // Navigation Bar
          Container(
            height: 60,
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const Text('Sayfa 1 / 3', style: TextStyle(color: Colors.white)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
