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
      title: 'What a Saving Goal',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
      /*
      routes: {
        // '/': (context) => const MyHomePage(title: 'Saving Goal Home Page'),
        // '/add_cash': (context) => AddCash(),
        AddGoal.routeName: (context) => AddGoal(),
        GoalInfo.routeName: (context) => GoalInfo(),
      },
      */
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}
