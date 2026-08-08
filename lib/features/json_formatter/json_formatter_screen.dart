import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonFormatterScreen extends StatefulWidget {
  const JsonFormatterScreen({super.key});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen> {
  final _inputController = TextEditingController();
  String _output = '';
  String? _error;

  void _format({bool minify = false}) {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _output = '';
        _error = null;
      });
      return;
    }
    try {
      final decoded = jsonDecode(text);
      final encoder = minify ? const JsonEncoder() : const JsonEncoder.withIndent('  ');
      setState(() {
        _output = encoder.convert(decoded);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Invalid JSON: $e';
        _output = '';
      });
    }
  }

  void _copyOutput() {
    if (_output.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _output));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON Formatter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Paste raw JSON here...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => _format(minify: false),
                    child: const Text('Format'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _format(minify: true),
                    child: const Text('Minify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_output.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Result', style: TextStyle(fontWeight: FontWeight.w600)),
                  IconButton(icon: const Icon(Icons.copy), onPressed: _copyOutput),
                ],
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace')),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
