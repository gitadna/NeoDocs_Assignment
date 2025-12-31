class RangeModel {
  final double min;
  final double max;
  final String label;
  final String color;

  RangeModel({
    required this.min,
    required this.max,
    required this.label,
    required this.color,
  });

  factory RangeModel.fromJson(Map<String, dynamic> json) {
    // Extract range string safely
    final rangeString = json['range'] ?? '0-0';
    final parts = rangeString.split('-');

    final min = double.tryParse(parts[0]) ?? 0.0;
    final max = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

    return RangeModel(
      min: min,
      max: max,
      label: json['meaning'] ?? '', // meaning → label
      color: json['color'] ?? '#000000',
    );
  }
}
