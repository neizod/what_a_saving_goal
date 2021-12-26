import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'dashboard.dart';
import 'new_profile.dart';


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
      appBar: AppBar(
        title: const Text('เก็บตังค์'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _profiles.length + 1,
        itemBuilder: (BuildContext context, int index) => (
            index < _profiles.length ? itemProfile(index) : newProfile()
        ),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget itemProfile(int index) {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('${_profiles[index % _profiles.length]}')),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => routeProfile(context, index),
      ),
    );
  }

  void routeProfile(BuildContext context, int index) {
    _database.indexProfile = index; // TODO use setter
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(
        title: 'Dashboard: ${_profiles[index]}',
      )),
    );
  }

  Widget newProfile() {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('เพิ่มผู้ใช้ใหม่')),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => routeNewProfile(context),
      ),
    );
  }

  void routeNewProfile(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewProfile()),
    );
    setState((){});
  }
}
