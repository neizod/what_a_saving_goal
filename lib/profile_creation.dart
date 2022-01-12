import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'misc.dart';


class ProfileCreation extends StatefulWidget {
  const ProfileCreation({Key? key, required this.profiles, this.profile}) : super(key: key);
  final List profiles;
  final Map? profile;

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}


class _ProfileCreationState extends State<ProfileCreation> {
  final DatabaseHandler _database = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'current': TextEditingController(),
  };

  @override
  void initState(){
    super.initState();
    if (widget.profile != null) {
      formController['name']!.text = widget.profile!['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มบัญชีใหม่'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                nameField(),
                (widget.profile == null) ? currentField() : Divider() ,
                SizedBox(height: 20),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formController.forEach((_, value) => value.dispose());
    super.dispose();
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

  Widget saveButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('บันทึก'),
        onPressed: (){
          switch(widget.profile){
            case null: createProfile(this.context); break;
            default : updateProfile(this.context); break;
          }
        },
      ),
    );
  }

  void createProfile(BuildContext context){
    if (_formKey.currentState!.validate()) {
      Function.apply(
        _database.addProfile,
        [widget.profiles],
        formController.map((key, value) => MapEntry(Symbol(key), value.text)),
      ).whenComplete(() => Navigator.pop(context));
    }
  }

  void updateProfile(BuildContext context){
    debugPrint("In update profile function");
    if (_formKey.currentState!.validate()) {
      widget.profile!['name'] = formController['name']!.text;
      _database.writeDatabase().whenComplete(() => Navigator.pop(context));
    }
  }
}
