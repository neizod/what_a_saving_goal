import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'price': TextEditingController(),
    'num_period': TextEditingController(),
    'per_period': TextEditingController(),
    'start_date': TextEditingController(),
    'end_date': TextEditingController(),
  };

  final Map periodTypeText = {
    'day': 'วัน',
    'week': 'สัปดาห์',
    'month': 'เดือน',
    'year': 'ปี',
  };

  int? _price;
  int? _numPeriod;
  int? _perPeriod;
  DateTime? _startDate = null;
  DateTime? _endDate = null;
  String? _periodType = 'week';

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
            controller: formController['num_period'],
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
      controller: formController['per_period'],
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
      controller: formController['start_date'],
      onTap: pickDate('start_date'),
      validator: refuse([empty('กรุณาเลือกวันเริ่มต้น')]),
      decoration: InputDecoration(
        labelText: 'กำหนดวันเริ่มต้นออม',
      ),
    );
  }

  Widget endDateField() {
    return TextFormField(
      readOnly: true,
      controller: formController['end_date'],
      onTap: pickDate('end_date'),
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
          Function.apply(
            _database.addGoal,
            [],
            formController.map((key, value) => MapEntry(Symbol(key), value.text)),
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
          case 'start_date':
            return makeStartDate(date, updateAnother: true);
          case 'end_date':
            return makeEndDate(date, updateAnother: true);
          default:
        }
      });
    };
  }

  void makeStartDate(DateTime? date, {updateAnother: false}) {
    _startDate = date;
    // TODO date format in th locale
    formController['start_date']!.text = (date == null) ? '' : DateFormat('d/MMM/y').format(date);
    if (updateAnother && _numPeriod != null) {
      updateEndDate();
    }
  }

  void makeEndDate(DateTime? date, {updateAnother: false}) {
    _endDate = date;
    formController['end_date']!.text = (date == null) ? '' : DateFormat('d/MMM/y').format(date);
    if (updateAnother && _numPeriod != null) {
      updateStartDate();
    }
  }

  void extractFormValues() {
    _price = int.tryParse(formController['price']?.text ?? '');
    _numPeriod = int.tryParse(formController['num_period']?.text ?? '');
    _perPeriod = int.tryParse(formController['per_period']?.text ?? '');
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
      formController['num_period']!.text = _numPeriod.toString();
    });
  }

  void updatePerPeriod() {
    _perPeriod = (_price! / _numPeriod!).ceil();
    setState((){
      formController['per_period']!.text = _perPeriod.toString();
    });
  }

  void updateStartDate() {
    switch (_periodType) {
      case 'day':
        return makeStartDate(_endDate!.subtract(Duration(days: _numPeriod!)));
      case 'week':
        return makeStartDate(_endDate!.subtract(Duration(days: 7*_numPeriod!)));
      case 'month':
        return makeStartDate(nextMonths(_endDate!, -_numPeriod!));
      case 'year':
        return makeStartDate(nextYear(_endDate!, -_numPeriod!));
      default:
    }
  }

  void updateEndDate() {
    switch (_periodType) {
      case 'day':
        return makeEndDate(_startDate!.add(Duration(days: _numPeriod!)));
      case 'week':
        return makeEndDate(_startDate!.add(Duration(days: 7*_numPeriod!)));
      case 'month':
        return makeEndDate(nextMonths(_startDate!, _numPeriod!));
      case 'year':
        return makeEndDate(nextYear(_startDate!, _numPeriod!));
      default:
    }
  }

  DateTime nextMonths(DateTime date, int months) {
    int dayLimit = DateTime(date.year, date.month+months+1, 0).day;
    return DateTime(date.year, date.month+months, min(date.day, dayLimit));
  }

  DateTime nextYear(DateTime date, int years) {
    int dayLimit = DateTime(date.year+years, date.month+1, 0).day;
    return DateTime(date.year+years, date.month, min(date.day, dayLimit));
  }
}
