import 'package:flutter/material.dart';

class WordCounterScreen extends StatefulWidget {
  const WordCounterScreen({super.key});

  @override
  State<WordCounterScreen> createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  final _controller = TextEditingController();
  int _words = 0, _chars = 0, _sentences = 0, _paragraphs = 0;

  void _update(String text) {
    final trimmed = text.trim();
    setState(() {
      _words = trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
      _chars = text.length;
      _sentences = trimmed.isEmpty ? 0 : RegExp(r'[.!?]+').allMatches(text).length;
      _paragraphs = trimmed.isEmpty
          ? 0
          : text.split(RegExp(r'\n+')).where((p) => p.trim().isNotEmpty).length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _stat(String label, int value) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Words', _words),
                    _stat('Characters', _chars),
                    _stat('Sentences', _sentences),
                    _stat('Paragraphs', _paragraphs),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _update,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Start typing or paste your text here...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
