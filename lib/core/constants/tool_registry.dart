import 'package:flutter/material.dart';
import '../models/tool_meta.dart';
import '../widgets/placeholder_tool_screen.dart';
import '../../features/word_counter/word_counter_screen.dart';
import '../../features/unit_converter/unit_converter_screen.dart';
import '../../features/json_formatter/json_formatter_screen.dart';
import '../../features/qr_generator/qr_generator_screen.dart';

final List<ToolMeta> toolRegistry = [
  ToolMeta(
    id: 'pdf_merge',
    name: 'Merge PDF',
    icon: Icons.picture_as_pdf,
    category: 'PDF',
    builder: (_) => const PlaceholderToolScreen(toolName: 'Merge PDF'),
  ),
  ToolMeta(
    id: 'pdf_compress',
    name: 'Compress PDF',
    icon: Icons.compress,
    category: 'PDF',
    builder: (_) => const PlaceholderToolScreen(toolName: 'Compress PDF'),
  ),
  ToolMeta(
    id: 'image_compress',
    name: 'Compress Image',
    icon: Icons.image,
    category: 'Image',
    builder: (_) => const PlaceholderToolScreen(toolName: 'Compress Image'),
  ),
  ToolMeta(
    id: 'qr_generate',
    name: 'QR Generator',
    icon: Icons.qr_code,
    category: 'QR',
    builder: (_) => const QrGeneratorScreen(),
  ),
  ToolMeta(
    id: 'qr_scan',
    name: 'QR Scanner',
    icon: Icons.qr_code_scanner,
    category: 'QR',
    builder: (_) => const PlaceholderToolScreen(toolName: 'QR Scanner'),
  ),
  ToolMeta(
    id: 'json_formatter',
    name: 'JSON Formatter',
    icon: Icons.data_object,
    category: 'Dev',
    builder: (_) => const JsonFormatterScreen(),
  ),
  ToolMeta(
    id: 'unit_converter',
    name: 'Unit Converter',
    icon: Icons.swap_horiz,
    category: 'Utility',
    builder: (_) => const UnitConverterScreen(),
  ),
  ToolMeta(
    id: 'word_counter',
    name: 'Word Counter',
    icon: Icons.text_fields,
    category: 'Text',
    builder: (_) => const WordCounterScreen(),
  ),
];
