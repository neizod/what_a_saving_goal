import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'dashboard.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final DatabaseHandler _database = DatabaseHandler();
  var _profiles = [];

  @override
  void initState() {
    super.initState();
    getProfiles().whenComplete(() => setState((){}));
  }

  Future<void> getProfiles() async {
    _profiles = await _database.listProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(context),
        ),
      ),
    );
  }

  List<Card> _buildGridCards(BuildContext context) {
    return List.generate(
      _profiles.length,
      (int index) => Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            _database.indexProfile = index; // TODO use setter
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard(
                title: 'Dashboard: ${_profiles[index]}',
              )),
            );
          },
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18.0/11.0,
                child: Image.asset('assets/dummy-profile.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Text('${_profiles[index]}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
