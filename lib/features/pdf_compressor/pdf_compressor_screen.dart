import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:share_plus/share_plus.dart';

enum _CompressionLevel {
  low(scale: 2.0, quality: 85, label: 'Low', subtitle: 'Best quality'),
  medium(scale: 1.3, quality: 65, label: 'Medium', subtitle: 'Balanced'),
  high(scale: 0.8, quality: 40, label: 'High', subtitle: 'Smallest size');

  final double scale;
  final int quality;
  final String label;
  final String subtitle;
  const _CompressionLevel({
    required this.scale,
    required this.quality,
    required this.label,
    required this.subtitle,
  });
}

class PdfCompressorScreen extends StatefulWidget {
  const PdfCompressorScreen({super.key});

  @override
  State<PdfCompressorScreen> createState() => _PdfCompressorScreenState();
}

class _PdfCompressorScreenState extends State<PdfCompressorScreen> {
  File? _selectedFile;
  File? _compressedFile;
  int? _originalSize;
  int? _compressedSize;
  _CompressionLevel _level = _CompressionLevel.medium;
  bool _isProcessing = false;
  double _progress = 0;
  String? _error;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    setState(() {
      _selectedFile = file;
      _originalSize = file.lengthSync();
      _compressedFile = null;
      _compressedSize = null;
      _error = null;
    });
  }

  Future<void> _compress() async {
    if (_selectedFile == null) return;

    setState(() {
      _isProcessing = true;
      _progress = 0;
      _error = null;
      _compressedFile = null;
    });

    try {
      final document = await pdfx.PdfDocument.openFile(_selectedFile!.path);
      final outputDoc = pw.Document();
      final pageCount = document.pagesCount;

      for (var i = 1; i <= pageCount; i++) {
        final page = await document.getPage(i);

        final pageImage = await page.render(
          width: page.width * _level.scale,
          height: page.height * _level.scale,
          format: pdfx.PdfPageImageFormat.png,
          backgroundColor: '#FFFFFF',
        );

        final pageWidth = page.width;
        final pageHeight = page.height;
        await page.close();

        if (pageImage == null) continue;

        final decoded = img.decodeImage(pageImage.bytes);
        if (decoded == null) continue;

        final jpgBytes = img.encodeJpg(decoded, quality: _level.quality);
        final memImage = pw.MemoryImage(Uint8List.fromList(jpgBytes));

        outputDoc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(pageWidth, pageHeight),
            build: (context) => pw.Image(
              memImage,
              fit: pw.BoxFit.fill,
              width: pageWidth,
              height: pageHeight,
            ),
          ),
        );

        if (mounted) setState(() => _progress = i / pageCount);
      }

      await document.close();

      final outputBytes = await outputDoc.save();
      final dir = await getTemporaryDirectory();
      final outFile = File(
        '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await outFile.writeAsBytes(outputBytes);

      setState(() {
        _compressedFile = outFile;
        _compressedSize = outputBytes.length;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Could not compress this PDF: $e';
      });
    }
  }

  Future<void> _shareResult() async {
    if (_compressedFile == null) return;
    await Share.shareXFiles(
      [XFile(_compressedFile!.path)],
      text: 'Compressed PDF',
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedPercent = (_originalSize != null && _compressedSize != null && _originalSize! > 0)
        ? (100 - (_compressedSize! / _originalSize! * 100)).clamp(0, 100)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Compress PDF')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                onTap: _isProcessing ? null : _pickFile,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        _selectedFile == null ? Icons.upload_file : Icons.picture_as_pdf,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFile == null
                            ? 'Tap to select a PDF'
                            : _selectedFile!.path.split('/').last,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (_originalSize != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Original size: ${_formatBytes(_originalSize!)}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null) ...[
              const Text('Compression level', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: _CompressionLevel.values.map((level) {
                  final selected = level == _level;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(level.label),
                            Text(level.subtitle, style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                        selected: selected,
                        onSelected: _isProcessing
                            ? null
                            : (_) => setState(() => _level = level),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isProcessing ? null : _compress,
                icon: const Icon(Icons.compress),
                label: Text(_isProcessing ? 'Compressing...' : 'Compress PDF'),
              ),
            ],
            if (_isProcessing) ...[
              const SizedBox(height: 20),
              LinearProgressIndicator(value: _progress == 0 ? null : _progress),
              const SizedBox(height: 8),
              Text(
                'Processing page ${(_progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_compressedFile != null && _compressedSize != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(_formatBytes(_originalSize!),
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              const Text('Before', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          const Icon(Icons.arrow_forward),
                          Column(
                            children: [
                              Text(_formatBytes(_compressedSize!),
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              const Text('After', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      if (savedPercent != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${savedPercent.toStringAsFixed(0)}% smaller',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _shareResult,
                        icon: const Icon(Icons.share),
                        label: const Text('Share / Save PDF'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
