import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_handler.dart';
import 'misc.dart';


class GoalCreation extends StatefulWidget {
  @override
  State<GoalCreation> createState() => _GoalCreationState();
}


class _GoalCreationState extends State<GoalCreation>{
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


class GoalPlaningForm extends StatefulWidget {
  @override
  _GoalPlaningForm createState() => _GoalPlaningForm();
}


class _GoalPlaningForm extends State<GoalPlaningForm> {
  final DatabaseHandler _database = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'price': TextEditingController(),
    'numPeriod': TextEditingController(),
    'perPeriod': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
  };

  int? _price;
  int? _numPeriod;
  int? _perPeriod;
  String? _periodType = 'week';
  DateTime? _startDate = null;
  DateTime? _endDate = null;

  @override
  void dispose() {
    formController.forEach((_, value) => value.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    makeStartDate(DateTime(date.year, date.month, date.day));
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
          numPeriodField(),
          perPeriodField(),
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
      onChanged: liveCalculationOnPrice,
      validator: refuse([empty('กรุณาระบุจำนวนเงิน'), notInt('จำนวนเงินต้องเป็นจำนวนเต็ม')]),
      decoration: InputDecoration(
        labelText: "จำนวนเงิน",
      ),
    );
  }

  Widget numPeriodField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: formController['numPeriod'],
            keyboardType: TextInputType.number,
            onChanged: liveCalculationOnNumPeriod,
            // TODO can not be zero
            validator: refuse([empty('กรุณาระบุจำนวนงวด'), notInt('จำนวนงวดต้องเป็นตัวเลข')]),
            decoration: InputDecoration(
              labelText: "จำนวนงวด",
            ),
          ),
        ),
        DropdownButton(
          value: _periodType,
          icon: const Icon(Icons.arrow_downward),
          onChanged: liveCalculationOnPeriodType,
          items: periodTypeText.entries.map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          )).toList(),
        ),
      ],
    );
  }

  Widget perPeriodField() {
    return TextFormField(
      controller: formController['perPeriod'],
      keyboardType: TextInputType.number,
      onChanged: liveCalculationOnPerPeriod,
      // TODO can not be zero
      validator: refuse([empty('กรุณาระบุจำนวนเงินต่องวด')]),
      decoration: InputDecoration(
        labelText: "จำนวนเงินต่องวด",
      ),
    );
  }

  Widget startDateField() {
    return TextFormField(
      readOnly: true,
      controller: formController['startDate'],
      onTap: pickDate('startDate'),
      validator: refuse([empty('กรุณาเลือกวันเริ่มต้น')]),
      decoration: InputDecoration(
        labelText: 'กำหนดวันเริ่มต้นออม',
      ),
    );
  }

  Widget endDateField() {
    return TextFormField(
      readOnly: true,
      controller: formController['endDate'],
      onTap: pickDate('endDate'),
      validator: refuse([empty('กรุณาเลือกวันสิ้นสุด')]),
      decoration: InputDecoration(
        labelText: 'วันสิ้นสุดการออม',
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      child: Text('ตั้งเป้าหมาย'),
      onPressed: (){
        if (_formKey.currentState!.validate()) {
          _database.addGoal(
            name: formController['name']!.text,
            price: _price,
            numPeriod: _numPeriod,
            perPeriod: _perPeriod,
            periodType: _periodType,
            startDate: _startDate,
            endDate: _endDate,
          ).whenComplete(() => Navigator.pop(context));
        }
      },
    );
  }

  void Function() pickDate(String which) {
    return (){
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2120),
      ).then((date) {
        switch (which) {
          case 'startDate':
            return makeStartDate(date, updateAnother: true);
          case 'endDate':
            return makeEndDate(date, updateAnother: true);
          default:
        }
      });
    };
  }

  void makeStartDate(DateTime? date, {updateAnother: false}) {
    _startDate = date;
    // TODO date format in th locale
    formController['startDate']!.text = (date == null) ? '' : DateFormat('d/MMM/y').format(date);
    if (updateAnother && _numPeriod != null) {
      updateEndDate();
    }
  }

  void makeEndDate(DateTime? date, {updateAnother: false}) {
    _endDate = date;
    formController['endDate']!.text = (date == null) ? '' : DateFormat('d/MMM/y').format(date);
    if (updateAnother && _numPeriod != null) {
      updateStartDate();
    }
  }

  void extractFormValues() {
    _price = int.tryParse(formController['price']?.text ?? '');
    _numPeriod = int.tryParse(formController['numPeriod']?.text ?? '');
    _perPeriod = int.tryParse(formController['perPeriod']?.text ?? '');
    if (_numPeriod == 0) {
      _numPeriod = null;
    }
    if (_perPeriod == 0) {
      _perPeriod = null;
    }
  }

  void liveCalculationOnPrice(_) {
    extractFormValues();
    if (_price == null) {
      return;
    }
    if (_numPeriod != null) {
      updatePerPeriod();
    } else if (_perPeriod != null) {
      updateNumPeriod();
    } else {
      return;
    }
    decideLiveCalculationOnDate();
  }

  void liveCalculationOnPeriodType(Object? value) {
    _periodType = value!.toString();
    liveCalculationOnPrice('');
  }

  void liveCalculationOnNumPeriod(_) {
    extractFormValues();
    if (_price == null || _numPeriod == null) {
      return;
    }
    updatePerPeriod();
    decideLiveCalculationOnDate();
  }

  void liveCalculationOnPerPeriod(_) {
    extractFormValues();
    if (_price == null || _perPeriod == null) {
      return;
    }
    updateNumPeriod();
    decideLiveCalculationOnDate();
  }

  void decideLiveCalculationOnDate() {
    if (_startDate != null) {
      updateEndDate();
    } else if (_endDate != null) {
      updateStartDate();
    }
  }

  void updateNumPeriod() {
    _numPeriod = (_price! / _perPeriod!).ceil();
    setState((){
      formController['numPeriod']!.text = _numPeriod.toString();
    });
  }

  void updatePerPeriod() {
    _perPeriod = (_price! / _numPeriod!).ceil();
    setState((){
      formController['perPeriod']!.text = _perPeriod.toString();
    });
  }

  void updateStartDate() {
    return makeStartDate(nextTime(_endDate!, -_numPeriod!, _periodType!));
  }

  void updateEndDate() {
    return makeEndDate(nextTime(_startDate!, _numPeriod!, _periodType!));
  }
}
