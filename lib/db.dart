import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level {
  final String title;
  final int speed;
  final int max_score_till_now;
  Level(this.title, this.speed, this.max_score_till_now);
}

String game = 'snake_game';
// List<String> snake_game = ["nood",];

Future<Map<String, dynamic>> game_score() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(game)) {
    db_init();
  }
  String? userPref = prefs.getString(game);
  // debugPrint("sending data: ${userPref}");

  return jsonDecode(userPref!) as Map<String, dynamic>;
}

Future<bool> db_init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> user = {
    "noob": {"speed": 500, "score": 0},
    "boss": {"speed": 300, "score": 0},
    "legend": {"speed": 100, "score": 0}
  };
  debugPrint("data: ${user["noob"]["speed"]}");

  return await prefs.setString(game, jsonEncode(user));
}

Future<bool> db_add_score(int score, String level) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userPref = prefs.getString(game);
  debugPrint("data: $userPref");
  Map<String, dynamic> userMap = jsonDecode(userPref!) as Map<String, dynamic>;
  debugPrint("data map: $userMap");
  if (userMap[level.toLowerCase()]["score"] < score)
    userMap[level.toLowerCase()]["score"] = score;
  debugPrint("data map added: $userMap");
  return await prefs.setString(game, jsonEncode(userMap));
}
