import 'package:flutter/material.dart';
import '../../core/constants/tool_registry.dart';
import '../../core/widgets/tool_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iLoveTools')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: toolRegistry.length,
          itemBuilder: (context, index) => ToolCard(tool: toolRegistry[index]),
        ),
      ),
    );
  }
}
