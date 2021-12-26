import 'package:flutter/material.dart';

import 'database_handler.dart';


class NewProfile extends StatefulWidget {
  static const routeName = '/newProfile';
  @override
  _NewProfile createState() => _NewProfile();
}


class _NewProfile extends State<NewProfile> {
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
                  child: NewProfileForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NewProfileForm extends StatefulWidget {
  @override
  _NewProfileForm createState() => _NewProfileForm();
}


class _NewProfileForm extends State<NewProfileForm> {
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
