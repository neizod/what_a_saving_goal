import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:what_a_saving_goal/installment_info.dart';

class GoalInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
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
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 40,
                      lineHeight: 40,
                      percent: 0.75,
                      center: Text("7800/12000"),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.green[400],
                      backgroundColor: Colors.red[400],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  )
                ],
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('ประวัติการออมแบ่งตามเป้าหมายย่อย'),
            ),
            Column(
              children: _buildSavingHistory(context),
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

  List<GestureDetector> _buildSavingHistory(BuildContext context){
    Random rng = Random();
    List<GestureDetector> saves = List.generate(
      4, 
      (index) => GestureDetector(
        onTap: () {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => InstallmentInfo())
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            children: [
              Container(
                width: 70,
                // padding: EdgeInsets.only(right: 15),
                child: Text('งวดที่ ${index+1}'),
              ),
              Expanded(
                child: _buildSavingGuage(50+rng.nextInt(150), 200)
                ),
            ],
            ),
          ),
      )
      );

    return saves;
  }

  LinearPercentIndicator _buildSavingGuage(int save, int goal){
    LinearPercentIndicator saveGuage = LinearPercentIndicator(
      lineHeight: 30,
      center: Text("$save / $goal"),
      progressColor: Colors.green[400],
      backgroundColor: Colors.red[400],
      percent: save/goal,
      animation: true,
      );
    return saveGuage;
  }

}