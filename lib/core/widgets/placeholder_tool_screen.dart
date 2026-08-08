import 'package:flutter/material.dart';

class PlaceholderToolScreen extends StatelessWidget {
  final String toolName;

  const PlaceholderToolScreen({super.key, required this.toolName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(toolName)),
      body: Center(
        child: Text(
          '$toolName — coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
