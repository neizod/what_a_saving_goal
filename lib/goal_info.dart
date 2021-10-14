import 'package:flutter/material.dart';

class GoalInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดเป้าหมาย"),
        ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget> [ 
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ชื่อเป้าหมาย'),
                            Text('รายละเอียดเป้าหมาย'),
                            Text('ราคารวมเป้าหมาย'),
                          ],
                          ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[700],
                          ),
                        child: Text('Image Icon'),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      children: <Widget> [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 40,
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              color: Colors.green,
                            ),
                            child: Text('12000'),
                          )
                          ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.red,
                            ),
                            child: Text('6000'),
                          )
                          ),
                      ],
                    ),
                  )
                ],
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('ประวัติการออมแบ่งตามเป้าหมายย่อย'),
            ),
            Column(
              children: _buildSavingHistory(),
              // Saving for Goal History Generator,
              ),
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_sharp),
                ),
            ),
            Container(
              child: Text('ข้อความสรุป เช่นช้ากว่าเป้าไป 2 งวดนะ หรือ ตอนนี้มีเงินพอปิดยอด'),
            )
          ],
          ),
      ),
    );
  }

  List<Container> _buildSavingHistory(){
    List<Container> saves = List.generate(
      4, 
      (index) => Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Row(
          children: [
            Text('งวดที่ ${index+1}'),
            Expanded(
              child: _buildSavingGuage(100, 200)
              ),
          ],
          )
      )
      );

    return saves;
  }

  Row _buildSavingGuage(int save, int goal){
    Row saveGuage = Row(
      children: <Widget> [
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.green,
            ),
            child: Text('$save'),
          )
          ),
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.red,
            ),
            child: Text('$goal'),
          )
          ),
        ],
    );
    return saveGuage;
  }

}