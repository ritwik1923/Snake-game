import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:math';

Color backgroundColor = Color(0xff9BBA5A);
Color playgroundcolor = const Color(0xffaacc66);
Color snakecolor = const Color(0xff272F17);
Widget autoResizeText(String txt, String type,
    {bool op = true,
    int line = 8,
    TextAlign alignment = TextAlign.center,
    double mnfs = 12}) {
  return AutoSizeText(
    txt,
    style: TextStyle(
        color: op == true ? snakecolor : playgroundcolor,
        fontSize: type == 'h1' ? 30 : 20,
        fontFamily: "SourceCodePro",
        fontWeight: FontWeight.bold),
    minFontSize: mnfs,
    maxLines: line,
    // textAlign: tex,
    textAlign: alignment,
    overflow: TextOverflow.ellipsis,
  );
}

extension RandomInt on int {
  static int generate({int min = 0, required int max}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

Widget SnakeTitle() {
  return const AutoSizeText(
    "SNAKE GAME",
    maxLines: 2,
    style: TextStyle(
      fontFamily: 'SnakeGame',
      fontSize: 50,
    ),
    overflow: TextOverflow.ellipsis,
  );
}
