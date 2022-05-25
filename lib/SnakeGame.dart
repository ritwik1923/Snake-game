// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/extra/constant.dart';
import 'package:snake_game/db.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key, required this.title, required this.speed})
      : super(key: key);

  final int speed;
  final String title;

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  late Timer snakeMove;
  late Timer foodAnimation;
  bool fa = true;
  late List<int> snakeIn, snake;

  int lines = 15;
  late int perCol = 20;

  bool down = true;
  bool left = true;
  double b = 50;
  String preMove = "d";
  String move = "d";
  late int food;
  snakeReset(Timer timer) {
    setState(() {
      if (move == 'u') {
        if (preMove != 'd') {
          upmove();
        } else {
          downmove();
        }
      } else if (move == 'd') {
        if (preMove != 'u') {
          downmove();
        } else {
          upmove();
        }
      } else if (move == 'r') {
        if (preMove != 'l') {
          rightmove();
        } else {
          leftmove();
        }
      } else if (move == 'l') {
        if (preMove != 'r') {
          leftmove();
        } else {
          rightmove();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("${widget.speed}");
    snake = [
      5,
      25,
      45,
      65,
    ];

    snakeIn = [...snake];

    // defines a timer
    snakeMove =
        Timer.periodic(Duration(milliseconds: widget.speed), snakeReset);
    var oneSec = const Duration(seconds: 1);
    foodAnimation = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        fa = !fa;
      });
    });
    foodGenrator();
  }

  @override
  void dispose() {
    super.dispose();
    foodAnimation.cancel();
    snakeMove.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double sh = 10;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            debugPrint("right");
            move = 'r';
            // Right Swipe
          } else if (details.delta.dx < -sensitivity) {
            //Left Swipe
            debugPrint("left");
            move = 'l';
          }
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            // Down Swipe
            move = 'd';
            debugPrint("down");
          } else if (details.delta.dy < -sensitivity) {
            // Up Swipe
            move = 'u';
            debugPrint("up");
          }
        });
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          setState(() {
            if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
              move = 'd';
            } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
              move = 'u';
            } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              move = 'r';
            } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              move = 'l';
            }
          });
        },
        child: Scaffold(
          // backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: snakecolor,
              // tooltip: 'Increase volume by 10',
              onPressed: () {
                dbAddScore(snake.length - 4, widget.title);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            elevation: 0,

            backgroundColor: backgroundColor,
            // iconTheme: IconThemeData(color: snakecolor),
          ),
          // Todo gesture cotrol
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SnakeTitle(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Score : ${snake.length - 4}",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2 * sh,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 10,
                      color: snakecolor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    // color: Colors.pink,
                  ),
                  height: 25 * 15,
                  width: 500,
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: perCol),
                      itemCount: lines * perCol,
                      itemBuilder: (BuildContext ctx, index) {
                        // debugPrint("fa: $fa");
                        return Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: boxColor(index),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: sh,
                ),
                Container(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                          // height: 75,
                          color: snakecolor,
                          onPressed: () {
                            reSet();
                          },
                          child: autoResizeText("Reset", "h2", op: false)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2 * sh,
                ),
                Center(
                    child: AutoSizeText(
                  "Use arrow key to move the snake",
                  maxLines: 5,
                  style: TextStyle(
                    // fontFamily: 'SnakeGame',
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void printSnake() {
    // return;
    debugPrint("============\n ");
    debugPrint("$snake ");
    debugPrint("\n============\n ");
  }

  Color boxColor(int index) {
    bool b = snake.contains(index);
    if (b || index == food) {
      if (snake.contains(food)) {
        debugPrint("$index");
        printSnake();
        // Todo: add tail after eatting food
        int l = snake[0];
        snake.insert(0, l);
        printSnake();
        foodGenrator();

        // return Colors.amber;
      }
      if (index == food) {
        if (fa == true) return Colors.amber;
        return Colors.red;
      }
      return snakecolor;
    } else {
      return backgroundColor;
    }
  }

  void foodGenrator() {
    int f = RandomInt.generate(max: (lines * perCol));
    while (snake.contains(f)) {
      debugPrint("f $f");
      f = RandomInt.generate(max: (lines * perCol));
    }
    food = f;
  }

  void reSet() {
    setState(() {
      dbAddScore(snake.length - 4, widget.title);
      debugPrint("restting after game over...");
      debugPrint("$snakeIn");
      preMove = "d";
      move = "d";
      snake = [...snakeIn];
      debugPrint("$snake");

      foodGenrator();
      if (snakeMove != null) snakeMove.cancel();
      snakeMove =
          Timer.periodic(Duration(milliseconds: widget.speed), snakeReset);
    });
  }

// ignore: todo
// DONE TODO: better impliment stopsnake  restart
  void sTopSnake() {
    setState(() {
      // ? print("done")
      // : print("failed");
      // snakeMove.
      snakeMove.cancel();
      int per_col = 20;
      int lines = 15;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: playgroundcolor,
          title: const Text(
            'Game Over!',
            style: TextStyle(
              fontFamily: 'SnakeGame',
              fontSize: 25,
            ),
          ),
          content: Text('Your Score : ${snake.length - 4}'),
          actions: <Widget>[
            TextButton(
              // Todo: pause timmer
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                reSet();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: snakecolor),
              ),
            ),
            TextButton(
              onPressed: () {
                // Todo: reset all after game over
                dbAddScore(snake.length - 4, widget.title);
                Navigator.popUntil(context, ModalRoute.withName('/'));
                // Navigator.pop(context, 'OK');
                // Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(color: snakecolor),
              ),
            ),
          ],
        ),
      );
    });
  }

  void upmove() {
    if (preMove == 'd') return;

    // printSnake();
    down = false;

    // debugPrint("${snake[0] - 20}");
    int index = (snake[snake.length - 1] - 20) % (lines * perCol);
    if (snake.contains(index)) {
      sTopSnake();
      return;
    }
    snake.insert(snake.length, index);
    snake.removeAt(0);
    // printSnake();
    preMove = "u";
  }

  void downmove() {
    // if (!down) return;
    if (preMove == 'u') return;
    // debugPrint(preMove);
    // printSnake();
    down = true;
    int index = (20 + snake[snake.length - 1]) % (lines * perCol);
    if (snake.contains(index)) {
      sTopSnake();
      return;
    }
    // debugPrint("${20 + snake[snake.length - 1]}");
    snake.removeAt(0);
    snake.insert(snake.length, index);
    // printSnake();
    preMove = "d";
  }

  void leftmove() {
    if (preMove == 'r') return;
    // if (!left) return;
    // debugPrint(preMove);
    // printSnake();
    // if (down) {
    // debugPrint("${-1 + snake[snake.length - 1]}");
    snake.removeAt(0);
    if ((snake[snake.length - 1]) % 20 != 0) {
      int index = (-1 + snake[snake.length - 1]);
      if (snake.contains(index)) {
        sTopSnake();
        return;
      }
      snake.insert(snake.length, index);
    } else {
      debugPrint("\t20 at last ${snake[snake.length - 1]}");
      int index = (-1 + snake[snake.length - 1] + 20);
      if (snake.contains(index)) {
        sTopSnake();
        return;
      }
      snake.insert(snake.length, index);
    }

    preMove = "l";
    left = true;
  }

  void rightmove() {
    if (preMove == 'l') return;
    // debugPrint(preMove);
    // printSnake();
    /*
     !left is moving left before
     than add before snake 
     else add end of snake.
    */

    snake.removeAt(0);
    if ((snake[snake.length - 1] + 1) % 20 != 0) {
      int index = (1 + snake[snake.length - 1]);
      if (snake.contains(index)) {
        sTopSnake();
        return;
      }
      snake.insert(snake.length, index);
    } else {
      debugPrint("\t20 at last ${snake[snake.length - 1]}");
      int index = (1 + snake[snake.length - 1] - 20);
      if (snake.contains(index)) {
        sTopSnake();
        return;
      }
      snake.insert(snake.length, index);
    }

    left = false;
    // printSnake();
    preMove = "r";
  }
}
