import 'package:flutter/material.dart';

class AddCash extends StatelessWidget{
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายรับรายจ่าย'),
        ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text('รายรับ'),
                        heroTag: null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text('รายจ่าย'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: <Widget> [
                  Row(
                    children: <Widget> [
                      Container(
                        width: 100,
                        alignment: Alignment.bottomLeft,
                        child: Text("รายละเอียด"),
                      ),
                      Expanded(
                        child: TextField(),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget> [
                      Container(
                        width: 100,
                        child: Text("จำนวนเงิน"),
                      ),
                      Expanded(
                        child: TextField(),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget> [
                      Container(
                        width: 100,
                        child: Text("วันที่"),
                      ),
                      Expanded(
                        child: Text("${DateTime.now()}"),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: AppBar(
                title: Text('ประเภท'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.add_circle_outline),
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

}