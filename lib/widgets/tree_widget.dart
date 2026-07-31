import 'package:flutter/material.dart';
import 'dart:math';

class TreeWidget extends StatelessWidget {
  final int completedTasks;
  final bool isMini;

  const TreeWidget({
    super.key,
    required this.completedTasks,
    this.isMini = false,
  });

  int getTreeLevel() {
    if (completedTasks >= 20) return 8;
    if (completedTasks >= 15) return 7;
    if (completedTasks >= 12) return 6;
    if (completedTasks >= 9) return 5;
    if (completedTasks >= 6) return 4;
    if (completedTasks >= 4) return 3;
    if (completedTasks >= 2) return 2;
    if (completedTasks >= 1) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final level = getTreeLevel();
    final size = isMini ? 80.0 : 200.0;

    return CustomPaint(
      size: Size(size, size),
      painter: TreePainter(level: level, isMini: isMini),
    );
  }
}

class TreePainter extends CustomPainter {
  final int level;
  final bool isMini;

  TreePainter({required this.level, this.isMini = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final scale = isMini ? 0.4 : 1.0;

    // Vẽ đất
    paint.color = const Color(0xFF8B6914);
    final groundPath = Path()
      ..moveTo(0, size.height * 0.95)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.85,
          size.width * 0.5, size.height * 0.9)
      ..quadraticBezierTo(
          size.width * 0.7, size.height * 0.85, size.width, size.height * 0.95)
      ..close();
    canvas.drawPath(groundPath, paint);

    // Vẽ thân cây
    paint.color = const Color(0xFF6D4C41);
    final trunkWidth = 8.0 * scale;
    final trunkHeight = (30.0 + level * 3) * scale;
    final centerX = size.width / 2;
    final bottomY = size.height * 0.9;

    final trunkPath = Path()
      ..moveTo(centerX - trunkWidth / 2, bottomY)
      ..quadraticBezierTo(
        centerX - trunkWidth / 2 - 3 * scale,
        bottomY - trunkHeight / 2,
        centerX - trunkWidth / 4,
        bottomY - trunkHeight,
      )
      ..quadraticBezierTo(
        centerX,
        bottomY - trunkHeight - 5 * scale,
        centerX + trunkWidth / 4,
        bottomY - trunkHeight,
      )
      ..quadraticBezierTo(
        centerX + trunkWidth / 2 + 3 * scale,
        bottomY - trunkHeight / 2,
        centerX + trunkWidth / 2,
        bottomY,
      )
      ..close();
    canvas.drawPath(trunkPath, paint);

    if (level == 0) {
      // Hạt mầm
      paint.color = const Color(0xFFA5D6A7);
      canvas.drawCircle(
        Offset(centerX, bottomY - trunkHeight - 5 * scale),
        8 * scale,
        paint,
      );
      paint.color = const Color(0xFF81C784);
      canvas.drawCircle(
        Offset(centerX - 4 * scale, bottomY - trunkHeight - 3 * scale),
        4 * scale,
        paint,
      );
      canvas.drawCircle(
        Offset(centerX + 4 * scale, bottomY - trunkHeight - 3 * scale),
        4 * scale,
        paint,
      );
      return;
    }

    // Lá
    final leafColors = [
      const Color(0xFF388E3C),
      const Color(0xFF43A047),
      const Color(0xFF4CAF50),
      const Color(0xFF66BB6A),
      const Color(0xFF81C784),
    ];

    final centerY = bottomY - trunkHeight;
    final leafCount = 3 + level;
    final leafSize = (8.0 + level * 1.5) * scale;

    for (int i = 0; i < leafCount; i++) {
      final angle = (i / leafCount) * pi * 2;
      final radius = (12.0 + level * 1.5) * scale;
      final x = centerX +
          radius * 0.7 * (i % 2 == 0 ? 1 : -1) * (0.5 + (i / leafCount) * 0.3);
      final y = centerY -
          5 * scale -
          (i / leafCount) * 20 * scale +
          (i % 3) * 5 * scale;

      paint.color = leafColors[i % leafColors.length];
      canvas.drawCircle(
        Offset(x, y),
        leafSize * (0.5 + (i % 3) * 0.1),
        paint,
      );
    }

    // Hoa
    if (level >= 5 && !isMini) {
      for (int i = 0; i < level - 4; i++) {
        final angle = (i / (level - 4)) * pi * 2; // ✅ SỬA
        final x = centerX + (20 * scale) * cos(angle); // ✅ SỬA
        final y = centerY - 10 * scale + 10 * scale * sin(angle); // ✅ SỬA
        paint.color = const Color(0xFFFFEB3B);
        canvas.drawCircle(Offset(x, y), 4 * scale, paint);
        paint.color = const Color(0xFFFF6F00);
        canvas.drawCircle(Offset(x, y), 2 * scale, paint);
      }
    }

    // Quả
    if (level >= 7 && !isMini) {
      for (int i = 0; i < level - 6; i++) {
        final angle = (i / (level - 6)) * pi * 2 + 0.5; // ✅ SỬA
        final x = centerX + 25 * scale * cos(angle); // ✅ SỬA
        final y = centerY - 5 * scale + 15 * scale * sin(angle); // ✅ SỬA
        paint.color = const Color(0xFFFF1744);
        canvas.drawCircle(Offset(x, y), 4 * scale, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
