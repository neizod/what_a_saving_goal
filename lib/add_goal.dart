import 'package:flutter/material.dart';

class AddGoalForm extends StatefulWidget{
  @override
  _AddGoalForm createState() => _AddGoalForm();
}

class _AddGoalForm extends State<AddGoalForm>{
  DateTime? _datetime = null;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'objectName': TextEditingController(),
    'price': TextEditingController(),
    'duration': TextEditingController(),
    'installment': TextEditingController(),
    'creditorName': TextEditingController()
  };


  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: formController['objectName'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณากรอกเป้าหมาย' : null;
            },
            decoration: InputDecoration(
              labelText: "ชื่อเป้าหมาย", 
            ),
          ),
          TextFormField(
            controller: formController['price'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณากรอกราคา' : null;
            },
            decoration: InputDecoration(
              labelText: "ราคา", 
            ),
          ),
          TextFormField(
            controller: formController['duration'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณากรอกระยะเวลา' : null;
            },
            decoration: InputDecoration(
              labelText: "ระยะเวลา", 
            ),
          ),
          TextFormField(
            controller: formController['installment'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณากรอกงวด' : null;
            },
            decoration: InputDecoration(
              labelText: "งวด(วัน/สัปดาห์/เดือน)", 
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: new DisabledFocusNode(),
                  validator: (value) {
                    return _datetime == null ? 'กรุณาเลือกวันเริ่มต้น' : null;
                  },
                  decoration: InputDecoration(
                    labelText: _datetime == null ? 'กำหนดวันเริ่มต้น' 
                      : '${_datetime?.day}-${_datetime?.month}-${_datetime?.year}', 
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(2020), 
                    lastDate: DateTime(2022), 
                    ).then((date) {
                      setState(() {
                        _datetime = date;
                      });
                    });
                }, 
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          TextFormField(
            controller: formController['creditorName'],
            validator: (value) {
              return (value == null || value.isEmpty) ? 'กรุณากรอกชื่อเจ้าหนี้' : null;
            },
            decoration: InputDecoration(
              labelText: "ชื่อเจ้าหนี้", 
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            onPressed: (){
              addGoal(true);
              if(_formKey.currentState!.validate()){
                Navigator.pop(context);
              }
            },
            label: Text('เพิ่มเป้าหมาย',
              style: Theme.of(context).textTheme.headline5,
              ),
          ),
        ],
      )
    );
  }
  void addGoal(bool _debug){
    if(_debug){
      print("Objective Name: ${formController['objectName']?.text}");
      print("Price: ${formController['price']?.text}");
      print("Duration: ${formController['duration']?.text}");
      print("Installment: ${formController['installment']?.text}");
      print("Creditor Name: ${formController['creditorName']?.text}");
    }
    //Create box.push here with asynchronus method

  }
}

class AddGoal extends StatefulWidget{
  @override
  _AddGoal createState() => _AddGoal();

}

class _AddGoal extends State<AddGoal>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเป้าหมาย'),
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
                  child: AddGoalForm(),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  child: Text("Image Icon"),
                  color: Colors.grey[700],
                ),
              )
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