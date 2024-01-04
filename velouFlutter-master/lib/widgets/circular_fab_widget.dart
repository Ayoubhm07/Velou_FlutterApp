import 'dart:math';
import 'package:flutter/material.dart';

final double buttonSize = 80;

class CircularFabWidget extends StatefulWidget {
  @override
  State<CircularFabWidget> createState() => _CircularFabWidgetState();
}

class _CircularFabWidgetState extends State<CircularFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Flow(
        delegate: FlowMenuDelegate(controller: controller),
        children: <IconData>[
          Icons.mail,
          Icons.call,
          Icons.notifications,
          Icons.menu,
        ].map<Widget>(buildFab).toList(),
      );

  Widget buildFab(IconData icon) => FloatingActionButton(
        elevation: 0,
        splashColor: Colors.black,
        child: Icon(icon, color: Colors.white, size: 45),
        onPressed: () {
          if (controller.status == AnimationStatus.completed) {
            controller.reverse();
          } else
            controller.forward();
        },
      );
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  const FlowMenuDelegate({required this.controller})
      : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final n = context.childCount;
    for (int i = 0; i < n; i++) {
      final isLastItem = i == context.childCount - 1;
      final setValue = (value) => isLastItem ? 0.0 : value;
      final theta = pi * 0.5 / (n - 2);
      final radius = 180 * controller.value;
      final x = setValue(radius * cos(theta));
      final y = setValue(radius * sin(theta));
      context.paintChild(
        0,
        transform: Matrix4.identity()
          ..translate(x, y, 0)
          ..translate(buttonSize / 2, buttonSize / 2)
          ..rotateZ(isLastItem ? 0.0 : 180 * (1 - controller.value))
          ..scale(isLastItem ? 1.0 : max(controller.value, 0.5))
          ..translate(-buttonSize / 2, -buttonSize / 2),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) => false;
}


