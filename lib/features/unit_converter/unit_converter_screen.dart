import 'package:flutter/material.dart';

enum _Category { length, weight, temperature }

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  _Category _category = _Category.length;
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  final _inputController = TextEditingController(text: '1');
  String _result = '';

  final Map<_Category, Map<String, double>> _factorsToBase = {
    _Category.length: {
      'Meters': 1,
      'Kilometers': 1000,
      'Centimeters': 0.01,
      'Miles': 1609.34,
      'Feet': 0.3048,
      'Inches': 0.0254,
    },
    _Category.weight: {
      'Kilograms': 1,
      'Grams': 0.001,
      'Pounds': 0.453592,
      'Ounces': 0.0283495,
    },
  };

  List<String> get _unitsForCategory {
    if (_category == _Category.temperature) {
      return ['Celsius', 'Fahrenheit', 'Kelvin'];
    }
    return _factorsToBase[_category]!.keys.toList();
  }

  @override
  void initState() {
    super.initState();
    _convert();
  }

  void _convert() {
    final input = double.tryParse(_inputController.text);
    if (input == null) {
      setState(() => _result = '');
      return;
    }
    double output;
    if (_category == _Category.temperature) {
      output = _convertTemperature(input, _fromUnit, _toUnit);
    } else {
      final factors = _factorsToBase[_category]!;
      final base = input * factors[_fromUnit]!;
      output = base / factors[_toUnit]!;
    }
    setState(() => _result = output.toStringAsFixed(4));
  }

  double _convertTemperature(double value, String from, String to) {
    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }
    switch (to) {
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  void _onCategoryChanged(_Category cat) {
    setState(() {
      _category = cat;
      final units = _unitsForCategory;
      _fromUnit = units[0];
      _toUnit = units.length > 1 ? units[1] : units[0];
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final units = _unitsForCategory;

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_Category>(
              segments: const [
                ButtonSegment(value: _Category.length, label: Text('Length')),
                ButtonSegment(value: _Category.weight, label: Text('Weight')),
                ButtonSegment(value: _Category.temperature, label: Text('Temp')),
              ],
              selected: {_category},
              onSelectionChanged: (s) => _onCategoryChanged(s.first),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Value'),
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromUnit,
                    items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) {
                      setState(() => _fromUnit = v!);
                      _convert();
                    },
                    decoration: const InputDecoration(labelText: 'From'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    setState(() {
                      final temp = _fromUnit;
                      _fromUnit = _toUnit;
                      _toUnit = temp;
                    });
                    _convert();
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toUnit,
                    items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) {
                      setState(() => _toUnit = v!);
                      _convert();
                    },
                    decoration: const InputDecoration(labelText: 'To'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      '$_result $_toUnit',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
