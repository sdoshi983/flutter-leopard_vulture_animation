import 'styles.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: mainBlack,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
