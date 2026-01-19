import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tts/application/tts_service.dart';

class KeyboardScreen extends ConsumerStatefulWidget {
  const KeyboardScreen({super.key});

  @override
  ConsumerState<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends ConsumerState<KeyboardScreen> {
  final _controller = TextEditingController();

  void _speak() {
    ref.read(ttsServiceProvider).speak(_controller.text);
  }

  void _clear() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klavye')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Yazmak istediğiniz cümleyi girin...',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _speak,
                    icon: const Icon(Icons.volume_up, size: 32),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('OKU', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filledTonal(
                  onPressed: _clear,
                  icon: const Icon(Icons.delete, size: 32),
                  padding: const EdgeInsets.all(16),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
