import 'package:hive/hive.dart';

import 'package:flutter/material.dart';


class AddGoal extends StatefulWidget {
  @override
  _AddGoal createState() => _AddGoal();
}


class _AddGoal extends State<AddGoal> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  DateTime? _datetime = null;

  Future<void> addGoal() async {
    if (titleController.text == '') {
      titleController.text = 'untitled goal';   // TODO
    }
    if (priceController.text == '') {
      priceController.text = '0';
    }
    var box = await Hive.openBox('data');
    var goals = box.get('goals') ?? [];
    goals.add({
      'title': titleController.text,
      'price': int.parse(priceController.text),
      // 'date': TODO
      'paids': [],
      'done': false,
    });
    box.put('goals', goals);
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "ชื่อเป้าหมาย", 
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "ราคา", 
                      ),
                    ),
                    /* TODO hidden now since too much information
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
                    */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Text(
                            _datetime == null ? 'กำหนดวันเริ่มต้น' 
                              : _datetime.toString()
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
                                  _datetime = date;
                                });
                              });
                          }, 
                          child: Text('Open calendar'),
                        ),
                      ],
                    ),
                    /* TODO hidden now since too much information (plus overflow issue)
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ชื่อเจ้าหนี้", 
                      ),
                    ),
                    */
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
}
