import 'package:flutter/material.dart';

import 'database_handler.dart';

class GoalPlaningForm extends StatefulWidget{
  @override
  _GoalPlaningForm createState() => _GoalPlaningForm();
}

class _GoalPlaningForm extends State<GoalPlaningForm>{
  final DatabaseHandler _database = DatabaseHandler();
  DateTime? _startdate = null;
  DateTime? _enddate = null;
  String installmentType = 'week';
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'objectName': TextEditingController(),
    'price': TextEditingController(),
    'duration': TextEditingController(),
    'installment': TextEditingController(),
    'creditorName': TextEditingController(),
    'moneyPerInstallment': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
  };
  final Map typeToDays = {
    'week': 7,
    'month': 30,
    'year': 365,
  };

  @override
  void dispose(){
    formController.forEach((key, value) {value.dispose();});
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: formController['objectName'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณาระบุเป้าหมาย' : null;
            },
            decoration: InputDecoration(
              labelText: "เป้าหมาย", 
            ),
          ),
          TextFormField(
            controller: formController['price'],
            keyboardType: TextInputType.number,
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณาระบุจำนวนเงิน' : null;
            },
            decoration: InputDecoration(
              labelText: "จำนวนเงิน",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: new DisabledFocusNode(),
                  controller: formController['startDate'],
                  validator: (value) {
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
                        formController['startDate']!.text = '${_startdate?.day}-${_startdate?.month}-${_startdate?.year}';
                      });
                    });
                },
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          TextFormField(
            onChanged: (string){
              int priceInstallment = int.parse(formController['moneyPerInstallment']!.text);
              int price = int.parse(formController['price']!.text);
              int duration = (price/priceInstallment).ceil();
              int day_duration = typeToDays[installmentType]*duration;
              _enddate = _startdate!.add(Duration(days: day_duration));
              formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
              formController['duration']!.text = duration.toString();              
              setState(() {});
            },
            controller: formController['moneyPerInstallment'],
            keyboardType: TextInputType.number,
            focusNode: (formController['price']!.text.isEmpty) ? new DisabledFocusNode() : null,
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณาระบุจำนวนเงินต่องวด' : null;
            },
            decoration: InputDecoration(
              labelText: "จำนวนเงินต่องวด",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: formController['duration'],
                  onChanged: (string){
                    int duration = int.parse(formController['duration']!.text);
                    int price = int.parse(formController['price']!.text);
                    int priceInstallment = (price/duration).ceil();
                    int day_duration = typeToDays[installmentType]*duration;
                    _enddate = _startdate!.add(Duration(days: day_duration));
                    formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
                    formController['moneyPerInstallment']!.text = priceInstallment.toString();
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
                    if(_startdate!=null && formController['duration']!.text.isNotEmpty){
                      int duration = int.parse(formController['duration']!.text);
                      int day_duration = typeToDays[installmentType]*duration;
                      _enddate = _startdate!.add(Duration(days: day_duration));
                      formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
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
                    if(_startdate!=null && formController['duration']!.text.isNotEmpty){
                      int duration = int.parse(formController['duration']!.text);
                      int day_duration = typeToDays[installmentType]*duration;
                      _enddate = _startdate!.add(Duration(days: day_duration));
                      formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
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
                    if(_startdate!=null && formController['duration']!.text.isNotEmpty){
                      int duration = int.parse(formController['duration']!.text);
                      int day_duration = typeToDays[installmentType]*duration;
                      _enddate = _startdate!.add(Duration(days: day_duration));
                      formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: formController['endDate'],
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
                        formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
                        formController['duration']!.text = duration.toString();
                        formController['moneyPerInstallment']!.text = priceInstallment.toString();
                      });
                    });
                },
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            onPressed: (){
              setState(() {});
              if(_formKey.currentState!.validate()){
                // addGoal(true);
                // Navigator.pop(context);
              }
            },
            label: Text('ตั้งเป้าหมาย',
              style: Theme.of(context).textTheme.headline5,
              ),
            heroTag: null,
          ),
          // Row( 
          //   children: [
          //     Expanded(
          //       child: FloatingActionButton.extended(
          //           onPressed: (){
          //             print(_enddate);
          //             if(formController['endDate']!.text.isNotEmpty){
          //               int day_duration = _enddate!.difference(_startdate!).inDays;
          //               int duration = 0;
          //               duration = day_duration~/typeToDays[installmentType]; //Transform day to week/month/year
          //               formController['duration']!.text = duration.toString();
          //               double priceInstallment = (double.parse(formController['price']!.text)/duration);
          //               formController['moneyPerInstallment']!.text = priceInstallment.ceil().toString();
          //             }
          //             else if(formController['moneyPerInstallment']!.text.isNotEmpty){
          //               print("case 2");
          //               int priceInstallment = int.parse(formController['moneyPerInstallment']!.text);
          //               int price = int.parse(formController['price']!.text);
          //               int duration = (price/priceInstallment).ceil();
          //               int day_duration = typeToDays[installmentType]*duration;
          //               _enddate = _startdate!.add(Duration(days: day_duration));
          //               formController['endDate']!.text = '${_enddate?.day}-${_enddate?.month}-${_enddate?.year}';
          //               formController['duration']!.text = duration.toString();
          //             }
          //             setState(() {});
          //             if(_formKey.currentState!.validate()){
          //                 // addGoal(true);
          //               // Navigator.pop(context);
          //             }
          //           },
          //           label: Text('ช่วยวางแผน',
          //             style: Theme.of(context).textTheme.headline5,
          //           ),
          //           heroTag: null,
          //         ),
          //       ),
          //     Expanded(
          //       child: FloatingActionButton.extended(
          //         onPressed: (){
          //           setState(() {});
          //           if(_formKey.currentState!.validate()){
          //             // addGoal(true);
          //             // Navigator.pop(context);
          //           }
          //         },
          //         label: Text('ตั้งเป้าหมาย',
          //           style: Theme.of(context).textTheme.headline5,
          //           ),
          //         heroTag: null,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      )
    );
  }

  Future<void> addGoal(bool _debug) async {
    if (_debug){
      print("Objective Name: ${formController['objectName']?.text}");
      print("Price: ${formController['price']?.text}");
      print("Duration: ${formController['duration']?.text}");
      print("Installment: ${formController['installment']?.text}");
      print("Creditor Name: ${formController['creditorName']?.text}");
    }
    _database.addGoal(
        name: formController['objectName']?.text,
        price: formController['price']?.text,
        period: formController['duration']?.text,
    );
    //Create box.push here with asynchronus method
  }
}

class GoalPlaning extends StatefulWidget{
  static const routeName = '/goalPlan';
  @override
  _GoalPlaning createState() => _GoalPlaning();
}

class _GoalPlaning extends State<GoalPlaning>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วางแผนการออม'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: GoalPlaningForm(),
                ),
              ),
              // Container(
              //   width: 100,
              //   height: 100,
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: Text("Image Icon"),
              //     color: Colors.grey[700],
              //   ),
              // )
            ],
          ),
        )
      )

    );
  }
}


class DisabledFocusNode extends FocusNode{
  @override
  bool get hasFocus => false;
}

class EnabledFocusNode extends FocusNode{
  @override
  bool get hasFocus => true;
}
