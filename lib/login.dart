import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'dashboard.dart';
import 'add_profile.dart';


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
    _database.listProfiles().then((result) => setState((){
      _profiles = result;
    }));
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
          (index < _profiles.length) ? itemProfile(index) : addProfile()
        ),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget itemProfile(int index) {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('${_profiles[index]['name']}')),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => routeProfile(context, index),
      ),
    );
  }

  void routeProfile(BuildContext context, int index) {
    _database.focusProfile(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(
        title: 'Dashboard: ${_profiles[index]['name']}',
      )),
    );
  }

  Widget addProfile() {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('เพิ่มผู้ใช้ใหม่')),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => routeAddProfile(context),
      ),
    );
  }

  void routeAddProfile(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProfile()),
    ).whenComplete(() => setState((){}));
  }
}
