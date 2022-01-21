import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:math';

Color playgroundcolor = Color(0xffaacc66);
Color snakecolor = Color(0xff272F17);
Widget AutoResizeText(String txt, String type,
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
