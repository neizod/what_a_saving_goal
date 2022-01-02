import 'package:flutter/material.dart';

import 'database_handler.dart';


class AddProfile extends StatefulWidget {
  static const routeName = '/addProfile';
  @override
  _AddProfile createState() => _AddProfile();
}


class _AddProfile extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มบัญชีใหม่'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: AddProfileForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AddProfileForm extends StatefulWidget {
  @override
  _AddProfileForm createState() => _AddProfileForm();
}


class _AddProfileForm extends State<AddProfileForm> {
  final DatabaseHandler _database = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'profileName': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          TextFormField(
            controller: formController['profileName'],
            decoration: InputDecoration(
              labelText: 'ชื่อบัญชี',
            ),
          ),
          FloatingActionButton.extended(
            onPressed: (){
              setState((){});
              _database.addProfile(
                name: formController['profileName']?.text,
              );
              Navigator.pop(context);
            },
            label: Text('บันทึก'),
          ),
        ],
      ),
    );
  }
}
