import 'dart:html';

import 'package:flutter/material.dart';

class AddGoal extends StatefulWidget{
  @override
  _AddGoal createState() => _AddGoal();

}

class _AddGoal extends State<AddGoal>{
  DateTime _datetime = DateTime.utc(1990, 1, 1);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเป้าหมาย'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Column(                  
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ชื่อเป้าหมาย", 
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ราคา", 
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ระยะเวลา", 
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "งวด(วัน/สัปดาห์/เดือน)", 
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Text(
                            _datetime.year == 1990 ? 'กำหนดวันเริ่มต้น' 
                              : '${_datetime.day}-${_datetime.month}-${_datetime.year}'
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                              context: context, 
                              initialDate: DateTime.now(), 
                              firstDate: DateTime(2020), 
                              lastDate: DateTime(2022),
                              ).then((date) {
                                setState(() {
                                  _datetime = date!;
                                });
                              });
                          }, 
                          child: Text('Open calendar'),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ชื่อเจ้าหนี้", 
                      ),
                    ),
                    const SizedBox(height: 20,),
                    FloatingActionButton.extended(
                      onPressed: (){
                        addGoal();
                        Navigator.pop(context);
                      },
                      label: Text('เพิ่มเป้าหมาย',
                        style: Theme.of(context).textTheme.headline5,
                        ),
                    ),
                  ],
                ),
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
    );
  }

  void addGoal(){
    
  }
}