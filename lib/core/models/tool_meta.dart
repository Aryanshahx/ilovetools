import 'package:flutter/material.dart';

class ToolMeta {
  final String id;
  final String name;
  final IconData icon;
  final String category;
  final WidgetBuilder builder;

  const ToolMeta({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.builder,
  });
}
