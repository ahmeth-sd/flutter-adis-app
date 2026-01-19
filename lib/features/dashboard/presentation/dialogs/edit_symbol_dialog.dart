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
  final Function(String label, String? imagePath, String? audioPath, String? categoryId) onSave;
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
  
  // Audio Recording
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.item?.label ?? '');
    _imagePath = widget.item?.imagePath;
    _audioPath = widget.item?.audioPath;
    
    // Safety check: ensure categoryId exists in provided categories
    final hasCategory = widget.categories.any((c) => c.id == widget.item?.categoryId);
    _selectedCategoryId = hasCategory ? widget.item?.categoryId : null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _imagePath = file.path;
      });
    }
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
            const Text('Görsel:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_imagePath!), width: 60, height: 60, fit: BoxFit.cover),
                  )
                else
                  const Icon(Icons.image, size: 60, color: Colors.grey),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Fotoğraf Seç'),
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
              widget.onSave(_labelController.text, _imagePath, _audioPath, _selectedCategoryId);
              Navigator.pop(context);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
