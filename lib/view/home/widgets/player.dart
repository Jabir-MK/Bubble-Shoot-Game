import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.xCordinate,
  });
  final double xCordinate;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(xCordinate, 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 50,
        width: 50,
      ),
    );
  }
}
