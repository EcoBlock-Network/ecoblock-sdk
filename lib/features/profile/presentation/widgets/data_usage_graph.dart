import 'package:flutter/material.dart';

class DataUsageGraph extends StatelessWidget {
  final List<double> values;
  const DataUsageGraph({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    return Row(children: values.map((v) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(height: (v / (max + 1)) * 60 + 6, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(4)))])))).toList());
  }
}
