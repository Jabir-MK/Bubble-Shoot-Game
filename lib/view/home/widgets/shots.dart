import 'package:flutter/material.dart';

class Shots extends StatelessWidget {
  const Shots({super.key, required this.shotX, required this.shotY});

  final double shotX;
  final double shotY;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(shotX, shotY),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red[900],
        ),
      ),
    );
  }
}
