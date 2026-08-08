import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String _data = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter text or URL',
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (v) => setState(() => _data = v),
            ),
            const SizedBox(height: 32),
            if (_data.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: QrImageView(data: _data, version: QrVersions.auto, size: 240),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  'Type something above to generate a QR code',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
