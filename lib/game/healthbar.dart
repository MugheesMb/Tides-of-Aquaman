// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// import 'player.dart';

// class HealthBar extends PositionComponent {
//   final Player player;

//   HealthBar({
//     required this.player,
//     super.position,
//     super.size,
//     super.scale,
//     super.angle,
//     super.anchor,
//     super.children,
//     super.priority,
//   }) {
//     positionType = PositionType.viewport;
//   }

//   @override
//   void render(Canvas canvas) {
//     // Draws a rectangular health bar at top right corner.
//     canvas.drawRect(
//       Rect.fromLTWH(-2, 5, player.health.toDouble(), 20),
//       Paint()..color = Color.fromARGB(255, 233, 0, 0),
//     );
//     super.render(canvas);
//   }
// }
