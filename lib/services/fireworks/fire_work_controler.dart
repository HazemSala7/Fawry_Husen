// import 'dart:math';

// import 'package:flutter/material.dart';

// class FireworksScreen extends StatefulWidget {
//   @override
//   _FireworksScreenState createState() => _FireworksScreenState();
// }

// class _FireworksScreenState extends State<FireworksScreen> {
//   List<Firework> fireworks = [];

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: fireworks,
//     );
//   }

//   void showFireworks() {
//     setState(() {
//       fireworks.add(Firework());
//     });
//   }

//   @override
//   void dispose() {
//     for (var firework in fireworks) {
//       firework.dispose();
//     }
//     super.dispose();
//   }
// }

// class Firework extends StatefulWidget {
//   @override
//   _FireworkState createState() => _FireworkState();
// }

// class _FireworkState extends State<Firework> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     );

//     _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _controller.dispose();
//           _removeFirework();
//         }
//       });

//     _controller.forward();
//   }

//   void _removeFirework() {
//     final parentState =
//         context.findAncestorStateOfType<_FireworksScreenState>();
//     if (parentState != null) {
//       parentState.setState(() {
//         parentState.fireworks.remove(this);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return CustomPaint(
//           size: Size(40, 40),
//           painter: FireworkPainter(_animation.value),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class FireworkPainter extends CustomPainter {
//   final double progress;

//   FireworkPainter(this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color(0xFFFFD700) // Firework color (here: gold)
//       ..style = PaintingStyle.fill;

//     if (progress < 0.5) {
//       // Draw the firework burst
//       final radius = size.width / 2 * progress;
//       canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
//     } else {
//       // Draw the explosion sparks
//       for (int i = 0; i < 8; i++) {
//         final angle = i * (2 * pi / 8);
//         final x = size.width / 2 + size.width / 2 * progress * cos(angle);
//         final y = size.height / 2 + size.width / 2 * progress * sin(angle);
//         canvas.drawCircle(Offset(x, y), 2, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
