import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'database_handler.dart';
import 'login.dart';


void main() async {
  final database = DatabaseHandler();
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
  await database.init();
  runApp(MyApp(data: await database.fetchDatabase()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KebTang',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(profiles: data),
      //debugShowCheckedModeBanner: false,
    );
  }
}
