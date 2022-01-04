import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'account_summary.dart';
import 'add_cash.dart';
import 'goal_info.dart';
import 'goal_planing.dart';
import 'misc.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  final DatabaseHandler _database = DatabaseHandler();
  Map _profile = {};
  List _goals = [];
  List _paids = [];

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){}));
  }

  Future<void> getData() async {
    _profile = await _database.getProfile();
    _goals = await _database.listProfileGoals();
    _paids = [];
    for (int j = 0; j < _goals.length; j++) {
      _paids.add(await _database.listProfileGoalPaids(-1, j));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child:  Text(
              'ยอดเงินปัจจุบัน: ${_profile['current']} บาท',
              style: Theme.of(context).textTheme.headline5,
              ),
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            ),
            const SizedBox(height: 20.0),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.red,
                      width: 10,
                      height: 30,
                      child: Center(child:Text('29999')),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.green,
                      width: 10,
                      height: 30,
                      child: Center(child:Text('50000')),
                      ),
                    ),
                  ],
              ),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
            const SizedBox(height: 20.0),
            Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountSummary()),
                  );
                },
                child: Column(
                  children: _buildSpendHistory(5),
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCash()),
                );
              },
              label: Text('บันทึกรายรับรายจ่าย',
                style: Theme.of(context).textTheme.headline5,
              ),
              heroTag: null,
            ),
            const SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('เป้าหมายรายสัปดาห์',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: _buildGoalList()
              ),
            ),
            const SizedBox(height: 20.0),
            FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalPlaning()),
                );
                setState((){});
              },
              label: Text('เพิ่มเป้าหมาย',
                style: Theme.of(context).textTheme.headline5,
              ),
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }

  List<GestureDetector> _buildGoalList() {
    return List.generate(
      _goals.length,
      (index) {
        int perPeriod = _goals[index]['perPeriod'];
        int currentPeriod = getSumPaidOfCurrentPeriod(_goals[index]['startDate'],
                                                      _goals[index]['periodType'], _paids[index]);
        return GestureDetector(
          onTap: () {
            _database.indexGoal = index;  // XXX use setter
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalInfo(
                title: _goals[index]['name'],
                goal_index: index,
              )),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
            child: Row(
              children: [
                Expanded(
                  child: Text('(ราย${periodTypeText[_goals[index]['periodType']]}) ${_goals[index]['name']}'),
                ),
                Expanded(
                  child: LinearPercentIndicator(
                    lineHeight: 20,
                    animation: true,
                    percent: min(1, currentPeriod/perPeriod),
                    center: Text('${currentPeriod}/${perPeriod} บาท'),
                    progressColor: Colors.green[400],
                    backgroundColor: Colors.red[400],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  List<Container> _buildSpendHistory(int count){
    return List.generate(
      count,
       (index) => Container(
          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('ค่าน้ำมันรถ'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text('500'),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 40,
                child: Text("บาท"),
              ),
            ],
          )
        ),
    );
  }
}
