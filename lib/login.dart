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
        centerTitle: true,
        title: Text('เก็บตังค์'),
      ),
      body: Column(
        children: [
          _coverImage(context),
          _profilesListView(context),
        ],
      ),
      // floatingActionButton: _populateExampleData(context),
    );
  }

  Widget _populateExampleData(BuildContext context) {
    return FloatingActionButton(
      child: (widget.profiles.length != 0) ? Icon(Icons.delete_forever) : Icon(Icons.assistant) ,
      onPressed: () => (
        (widget.profiles.length != 0) ? _database.clearAllData() : _database.populateExampleData()
      ).whenComplete(() => _database.fetchDatabase().then((data) => setState((){
        widget.profiles.clear();
        widget.profiles.addAll(data);
      }))),
    );
  }

  Widget _coverImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: FittedBox(
        child: Image.asset('assets/appfeature.png'),
      ),
    );
  }

  Widget _profilesListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: widget.profiles.length + 1,
        itemBuilder: _decisionBuildingItem,
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Widget _decisionBuildingItem(BuildContext context, int index) {
    if (index < widget.profiles.length) {
      return _profileItem(context, index);
    }
    return _profileCreationButton(context);
  }

  Widget _profileItem(BuildContext context, int index) {
    return Container(
      height: 50,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(60),
        onTap: () => _routeToProfile(context, index),
        child: Center(child: Text('${widget.profiles[index]['name']}')),
      ),
    );
  }

  Widget _profileCreationButton(BuildContext context) {
    return Container(
      height: 50,
      child: InkWell(
        child: Center(child: Text('เพิ่มผู้ใช้ใหม่')),
        splashColor: Theme.of(context).primaryColor.withAlpha(60),
        onTap: () => _routeToProfileCreation(context),
      ),
    );
  }

  void _routeToProfile(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileDashboard(profiles: widget.profiles, profile: widget.profiles[index])),
    ).whenComplete(() => setState((){}));
  }

  void _routeToProfileCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileCreation(profiles: widget.profiles, profile: null,)),
    ).whenComplete(() => setState((){}));
  }
}
