import 'dart:async';

import 'package:bubble_catch/view/home/widgets/button_game.dart';
import 'package:bubble_catch/view/home/widgets/player.dart';
import 'package:bubble_catch/view/home/widgets/shots.dart';
import 'package:bubble_catch/view/home/widgets/weapon_attack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Direction { left, right }

class _HomeScreenState extends State<HomeScreen> {
  // Cordinates for the direction
  static double xCordinate = 0;
  // Attack variables
  double weaponItemX = xCordinate;
  double weaponItemHeight = 10;
  bool midShot = false;
  // Attack item
  double shotX = 0.5;
  double shotY = 1;
  var shotDirection = Direction.left;
  // player life checking
  bool playerDies() {
    // if ball postion and player position are same player dies
    if ((shotX - xCordinate).abs() < 0.05 && shotY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

// Methods for moving the player
  // Right Direction
  void moveRight() {
    setState(() {
      if (xCordinate + 0.1 > 1) {
        // do nothing
      } else {
        xCordinate += 0.1;
      }
      if (!midShot) {
        weaponItemX = xCordinate;
      }
    });
  }

  void startGame() {
    double time = 0;
    double height = 0;

    Timer.periodic(const Duration(milliseconds: 5), (timer) {
      height = -5 * time * time + 60 * time;

      if (height < 0) {
        time = 0;
      }
      setState(() {
        shotY = heightToPosition(height);
      });
      if (shotX - 0.005 < -1) {
        shotDirection = Direction.right;
      } else if (shotX + 0.005 > 1) {
        shotDirection = Direction.left;
      }
      if (shotDirection == Direction.left) {
        setState(() {
          shotX -= 0.02;
        });
      } else if (shotDirection == Direction.right) {
        setState(() {
          shotX += 0.02;
        });
      }
      // check if ball hits player
      if (playerDies()) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.grey.withOpacity(0.5),
              title: const Text(
                'Game Over !',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      }
      time += 0.1;
    });
  }

  // Left Direction
  void moveLeft() {
    setState(() {
      if (xCordinate - 0.1 < -1) {
        // do nothing
      } else {
        xCordinate -= 0.1;
      }
      if (!midShot) {
        weaponItemX = xCordinate;
      }
    });
  }

  // Attack Object
  void attackObject() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;
        setState(() {
          weaponItemHeight += 10;
        });
        //  Stop the attack when it reach top of screen
        if (weaponItemHeight > MediaQuery.of(context).size.height * 3 / 4) {
          // stop attack
          resetAttack();
          timer.cancel();
        }
        // check if attack hits the target
        if (shotY > heightToPosition(weaponItemHeight) &&
            (shotX - weaponItemX).abs() < 0.03) {
          resetAttack();
          shotX = 5;
          timer.cancel();
        }
      });
    }
  }

  // height conversion to cordinates
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  // Reset Attack
  void resetAttack() {
    weaponItemX = xCordinate;
    weaponItemHeight = 0;
    midShot = false;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    Shots(shotX: shotX, shotY: shotY),
                    Weapon(
                      weaponItemHeight: weaponItemHeight,
                      weaponItemX: weaponItemX,
                    ),
                    Player(xCordinate: xCordinate),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ArrowButton(
                        icon: Icons.play_arrow,
                        function: startGame,
                      ),
                      ArrowButton(
                        function: moveLeft,
                        icon: Icons.arrow_back,
                      ),
                      ArrowButton(
                        function: attackObject,
                        icon: Icons.arrow_upward,
                      ),
                      ArrowButton(
                        function: moveRight,
                        icon: Icons.arrow_forward,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
