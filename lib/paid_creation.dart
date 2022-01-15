import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_handler.dart';
import 'misc.dart';


class PaidCreation extends StatefulWidget {
  // TODO require more?
  const PaidCreation({Key? key, required this.goal, this.paid}): super(key: key);
  final Map goal;
  final Map? paid;

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
    if(widget.paid!=null){
      formController['price']!.text = makeCurrencyString(widget.paid!['amount']);
      makeDate(widget.paid!['date']);
    }
    else{
      makeDate(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เก็บออมเป้าหมาย'),
        actions: [
          IconButton(
            onPressed: ()=> (widget.paid==null) ? null: deleteTransactionAlert(),
           icon: const Icon(Icons.delete_forever_rounded),
           )
        ],
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
      onTap: (){
        var textFieldNum = formController['price']!.value.text;
        var numSanitized = makeCurrencyInt(textFieldNum)/100;
        debugPrint('Formatted ${numSanitized}');
        formController['price']!.value = TextEditingValue(
          text: numSanitized == 0 ? '' : '$numSanitized',
          selection: TextSelection.collapsed(offset: numSanitized == 0 ? 0 : '$numSanitized'.length)
        );
      },
      validator: refuse([empty('กรุณาระบุจำนวนเงิน')]),
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
          if(widget.paid == null){ //Create new paid transaction
            widget.goal['paids'].add({
              'amount': makeCurrencyInt(_price!.toString()),
              'date': _date!,
            });
          }
          else{
            widget.paid!['amount'] = makeCurrencyInt(_price!.toString());
            widget.paid!['date'] = _date!;
          }
          widget.goal['paids'].sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime)
          );
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

    void deleteTransactionAlert({String alertTitle='Delete Heading', String alertInformation='Init information'}){
    bool delete=false;
    showDialog(
      context: context, 
      builder: (BuildContext context) => 
        AlertDialog(
        title: Text(alertTitle),
        content: Text(alertInformation),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              }, 
            child: const Text("ยกเลิก")
          ),
          TextButton(onPressed: (){
            widget.goal['paids'].remove(widget.paid!);
            delete=true;
            _database.writeDatabase().whenComplete(() => Navigator.pop(context));
          }, 
          child: const Text("ตกลง")
          )
        ],
      )
    ).whenComplete(() {
      if(delete) Navigator.pop(context);
    });
  }
}
