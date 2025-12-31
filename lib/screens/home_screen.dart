import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/range_provider.dart';
import '../widgets/range_guage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RangeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Range Indicator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Value',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                provider.updateInput(double.tryParse(value) ?? 0);
              },
            ),
            const SizedBox(height: 24),
            if (provider.isLoading) const CircularProgressIndicator(),
            if (provider.error != null)
              Column(
                children: [
                  Text(provider.error!,
                      style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: provider.loadRanges,
                    child: const Text('Retry'),
                  )
                ],
              ),
            if (!provider.isLoading && provider.error == null)
              RangeGauge(
                ranges: provider.ranges,
                value: provider.inputValue,
              ),
          ],
        ),
      ),
    );
  }
}
