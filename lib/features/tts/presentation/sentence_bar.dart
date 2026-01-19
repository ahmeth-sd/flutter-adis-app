import 'package:flutter/material.dart';

class SentenceBar extends StatelessWidget {
  final List<String> words;
  final VoidCallback onPlay;
  final VoidCallback onClear;
  final Function(int) onRemoveWord;

  const SentenceBar({
    super.key,
    required this.words,
    required this.onPlay,
    required this.onClear,
    required this.onRemoveWord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Chip(
                    label: Text(words[index]),
                    onDeleted: () => onRemoveWord(index),
                    deleteIcon: const Icon(Icons.close),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.deepPurple),
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(),
          IconButton.filled(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Oku',
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: onClear,
            icon: const Icon(Icons.backspace),
            tooltip: 'Temizle',
          ),
        ],
      ),
    );
  }
}
