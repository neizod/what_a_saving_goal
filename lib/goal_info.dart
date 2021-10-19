import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:what_a_saving_goal/installment_info.dart';

class GoalInfoArguments {
  final String title;
  final int goal_index;

  GoalInfoArguments(this.title, this.goal_index);
}

class GoalInfo extends StatelessWidget{
  // const GoalInfo({Key? key, required this.title}): super(key: key); 
  // final String title;
  static const routeName = "/goalInfo";
  static String _goalDesc = "This is goal desciption from database";
  static int _goalPrice = 5000;
  static int _sumPaid = 3700;
  static int _installmentPrice = 5000~/4;
  static List<int> _paidHist = [1250, 1250, 800, 400];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GoalInfoArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
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
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(args.title),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(_goalDesc),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text("${_goalPrice}"),
                            ),
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
                      percent: _sumPaid/_goalPrice,
                      center: Text("${_sumPaid}/${_goalPrice}"),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.green[400],
                      backgroundColor: Colors.red[400],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstallmentInfo()),
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
                child: _buildSavingGuage(_paidHist[index], _installmentPrice)
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
