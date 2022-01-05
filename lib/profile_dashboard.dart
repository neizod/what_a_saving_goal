import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'transaction_summary.dart';
import 'transaction_creation.dart';
import 'goal_information.dart';
import 'goal_creation.dart';
import 'misc.dart';


class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key, required this.profileIndex}) : super(key: key);
  final int profileIndex;

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}


class _ProfileDashboardState extends State<ProfileDashboard> {
  final DatabaseHandler _database = DatabaseHandler();

  Map _profile = {};
  List _goals = [];
  List _paids = [];

  bool _loading = true;
  String _title = 'กำลังโหลดข้อมูล';

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){
      _loading = false;
      _title = _profile['name'];
    }));
  }

  Future<void> getData() async {
    _profile = await _database.getProfile(widget.profileIndex);
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
        title: Text('ภาพรวมบัญชี: ${_title}'),
      ),
      body: _loading ? _showLoadingSplash() : Center( // TODO overflow scroll
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _showTransactionHeader(),
            _showTransactionGuage(),
            _showLatestTransactions(),
            _showQuickAddTransactionButton(),
            Divider(height: 1),
            _showGoalHeadline(),
            _showActiveGoals(),
            _showQuickAddGoalButton(),
          ],
        ),
      ),
    );
  }

  Widget _showLoadingSplash() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _showTransactionHeader() {
    return Container(
      margin: EdgeInsets.all(20),
      child:  Text(
        'ยอดเงินปัจจุบัน: ${_profile['current']} บาท',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _showTransactionGuage() {
    return Container(
      margin: EdgeInsets.all(20),
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
    );
  }

  Widget _showLatestTransactions() {
    return Container(
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionSummary()),
          );
        },
        child: Column(children: List.generate(5, _transactionItem)),
      ),
    );
  }

  Widget _transactionItem(int index) {
    return Container(
      margin: EdgeInsets.all(1),
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
      ),
    );
  }

  Widget _showQuickAddTransactionButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('บันทึกรายรับรายจ่าย'),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionCreation()),
          );
        },
      ),
    );
  }

  Widget _showGoalHeadline() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        'เป้าหมายปัจจุบัน',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _showActiveGoals() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(children: List.generate(_goals.length, _goalItem)),
    );
  }

  Widget _goalItem(int index) {
    int perPeriod = _goals[index]['perPeriod'];
    int currentPeriod = getSumPaidOfCurrentPeriod(_goals[index]['startDate'],
                                                  _goals[index]['periodType'], _paids[index]);
    return GestureDetector(
      onTap: () {
        _database.indexGoal = index;  // XXX use setter
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalInformation(
            title: _goals[index]['name'],
            goal_index: index,
          )),
        );
      },
      child: Container(
        margin: EdgeInsets.all(1),
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

  Widget _showQuickAddGoalButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('เพิ่มเป้าหมาย'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoalCreation()),
          ).whenComplete(() => getData()).whenComplete(() => setState((){}));
        },
      ),
    );
  }
}
