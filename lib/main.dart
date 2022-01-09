import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late int line = 35;
  late int per_col = 20;
  List<int> snake = [5, 25, 45, 65, 85, 105, 125];
  void snake_length(int len) {
    for (int i = 0; i < len; ++i) snake.add(snake[snake.length - 1] + 20);
  }

  bool down = true;
  bool left = true;
  double b = 50;
  String pre_move = "d";
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("${MediaQuery.of(context).size.height}"),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 500,
                minWidth: 400,
              ),
              // color: Colors.amber,
              // height: h - 150,
              // width: w,
              child: Center(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: per_col),
                    itemCount: line * per_col,
                    itemBuilder: (BuildContext ctx, index) {
                      return FittedBox(
                        fit: BoxFit.fill,
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: snake.contains(index)
                                    ? Colors.pink
                                    : Colors.white70,
                                child: Text("$index"),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Positioned(
            right: b,
            bottom: b,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: b,
                      width: b,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          upmove();
                        });
                      },
                      child: Container(
                        color: Colors.amber,
                        height: b,
                        width: b,
                      ),
                    ),
                    Container(
                      height: b,
                      width: b,
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          leftmove();
                        });
                      },
                      child: Container(
                        color: Colors.amber,
                        height: b,
                        width: b,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          snake_length(15);
                        });
                      },
                      child: Container(
                        height: b,
                        width: b,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rightmove();
                        });
                      },
                      child: Container(
                        color: Colors.amber,
                        height: b,
                        width: b,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: b,
                      width: b,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          downmove();
                        });
                      },
                      child: Container(
                        color: Colors.amber,
                        height: b,
                        width: b,
                      ),
                    ),
                    Container(
                      height: b,
                      width: b,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void print_snake() {
    debugPrint("============\n ");
    // for (int i = 0; i < snake.length; ++i)
    debugPrint("${snake} ");
    debugPrint("\n============\n ");
  }

  void upmove() {
    if (pre_move == 'd') return;
    // if (down) return;
    debugPrint(pre_move);
    print_snake();
    down = false;

    debugPrint("${snake[0] - 20}");
    snake.insert(snake.length, (snake[snake.length - 1] - 20) % 700);
    snake.removeAt(0);
    print_snake();
    pre_move = "u";
  }

  void downmove() {
    // if (!down) return;
    if (pre_move == 'u') return;
    debugPrint(pre_move);
    print_snake();
    down = true;
    debugPrint("${20 + snake[snake.length - 1]}");
    snake.removeAt(0);
    snake.insert(snake.length, (20 + snake[snake.length - 1]) % 700);
    print_snake();
    pre_move = "d";
  }

  void leftmove() {
    if (pre_move == 'r') return;
    // if (!left) return;
    debugPrint(pre_move);
    print_snake();
    if (down) {
      debugPrint("${-1 + snake[snake.length - 1]}");
      snake.removeAt(0);
      if ((snake[snake.length - 1] - 1) % 20 != 0)
        snake.insert(snake.length, (-1 + snake[snake.length - 1]));
      else
        snake.insert(snake.length, (-1 + snake[snake.length - 1] - 20));
    } else {
      debugPrint("${-1 + snake[0]}");
      snake.removeAt(0);
      if ((snake[0] + -1) % 20 != 0)
        snake.insert(snake.length, (-1 + snake[snake.length - 1]));
      else
        snake.insert(snake.length, (-1 + snake[snake.length - 1] - 20));
    }
    print_snake();
    pre_move = "l";
    left = true;
  }

  void rightmove() {
    if (pre_move == 'l') return;
    debugPrint(pre_move);
    print_snake();
    /*
     !left is moving left before
     than add before snake 
     else add end of snake.
    */
    if (down) {
      debugPrint("${1 + snake[snake.length - 1]}");
      snake.removeAt(0);
      if ((snake[snake.length - 1] + 1) % 20 != 0)
        snake.insert(snake.length, (1 + snake[snake.length - 1]));
      else
        snake.insert(snake.length, (1 + snake[snake.length - 1] - 20));
    } else {
      debugPrint("${1 + snake[0]}");
      snake.removeAt(0);
      if ((snake[0] + 1) % 20 != 0)
        snake.insert(snake.length, (1 + snake[snake.length - 1]));
      else
        snake.insert(snake.length, (1 + snake[snake.length - 1] - 20));
    }
    left = false;
    print_snake();
    pre_move = "r";
  }
}
