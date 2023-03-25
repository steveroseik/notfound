import 'package:flutter/material.dart';

class TabBarIndicator extends Decoration {
  final BoxPainter _painter;

  TabBarIndicator({required Color color, required double radius})
      : _painter = _TabBarIndicator(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _TabBarIndicator extends BoxPainter {
  final Paint _paint;
  final double radius;

  _TabBarIndicator(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration){
    final Offset customOffset = offset +
        Offset(configuration.size!.width / 2,
            configuration.size!.height);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
              center: customOffset,
              width: configuration.size!.width / 2,
              height: 4),
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        _paint);
  }
}