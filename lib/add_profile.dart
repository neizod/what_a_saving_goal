import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'misc.dart';


class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}


class _AddProfileState extends State<AddProfile> {
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
  _AddProfileFormState createState() => _AddProfileFormState();
}


class _AddProfileFormState extends State<AddProfileForm> {
  final DatabaseHandler _database = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'current': TextEditingController(),
  };

  @override
  void dispose() {
    formController.forEach((_, value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          nameField(),
          currentField(),
          SizedBox(height: 20),
          saveButton(),
        ],
      ),
    );
  }

  TextFormField nameField() {
    return TextFormField(
      controller: formController['name'],
      validator: refuse([empty('กรุณากรอกชื่อ')]),
      decoration: InputDecoration(
        labelText: 'ชื่อบัญชี',
      ),
    );
  }

  TextFormField currentField() {
    return TextFormField(
      controller: formController['current'],
      keyboardType: TextInputType.number,
      validator: refuse([empty('กรุณากรอกยอดเงิน'), notInt('ยอดเงินต้องเป็นจำนวนเต็ม')]),
      decoration: InputDecoration(
        labelText: 'ยอดเงินปัจจุบัน',
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      child: Text('บันทึก'),
      onPressed: (){
        if (_formKey.currentState!.validate()) {
          Function.apply(
            _database.addProfile,
            [],
            formController.map((key, value) => MapEntry(Symbol(key), value.text)),
          ).whenComplete(() => Navigator.pop(context));
        }
      },
    );
  }
}
