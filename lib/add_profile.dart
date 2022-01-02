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
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: AddProfileForm(),
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
    'name': TextEditingController(),
    'current': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          nameField(),
          currentField(),
          saveButton(),
        ],
      ),
    );
  }

  TextFormField nameField() {
    return TextFormField(
      controller: formController['name'],
      validator: (value) => ((value == null || value.isEmpty) ? 'กรุณากรอกชื่อ' : null),
      decoration: InputDecoration(
        labelText: 'ชื่อบัญชี',
      ),
    );
  }

  TextFormField currentField() {
    return TextFormField(
      controller: formController['current'],
      keyboardType: TextInputType.number,
      validator: (value) => ((value == null || value.isEmpty) ? 'กรุณากรอกยอดเงิน' : null),
      decoration: InputDecoration(
        labelText: 'ยอดเงินปัจจุบัน',
      ),
    );
  }

  FloatingActionButton saveButton() {
    return FloatingActionButton.extended(
      onPressed: (){
        if (_formKey.currentState!.validate()) {
          _database.addProfile(
            name: formController['name']?.text,
            current: formController['current']?.text,
          ).whenComplete(() => Navigator.pop(context));
        }
      },
      label: Text('บันทึก'),
    );
  }
}
