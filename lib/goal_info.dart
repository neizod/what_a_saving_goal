import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'installment_info.dart';
import 'misc.dart';


class GoalInfo extends StatefulWidget {
  const GoalInfo({Key? key, required this.title, required this.goal_index}): super(key: key);
  final int goal_index;
  final String title;
  @override
  State<GoalInfo> createState() => _GoalInfo();
}


class _GoalInfo extends State<GoalInfo> {
  final DatabaseHandler _database = DatabaseHandler();
  bool _loading = true;
  Map _goal = {};
  List _paids = [];
  List _periods = [];
  List _sumPerPeriods = [];
  int _sumTotal = 0;

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){
      _periods = listPeriods(_goal['startDate'], _goal['endDate'], _goal['periodType']);
      _sumPerPeriods = listSumPerPeriods(_goal['startDate'], _goal['endDate'],
                                         _goal['periodType'], _paids);
      _sumTotal = _sumPerPeriods.fold(0, (a, b) => a + b as int);
      _loading = false;
    }));
  }

  Future<void> getData() async {
    _goal = await _database.getProfileGoal();
    _paids = await _database.listProfileGoalPaids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading ?
        Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
         )) :
        Container(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              child: Column(
                children: [

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
                              child: Text('${_goal['name']}'),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text('${_goal['price']}'),
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
                      percent: min(1, _sumTotal/_goal['price']),
                      center: Text('${_sumTotal}/${_goal['price']}'),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.green[400],
                      backgroundColor: Colors.red[400],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  ),

                ],
              ),
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
              height: 100,
              child: Text('ข้อความสรุป เช่นช้ากว่าเป้าไป 2 งวดนะ หรือ ตอนนี้มีเงินพอปิดยอด'),
            )
          ],
        ),

      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () async {
      //         await _database.addGoalPaidEntry();
      //         setState((){});
      //       },
      //       tooltip: '(for debug)',
      //       mini: true,
      //       backgroundColor: Colors.red,
      //       child: const Icon(Icons.navigate_next),
      //       heroTag: null,
      //     ),
      //     SizedBox(height: 20),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         FloatingActionButton(
      //           onPressed: () async {
      //             await _database.payGoalLatestPeriod(10);
      //             _sumTotal += 10;  // XXX
      //             setState((){});
      //           },
      //           tooltip: 'quick pay',
      //           child: const Text('10'),
      //         ),
      //         SizedBox(width: 20),
      //         FloatingActionButton(
      //           onPressed: () async {
      //             await _database.payGoalLatestPeriod(100);
      //             _sumTotal += 100;  // XXX
      //             setState((){});
      //           },
      //           tooltip: 'quick pay',
      //           child: const Text('100'),
      //         ),
      //         SizedBox(width: 20),
      //         FloatingActionButton(
      //           onPressed: () async {
      //             await _database.payGoalLatestPeriod(1000);
      //             _sumTotal += 1000;  // XXX
      //             setState((){});
      //           },
      //           tooltip: 'quick pay',
      //           child: const Text('1000'),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  List<GestureDetector> _buildSavingHistory(BuildContext context){
    int count = _sumPerPeriods.length;
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
                child: _buildSavingGuage(_sumPerPeriods[count-index-1], _goal['perPeriod'])
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
      center: Text('${save} / ${goal}'),
      progressColor: Colors.green[400],
      backgroundColor: Colors.red[400],
      percent: min(1, save/goal),
      animation: true,
      );
    return saveGuage;
  }
}
