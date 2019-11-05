import 'package:flutter/material.dart';
import 'package:sytravelanimation/src/screens/main_page.dart';
import 'package:sytravelanimation/styles/styles.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: mainBlack,
      ),
      home: MainPage(),
    );
  }
}
