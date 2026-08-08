import 'package:flutter/material.dart';
import '../../core/constants/tool_registry.dart';
import '../../core/widgets/tool_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String _category = 'All';

  List<String> get _categories {
    final cats = toolRegistry.map((t) => t.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = toolRegistry.where((t) {
      final matchesQuery = t.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == 'All' || t.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('iLoveTools')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search tools',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _category;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No tools found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => ToolCard(tool: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
