import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/symbol_item.dart';
import '../../domain/category_item.dart';

class EditSymbolDialog extends StatefulWidget {
  final SymbolItem? item;
  final List<CategoryItem> categories;
  final Function(String label, String? imagePath, String? audioPath, String? categoryId, int? iconCode) onSave;
  final VoidCallback? onDelete;

  const EditSymbolDialog({
    super.key,
    this.item,
    required this.categories,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<EditSymbolDialog> createState() => _EditSymbolDialogState();
}

class _EditSymbolDialogState extends State<EditSymbolDialog> {
  late TextEditingController _labelController;
  String? _imagePath;
  String? _audioPath;
  String? _selectedCategoryId;
  int? _selectedIconCode;
  
  // Audio Recording
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  bool _isRecording = false;

  final List<IconData> _predefinedIcons = [
    Icons.home, Icons.school, Icons.park, Icons.local_hospital,
    Icons.restaurant, Icons.local_drink, Icons.cake, Icons.icecream,
    Icons.face, Icons.face_2, Icons.face_3, Icons.face_4,
    Icons.sentiment_satisfied_alt, Icons.sentiment_dissatisfied, Icons.sentiment_very_dissatisfied,
    Icons.thumb_up, Icons.thumb_down, Icons.waving_hand, Icons.favorite,
    Icons.directions_run, Icons.visibility, Icons.hearing, Icons.touch_app,
    Icons.bed, Icons.chair, Icons.weekend, Icons.tv,
    Icons.toys, Icons.sports_soccer, Icons.music_note, Icons.brush,
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.item?.label ?? '');
    _imagePath = widget.item?.imagePath;
    _audioPath = widget.item?.audioPath;
    _selectedCategoryId = widget.item?.categoryId;
    _selectedIconCode = widget.item?.iconCode;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _imagePath = file.path;
        _selectedIconCode = null; // Clear icon if image picked
      });
    }
  }

  void _selectIcon(IconData icon) {
    setState(() {
      _selectedIconCode = icon.codePoint;
      _imagePath = null; // Clear image if icon selected
    });
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
    } else {
      if (await Permission.microphone.request().isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = '${const Uuid().v4()}.m4a';
        final path = '${dir.path}/$fileName';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
        });
      }
    }
  }

  Future<void> _playAudio() async {
    if (_audioPath != null) {
      await _audioPlayer.play(DeviceFileSource(_audioPath!));
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Yeni Kart Ekle' : 'Kartı Düzenle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Etiket (Kelime)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Kategorisiz')),
                ...widget.categories.map((c) => DropdownMenuItem(
                  value: c.id, 
                  child: Text(c.name),
                )),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedCategoryId = val;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Görsel Seçimi:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            // Icon Grid
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _predefinedIcons.length,
                itemBuilder: (context, index) {
                  final icon = _predefinedIcons[index];
                  final isSelected = _selectedIconCode == icon.codePoint;
                  return InkWell(
                    onTap: () => _selectIcon(icon),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[100] : null,
                        border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: isSelected ? Colors.blue : null),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Veya Galeri: "),
                if (_imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_imagePath!), width: 40, height: 40, fit: BoxFit.cover),
                  ),
                  
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Fotoğraf Yükle'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Ses:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton.filled(
                  onPressed: _toggleRecord,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  color: _isRecording ? Colors.red : null,
                ),
                if (_audioPath != null)
                  IconButton(
                    onPressed: _playAudio,
                    icon: const Icon(Icons.play_arrow),
                  ),
                const SizedBox(width: 8),
                Text(_audioPath != null ? 'Ses Kaydedildi' : 'Ses Kaydı Yok'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.item != null)
          TextButton(
            onPressed: widget.onDelete,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            if (_labelController.text.isNotEmpty) {
              widget.onSave(_labelController.text, _imagePath, _audioPath, _selectedCategoryId, _selectedIconCode);
              Navigator.pop(context);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
