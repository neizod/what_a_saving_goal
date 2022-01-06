import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'profile_dashboard.dart';
import 'profile_creation.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.profiles}) : super(key: key);
  final List profiles;

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final DatabaseHandler _database = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เก็บตังค์'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.profiles.length + 1,
        itemBuilder: (BuildContext context, int index) => (
          (index < widget.profiles.length) ? _itemProfile(index) : _profileCreationButton()
        ),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _itemProfile(int index) {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('${widget.profiles[index]['name']}')),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => _routeToProfile(context, index),
      ),
    );
  }

  void _routeToProfile(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileDashboard(profile: widget.profiles[index])),
    ).whenComplete(() => setState((){}));
  }

  Widget _profileCreationButton() {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('เพิ่มผู้ใช้ใหม่')),
        splashColor: Colors.blue.withAlpha(30), // TODO theme primaryColor
        onTap: () => _routeToProfileCreation(context),
      ),
    );
  }

  void _routeToProfileCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileCreation(profiles: widget.profiles)),
    ).whenComplete(() => setState((){}));
  }
}
