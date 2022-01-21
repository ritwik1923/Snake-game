import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/constant.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key, required this.title, required this.speed})
      : super(key: key);

  final int speed;
  final String title;

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  late String _now;
  late Timer snake_move;
  late Timer food_animation;
  bool fa = true;
  late List<int> snake_in, snake;

  int _counter = 0;
  late int line = 20;
  late int per_col = 20;
  // late List<int> food_loc;

  bool down = true;
  bool left = true;
  double b = 50;
  String pre_move = "d";
  String move = "d";
  late int food;
  snake_reset(Timer timer) {
    setState(() {
      if (move == 'u') {
        if (pre_move != 'd')
          upmove();
        else
          downmove();
      } else if (move == 'd') {
        if (pre_move != 'u')
          downmove();
        else
          upmove();
      } else if (move == 'r') {
        if (pre_move != 'l')
          rightmove();
        else
          leftmove();
      } else if (move == 'l') {
        if (pre_move != 'r')
          leftmove();
        else
          rightmove();
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

    snake_in = [
      5,
      25,
      45,
      65,
    ];

    // defines a timer
    snake_move =
        Timer.periodic(Duration(milliseconds: widget.speed), snake_reset);
    var oneSec = Duration(seconds: 1);
    food_animation = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (fa == true)
          fa = false;
        else
          fa = true;
        // fa != fa;
      });
    });
    // Timer.periodic(Duration(milliseconds: widget.speed), );
    foodGenrator();
  }

  @override
  void dispose() {
    super.dispose();
    food_animation.cancel();
    snake_move.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
// RawKeyboardListener(
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

          // Todo gesture cotrol
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 500,
                minWidth: 400,
              ),
              // color: Colors.amber,
              // width: w,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h / 6,
                    ),
                    Expanded(
                      // height: (line + 2) * per_col * 1.00,
                      child: Container(
                        // color: Colors.pink,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: per_col),
                            itemCount: line * per_col,
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
                                      // child: index == food
                                      //     ? fa == true
                                      //         ? Text("#")
                                      //         : Text(" ")
                                      //     : null,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      // height: 75,
                      // color: Colors.pink,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.,
                        children: [
                          Expanded(
                              flex: 5,
                              // height: 75,
                              child: Center(
                                child: AutoResizeText(
                                    "Your Score : ${snake.length - 4}", 'h2'),
                              )),
                          Expanded(
                              flex: 2,
                              child: FlatButton(
                                  // height: 75,
                                  color: snakecolor,
                                  onPressed: () {
                                    sTopSnake();
                                  },
                                  child: AutoResizeText("Reset", "h2",
                                      op: false))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h / 9,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  void print_snake() {
    // return;
    debugPrint("============\n ");
    debugPrint("${snake} ");
    debugPrint("\n============\n ");
  }

  Color boxColor(int index) {
    bool b = snake.contains(index);
    if (b || index == food) {
      if (snake.contains(food)) {
        debugPrint("$index");
        print_snake();
        // Todo: add tail after eatting food
        int l = snake[0];
        snake.insert(0, l);
        print_snake();
        foodGenrator();

        // return Colors.amber;
      }
      if (index == food) {
        if (fa == true) return Colors.amber;
        return Colors.red;
      }
      return snakecolor;
    } else
      return playgroundcolor;
  }

  void foodGenrator() {
    int f = RandomInt.generate(max: (line * per_col));
    while (snake.contains(f)) {
      debugPrint("f $f");
      f = RandomInt.generate(max: (line * per_col));
    }
    food = f;
  }

  void reSet() {
    setState(() {
      debugPrint("restting after game over...");
      snake.clear();
      debugPrint("${snake_in}");

      snake = snake_in;
      food = 0;
      // foodGenrator();
      snake_move =
          Timer.periodic(const Duration(milliseconds: 1000), snake_reset);
    });
  }

// TODO: better impliment stopsnake  restart
  void sTopSnake() {
    setState(() {
      // snake_move.
      snake_move.cancel();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: playgroundcolor,
          title: Text(
            'Game Over',
          ),
          content: Text('Your Score : ${snake.length - 4}'),
          actions: <Widget>[
            TextButton(
              // Todo: pause timmer
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: TextStyle(color: snakecolor),
              ),
            ),
            TextButton(
              onPressed: () {
                // Todo: reset all after game over
                Navigator.popUntil(context, ModalRoute.withName('/'));
                // reSet();
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
    if (pre_move == 'd') return;

    // print_snake();
    down = false;

    // debugPrint("${snake[0] - 20}");
    int index = (snake[snake.length - 1] - 20) % (line * per_col);
    if (snake.contains(index)) {
      sTopSnake();
      return;
    }
    snake.insert(snake.length, index);
    snake.removeAt(0);
    // print_snake();
    pre_move = "u";
  }

  void downmove() {
    // if (!down) return;
    if (pre_move == 'u') return;
    // debugPrint(pre_move);
    // print_snake();
    down = true;
    int index = (20 + snake[snake.length - 1]) % (line * per_col);
    if (snake.contains(index)) {
      sTopSnake();
      return;
    }
    // debugPrint("${20 + snake[snake.length - 1]}");
    snake.removeAt(0);
    snake.insert(snake.length, index);
    // print_snake();
    pre_move = "d";
  }

  void leftmove() {
    if (pre_move == 'r') return;
    // if (!left) return;
    // debugPrint(pre_move);
    // print_snake();
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

    pre_move = "l";
    left = true;
  }

  void rightmove() {
    if (pre_move == 'l') return;
    // debugPrint(pre_move);
    // print_snake();
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
    // print_snake();
    pre_move = "r";
  }
}
