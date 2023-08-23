import 'dart:async';
import 'dart:developer' as dev;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacmangame/screens/path.dart';
import 'package:pacmangame/screens/pixel.dart';
import 'package:pacmangame/screens/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static int numberInRow = 11;
    int numberOfSquare = numberInRow * 17;
  bool mouthClosed = false;
  bool preGame = true;
  int player = numberInRow * 15 + 1;
  int ghost = numberInRow * 2 - 2;

  static List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    88,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    175,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    164,
    153,
    142,
    131,
    120,
    109,
    98,
    87,
    76,
    65,
    54,
    43,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160
  ];
  List<int> food = [];
  int score = 0;
  String direction = "right";
  void startGame() {
    getFood();
    preGame = false;
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }
      switch (direction) {
        case "left":
          moveLeft();
          break;

        case "right":
          moveRight();
          break;
        case "Up":
          moveUp();
          break;
        case "Down":
          moveDown();
          break;
      }
    });
  }

  void getFood() {
    for (int i = 0; i < numberOfSquare; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    direction = "Down";
                  } else if (details.delta.dy < 0) {
                    direction = "Up";
                  }
                  dev.log(direction);
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    direction = "right";
                  } else if (details.delta.dx < 0) {
                    direction = "left";
                  }
                  dev.log(direction);
                },
                child: Container(
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numberInRow),
                        itemCount: numberOfSquare,
                        itemBuilder: (BuildContext context, int index) {
                          if (mouthClosed && player == index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow,
                                ),
                              ),
                            );
                          } else if (player == index) {
                            switch (direction) {
                              case 'left':
                                return Transform.rotate(
                                  angle: pi,
                                  child: Player(),
                                );
                                break;
                              case 'right':
                                return Player();
                                break;
                              case 'Up':
                                return Transform.rotate(
                                  angle: 3 * pi / 2,
                                  child: Player(),
                                );
                                break;
                              case 'Down':
                                return Transform.rotate(
                                  angle: pi / 2,
                                  child: Player(),
                                );
                                break;
                              default:
                                Player();
                            }
                          } else if (barriers.contains(index)) {
                            return Pixel(
                              innercolor: Colors.blue.shade800,
                              outercolor: Colors.blue.shade900,
                            );
                          } else {
                            if (food.contains(index) || preGame) {
                              return MyPath(
                                innercolor: Colors.yellow[900]!,
                                outercolor:
                                    const Color.fromARGB(255, 51, 45, 45),
                              );
                            } else {
                              return MyPath(
                                innercolor: Colors.black,
                                outercolor: Colors.black,
                              );
                            }
                          }
                        })),
              ),
            ),
            Expanded(
                child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: Text(
                      "P L A Y",
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
