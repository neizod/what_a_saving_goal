import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'login.dart';
import 'misc.dart';


class ProfileCreation extends StatefulWidget {
  const ProfileCreation({Key? key, required this.profiles, this.profile=null}) : super(key: key);
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
  void dispose() {
    formController.forEach((_, value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [(widget.profile == null) ? const SizedBox() : deleteProfileButton(context)],
        title: (widget.profile == null) ? const Text('เพิ่มบัญชีใหม่') : const Text('แก้ไขบัญชี'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                nameField(),
                (widget.profile == null) ? currentField() : const Divider(),
                SizedBox(height: 20),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteProfileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_forever_rounded),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => confirmDeleteDialog(context),
      ).then((confirmed) => (confirmed) ? deleteProfile(context) : null),
    );
  }

  Widget confirmDeleteDialog(BuildContext context) {
    return AlertDialog(
      title: Text('ยืนยันการลบบัญชี'),
      content: Text('ต้องการลบบัญชี ${widget.profile!['name']} หรือไม่'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('ตกลง'),
        ),
      ],
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

  // Widget saveDeleteButton() {
  //   return Container(
  //     margin: EdgeInsets.all(10),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //           width: 100,
  //           child: ElevatedButton(
  //             child: const Text('ลบบัญชี'),
  //             style: ElevatedButton.styleFrom(
  //               primary: Colors.red
  //             ),
  //             onPressed: (){
  //               switch(widget.profile){
  //                 case null: createProfile(this.context); break;
  //                 default : updateProfile(this.context); break;
  //               }
  //             },
  //           ),
  //         ),
  //         Container(
  //           width: 100,
  //           child: ElevatedButton(
  //             child: const Text('บันทึก'),
  //             onPressed: (){
  //               switch(widget.profile){
  //                 case null: createProfile(this.context); break;
  //                 default : updateProfile(this.context); break;
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     )
  //   );
  // }  

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

  void createProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _database.createProfile(
        widget.profiles,
        name: formController['name']!.text,
        current: makeCurrencyInt(formController['current']!.text),
      ).whenComplete(() => Navigator.pop(context));
    }
  }

  void updateProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _database.updateProfile(
        widget.profile!,
        name: formController['name']!.text,
      ).whenComplete(() => Navigator.pop(context));
    }
  }

  void deleteProfile(BuildContext context) {
    _database.deleteProfile(
      widget.profiles,
      widget.profile!,
    ).whenComplete(() => Navigator.of(context)..pop()..pop());
  }
}
