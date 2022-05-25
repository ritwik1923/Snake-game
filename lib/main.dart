// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:snake_game/SnakeGame.dart';
import 'package:snake_game/extra/constant.dart';
import 'package:snake_game/db.dart';
import 'package:snake_game/grid.dart';

/*
Todo issue:
  1. reset properly
*/
void main() {
  runApp(const MyApp());
  // db_init();
}

// COnstant

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => const SnakeIntro(),
        // '/sgame?s=speed': (context) => SnakeGame(title: title,speed: speed,),
      },
      // title: 'Flutter Demo',
      theme: ThemeData(
        // col
        // colorScheme: ColorScheme.dark(),

        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: backgroundColor,
        backgroundColor: const Color(0xff272F17),
      ),
      // home: const GridMake()
      // SnakeIntro()
      // RopSayac(),
      // SnakeGame(title: 'Flutter Demo Home Page', speed: 200),
    );
  }
}

class SnakeIntro extends StatefulWidget {
  const SnakeIntro({Key? key}) : super(key: key);

  @override
  _SnakeIntroState createState() => _SnakeIntroState();
}

class _SnakeIntroState extends State<SnakeIntro> {
  Map<String, dynamic>? gs;
  Timer? ff;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    ff = Timer.periodic(const Duration(milliseconds: 1000), foo);
    // doSomeAsyncStuff();
  }

  @override
  void dispose() {
    super.dispose();
    ff?.cancel();
  }

  bool f = true;
  Future<void> doSomeAsyncStuff() async {
    gs = await gameScore();
  }

  void foo(Timer timer) async {
    f = !f;
    gs = await gameScore();
    setState(() {
      gs = gs;
    });
    debugPrint("gs: $gs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: doSomeAsyncStuff(),
            builder: (context, snapshot) {
              if (gs == null) {
                // Future hasn't finished yet, return a placeholder
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SnakeTitle(),
                      SizedBox(
                        height: 20,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text("$f"),

                            level(gs!["noob"]["speed"], "Noob",
                                gs!["noob"]["score"]),
                            level(gs!["boss"]["speed"], "Boss",
                                gs!["boss"]["score"]),
                            level(gs!["legend"]["speed"], "Legend",
                                gs!["legend"]["score"]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }

// different level in game
  Widget level(int speed, String title, int score) {
    return FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SnakeGame(
                        title: title,
                        speed: speed,
                      )));
        },
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              autoResizeText(title, "h1"),
              autoResizeText("$score", "h1"),
            ],
          ),
        ));
  }
}
