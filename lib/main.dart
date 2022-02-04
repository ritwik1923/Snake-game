import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/services.dart';
import 'package:snake_game/SnakeGame.dart';
import 'package:snake_game/constant.dart';
import 'package:snake_game/db.dart';

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
  Map<String, dynamic>? gs;
  Timer? ff;
  void initState() {
    // TODO: implement initState
    super.initState();
    ff = Timer.periodic(Duration(milliseconds: 1000), foo);
    // doSomeAsyncStuff();
  }

  @override
  void dispose() {
    super.dispose();
    ff?.cancel();
  }

  bool f = true;
  Future<void> doSomeAsyncStuff() async {
    gs = await game_score();
  }

  void foo(Timer timer) async {
    f = !f;
    gs = await game_score();
    setState(() {
      gs = gs;
    });
    debugPrint("gs: $gs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: doSomeAsyncStuff(),
            builder: (context, snapshot) {
              if (gs == null) {
                // Future hasn't finished yet, return a placeholder
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text("$f"),
                        Level(gs!["noob"]["speed"], "Noobs",
                            gs!["noob"]["score"]),
                        Level(
                            gs!["boss"]["speed"], "Boss", gs!["boss"]["score"]),
                        Level(gs!["legend"]["speed"], "Legend",
                            gs!["legend"]["score"]),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Widget Level(int speed, String title, int score) {
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
        child: Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoResizeText("$title", "h1"),
              AutoResizeText("$score", "h1"),
            ],
          ),
        ));
  }
}
