import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'login.dart';


void main() async {
  var database = DatabaseHandler();
  await database.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KebTang',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
      //debugShowCheckedModeBanner: false,
    );
  }
}
