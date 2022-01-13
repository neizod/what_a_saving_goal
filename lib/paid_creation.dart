import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_handler.dart';
import 'misc.dart';


class PaidCreation extends StatefulWidget {
  // TODO require more?
  const PaidCreation({Key? key, required this.goal}): super(key: key);
  final Map goal;

  @override
  State<PaidCreation> createState() => _PaidCreationState();
}


class _PaidCreationState extends State<PaidCreation>{
  final DatabaseHandler _database = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'price': TextEditingController(),
    'date': TextEditingController(),
  };

  int? _price;
  DateTime? _date = null;

  @override
  void initState() {
    super.initState();
    formController['name']!.text = widget.goal['name'];
    makeDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เก็บออมเป้าหมาย'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: fuck(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formController.forEach((_, value) => value.dispose());
    super.dispose();
  }

  Widget fuck() { // TODO
    return Form(
      key: _formKey,
      child: Column(
        children: [
          nameField(),
          priceField(),
          dateField(),
          SizedBox(height: 20),
          saveButton(),
        ],
      ),
    );
  }

  TextFormField nameField() {
    return TextFormField(
      readOnly: true,
      controller: formController['name'],
      validator: refuse([empty('กรุณาระบุเป้าหมาย')]),
      decoration: InputDecoration(
        labelText: "เป้าหมาย",
      ),
    );
  }

  TextFormField priceField() {
    return TextFormField(
      controller: formController['price'],
      keyboardType: TextInputType.number,
      onChanged: (_) => extractFormValues(),
      validator: refuse([empty('กรุณาระบุจำนวนเงิน'), notInt('จำนวนเงินต้องเป็นจำนวนเต็ม')]),
      decoration: InputDecoration(
        labelText: "จำนวนเงิน",
      ),
    );
  }

  Widget dateField() {
    return TextFormField(
      readOnly: true,
      controller: formController['date'],
      onTap: () => pickDate(),
      validator: refuse([empty('กรุณาเลือกวันเริ่มต้น')]),
      decoration: InputDecoration(
        labelText: 'เก็บออมเมื่อ',
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      child: Text('เก็บออม'),
      onPressed: (){
        if (_formKey.currentState!.validate()) {
          widget.goal['paids'].add({
            'amount': makeCurrencyInt(_price!.toString()),
            'date': _date!,
          });
          _database.writeDatabase().whenComplete(() => Navigator.pop(context));
        }
      },
    );
  }

  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2120),
    ).then((date) {
      makeDate(date);
    });
  }

  void makeDate(DateTime? date) {
    _date = date;
    formController['date']!.text = (date == null) ? '' : DateFormat('d/MMM/y').format(date);
  }

  void extractFormValues() {
    _price = int.tryParse(formController['price']?.text ?? '');
  }
}
