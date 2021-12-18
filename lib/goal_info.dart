import 'package:flutter/material.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:what_a_saving_goal/database_handler.dart';
import 'package:what_a_saving_goal/installment_info.dart';

class GoalInfo extends StatefulWidget{
  const GoalInfo({Key? key, required this.title, required this.goal_index}): super(key: key);
  final int goal_index;
  final String title;
  @override
  State<GoalInfo> createState() => _GoalInfo();
}


class _GoalInfo extends State<GoalInfo>{
  static String _goalDesc = "This is goal desciption from database";
  static int _goalPrice = 5000;
  static int _sumPaid = 3700;
  static int _installmentPrice = 5000~/4;
  static List<int> _paidHist = [1250, 1250, 800, 400];

  final DatabaseHandler _database = DatabaseHandler();
  List _goals = [];

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){
      _goalPrice = _goals[widget.goal_index]['price'];
      _sumPaid = _goals[widget.goal_index]['paids'].fold(0, (a, b) => a + b);
      _installmentPrice = _goals[widget.goal_index]['price_per_period'];
      _paidHist = _goals[widget.goal_index]['paids'];
    }));
  }

  Future<void> getData() async {
    _goals = await _database.listProfileGoals();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                              child: Text(widget.title),
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
                      percent: min(1, _sumPaid/_goalPrice),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _buildSavingHistory(context),
                  // Saving for Goal History Generator,
                ),
              ),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await _database.addGoalPaidEntry();
              setState((){});
            },
            tooltip: 'quick pay this goal 100 baht',
            child: const Icon(Icons.navigate_next),
            heroTag: null,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () async {
              await _database.payGoalLatestPeriod(100);
              // _sumPaid += 100;  // XXX
              setState((){});
            },
            tooltip: 'quick pay this goal 100 baht',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _database.payGoalLatestPeriod(100);
          _sumPaid += 100;  // XXX
          setState((){});
        },
        tooltip: 'quick pay this goal 100 baht',
        child: const Icon(Icons.add),
      ),
      */
    );
  }

  List<GestureDetector> _buildSavingHistory(BuildContext context){
    int count = _paidHist.length;
    List<GestureDetector> saves = List.generate(
      count,
      (index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstallmentInfo(title: widget.title, installmentIndex: count-index-1, goalIndex: widget.goal_index,)),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            children: [
              Container(
                width: 70,
                // padding: EdgeInsets.only(right: 15),
                child: Text('งวดที่ ${count-index}'),
              ),
              Expanded(
                child: _buildSavingGuage(_paidHist[count-index-1], _installmentPrice)
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
      percent: min(1, save/goal),
      animation: true,
      );
    return saveGuage;
  }
}
