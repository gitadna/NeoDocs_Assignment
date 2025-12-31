import 'package:flutter/material.dart';
import '../models/range_model.dart';

class RangeGauge extends StatelessWidget {
  final List<RangeModel> ranges;
  final double value;

  const RangeGauge({
    super.key,
    required this.ranges,
    required this.value,
  });

  Color _parseColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xff')));

  @override
  Widget build(BuildContext context) {
    if (ranges.isEmpty) return const SizedBox();

    final min = ranges.first.min;
    final max = ranges.last.max;
    final v = value.clamp(min, max);

    return SizedBox(
      height: 90,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final percent = (v - min) / (max - min);
          final pointerX = width * percent;

          /// Determine active range color
          final activeRange = ranges.firstWhere(
            (r) => v >= r.min && v <= r.max,
            orElse: () => ranges.first,
          );
          final activeColor = _parseColor(activeRange.color);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              /// 🔘 FULL GREY TRACK
              Positioned(
                top: 36,
                left: 0,
                right: 0,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              /// 🟢 VALUE FILL (up to pointer)
              Positioned(
                top: 36,
                left: 0,
                child: Container(
                  width: pointerX,
                  height: 12,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              /// 🔺 ARROW POINTER
              Positioned(
                top: 32,
                left: pointerX - 8,
                child: CustomPaint(
                  size: const Size(16, 14),
                  painter: _ArrowPainter(color: activeColor),
                ),
              ),

              /// 🔢 VALUE TEXT
              Positioned(
                top: 0,
                left: pointerX - 12,
                child: Text(
                  v.toInt().toString(),
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 📏 TICKS + LABELS (based on ranges)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ranges.map((r) {
                    final percent = (r.min - min) / (max - min);
                    return Column(
                      children: [
                        Container(
                          width: 1,
                          height: 8,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.min.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  }).toList()
                    ..add(
                      Column(
                        children: [
                          Container(
                            width: 1,
                            height: 8,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            max.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
