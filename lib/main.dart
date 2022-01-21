import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/services.dart';
import 'package:snake_game/SnakeGame.dart';
import 'package:snake_game/constant.dart';

/*
Todo issue:
  1. reset properly
*/
void main() {
  runApp(const MyApp());
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
        '/': (context) => SnakeIntro(),
        // '/sgame?s=speed': (context) => SnakeGame(title: title,speed: speed,),
      },
      // title: 'Flutter Demo',
      theme: ThemeData(
        // col
        // colorScheme: ColorScheme.dark(),

        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xff9BBA5A),
        backgroundColor: Color(0xff272F17),
      ),

      // home:
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Level(500, "Noob"),
              Level(300, "Boss"),
              Level(100, "Legend"),
            ],
          ),
        ),
      ),
    );
  }

  Widget Level(int speed, String title) {
    return FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SnakeGame(
                        title: "$title",
                        speed: speed,
                      )));
        },
        child: AutoResizeText("$title", "h1"));
  }
}
