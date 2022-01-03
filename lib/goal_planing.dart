import 'package:flutter/material.dart';

import 'database_handler.dart';
import 'misc.dart';


// rename
class GoalPlaning extends StatefulWidget {
  @override
  _GoalPlaningState createState() => _GoalPlaningState();
}


class _GoalPlaningState extends State<GoalPlaning>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วางแผนการออม'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: GoalPlaningForm(),
        ),
      ),
    );
  }
}


// rename to AddGoal
class GoalPlaningForm extends StatefulWidget {
  @override
  _GoalPlaningForm createState() => _GoalPlaningForm();
}


class _GoalPlaningForm extends State<GoalPlaningForm> {
  final DatabaseHandler _database = DatabaseHandler();
  DateTime? _startdate = null;
  DateTime? _enddate = null;
  String installmentType = 'week';
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'price': TextEditingController(),
    'num_period': TextEditingController(),
    'per_period': TextEditingController(),
    'start_date': TextEditingController(),
    'end_date': TextEditingController(),
  };
  final Map typeToDays = {
    'week': 7,
    'month': 30,
    'year': 365,
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
          priceField(),
          SizedBox(height: 20),
          installmentField(),
          perInstallmentField(),
          SizedBox(height: 20),
          startDateField(),
          endDateField(),
          SizedBox(height: 20),
          saveButton(),
        ],
      ),
    );
  }

  TextFormField nameField() {
    return TextFormField(
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
      validator: refuse([empty('กรุณาระบุจำนวนเงิน'), notInt('จำนวนเงินต้องเป็นจำนวนเต็ม')]),
      decoration: InputDecoration(
        labelText: "จำนวนเงิน",
      ),
    );
  }

  Widget installmentField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: formController['num_period'],
            onChanged: (string){
              int duration = int.parse(formController['num_period']!.text);
              int price = int.parse(formController['price']!.text);
              int priceInstallment = (price/duration).ceil();
              int day_duration = typeToDays[installmentType]*duration;
              _enddate = _startdate!.add(Duration(days: day_duration));
              formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
              formController['per_period']!.text = priceInstallment.toString();
              setState(() {
              });
            },
            keyboardType: TextInputType.number,
            focusNode: (formController['price']!.text.isEmpty) ? new DisabledFocusNode() : null,
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณาระบุจำนวนงวด' : null;
            },
            decoration: InputDecoration(
              labelText: "จำนวนงวด",
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              installmentType = 'week';
              if(_startdate!=null && formController['num_period']!.text.isNotEmpty){
                int duration = int.parse(formController['num_period']!.text);
                int day_duration = typeToDays[installmentType]*duration;
                _enddate = _startdate!.add(Duration(days: day_duration));
                formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
              }
            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
            ),
            child: Text("สัปดาห์",
              style: TextStyle(
                color: installmentType=='week' ? Colors.red : Colors.black),
              ),
          )
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              installmentType = 'month';
              if(_startdate!=null && formController['num_period']!.text.isNotEmpty){
                int duration = int.parse(formController['num_period']!.text);
                int day_duration = typeToDays[installmentType]*duration;
                _enddate = _startdate!.add(Duration(days: day_duration));
                formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
              }
            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
            ),
            child: Text("เดือน",
              style: TextStyle(
                color: installmentType=='month' ? Colors.red : Colors.black),
              ),
          )
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              installmentType = 'year';
              if(_startdate!=null && formController['num_period']!.text.isNotEmpty){
                int duration = int.parse(formController['num_period']!.text);
                int day_duration = typeToDays[installmentType]*duration;
                _enddate = _startdate!.add(Duration(days: day_duration));
                formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
              }
            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
            ),
            child: Text("ปี",
              style: TextStyle(
                color: installmentType=='year' ? Colors.red : Colors.black),
              ),
          )
        ),
      ],
    );
  }

  Widget perInstallmentField() {
    return TextFormField(
      onChanged: (string){
        int priceInstallment = int.parse(formController['per_period']!.text);
        int price = int.parse(formController['price']!.text);
        int duration = (price/priceInstallment).ceil();
        int day_duration = typeToDays[installmentType]*duration;
        _enddate = _startdate!.add(Duration(days: day_duration));
        formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
        formController['num_period']!.text = duration.toString();
        setState(() {});
      },
      controller: formController['per_period'],
      keyboardType: TextInputType.number,
      focusNode: (formController['price']!.text.isEmpty) ? new DisabledFocusNode() : null,
      validator: (value) {
        return (value == null || value.isEmpty) ? 'กรุณาระบุจำนวนเงินต่องวด' : null;
      },
      decoration: InputDecoration(
        labelText: "จำนวนเงินต่องวด",
      ),
    );
  }

  Widget startDateField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            focusNode: new DisabledFocusNode(),
            controller: formController['start_date'],
            validator: (_) {
              return _startdate == null ? 'กรุณาเลือกวันเริ่มต้น' : null;
            },
            decoration: InputDecoration(
              labelText: 'กำหนดวันเริ่มต้นออม',
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              ).then((date) {
                setState(() {
                  _startdate = date;
                  formController['start_date']!.text = '${_startdate?.day}-${_startdate?.month}-${_startdate?.year}';
                });
              });
          },
          icon: Icon(Icons.calendar_today),
        ),
      ],
    );
  }

  Widget endDateField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: formController['end_date'],
            focusNode: new DisabledFocusNode(),
            validator: (value) {
              return _enddate == null ? 'กรุณาเลือกวันสิ้นสุด' : null;
            },
            decoration: InputDecoration(
              labelText: 'วันสิ้นสุดการออม',
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              ).then((date) {
                setState(() {
                  _enddate = date;
                  int day_duration = _enddate!.difference(_startdate!).inDays;
                  int duration = (day_duration/typeToDays[installmentType]).ceil();
                  double priceInstallment = double.parse(formController['price']!.text)/duration;
                  formController['end_date']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
                  formController['num_period']!.text = duration.toString();
                  formController['per_period']!.text = priceInstallment.toString();
                });
              });
          },
          icon: Icon(Icons.calendar_today),
        ),
      ],
    );
  }

  FloatingActionButton saveButton() {
    return FloatingActionButton.extended(
      onPressed: (){
        if(_formKey.currentState!.validate()){
          Function.apply(
            _database.addGoal,
            [],
            formController.map((key, value) => MapEntry(Symbol(key), value.text)),
          ).whenComplete(() => Navigator.pop(context));
        }
      },
      label: Text(
        'ตั้งเป้าหมาย',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
