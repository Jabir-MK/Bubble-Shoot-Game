import 'package:flutter/material.dart';

class Weapon extends StatelessWidget {
  const Weapon({
    super.key,
    required this.weaponItemX,
    required this.weaponItemHeight,
  });

  final double weaponItemX;
  final double weaponItemHeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(weaponItemX, 1),
      child: Container(
        height: weaponItemHeight,
        width: 5,
        color: Colors.grey,
      ),
    );
  }
}
