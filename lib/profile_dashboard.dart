import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
/*
import 'transaction_summary.dart';
import 'transaction_creation.dart';
*/
import 'goal_information.dart';
import 'goal_creation.dart';
import 'misc.dart';


class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key, required this.profile}) : super(key: key);
  final Map profile;

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}


class _ProfileDashboardState extends State<ProfileDashboard> {
  final DatabaseHandler _database = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ภาพรวมบัญชี: ${widget.profile['name']}'),
      ),
      body: Center( // TODO overflow scroll
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*
            _showTransactionHeader(),
            _showTransactionGuage(),
            _showLatestTransactions(),
            _showQuickAddTransactionButton(),
            Divider(height: 1),
            */
            _goalHeadline(context),
            _activeGoalsListView(context),
            _goalCreationButton(context),
          ],
        ),
      ),
    );
  }

  /*
  Widget _showTransactionHeader() {
    return Container(
      margin: EdgeInsets.all(20),
      child:  Text(
        'ยอดเงินปัจจุบัน: ${widget.profile['current']} บาท',
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
  */

  Widget _goalHeadline(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        'เป้าหมายปัจจุบัน',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _activeGoalsListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(24), // TODO tb 8, lr 24
        itemCount: widget.profile['goals'].length,
        itemBuilder: _goalItem,
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Widget _goalItem(BuildContext context, int index) {
    Map goal = widget.profile['goals'][index];
    List periods = listPeriods(goal);
    List paidsPerPeriods = listPaidsPerPeriods(goal, periods);
    return Container(
      height: 40,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(60),
        onTap: () => _routeToGoalInformation(context, index, periods, paidsPerPeriods),
        child: Row(
          children: [
            _goalTitle(goal),
            _goalCurrentProgress(goal, paidsPerPeriods),
          ],
        ),
      ),
    );
  }

  Widget _goalTitle(Map goal) {
    return Expanded(
      child: Text('(ราย${periodTypeText[goal['periodType']]}) ${goal['name']}'),
    );
  }

  Widget _goalCurrentProgress(Map goal, List paidsPerPeriods) {
    List currentPeriod = paidsPerPeriods[paidsPerPeriods.length-2];
    int paidCurrentPeriod = currentPeriod.fold(0, (acc, x) => acc + x['amount'] as int);
    return Expanded(
      child: LinearPercentIndicator(
        lineHeight: 20,
        animation: true,
        percent: min(1, paidCurrentPeriod/goal['perPeriod']),
        center: Text('${paidCurrentPeriod}/${goal['perPeriod']} บาท'),
        progressColor: Colors.green[400],
        backgroundColor: Colors.red[400],
      ),
    );
  }

  Widget _goalCreationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('เพิ่มเป้าหมาย'),
        onPressed: () => _routeToGoalCreation(context),
      ),
    );
  }

  void _routeToGoalInformation(BuildContext context, int index,
                               List periods, List paidsPerPeriods) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInformation(
          goal: widget.profile['goals'][index],
          periods: periods,
          paidsPerPeriods: paidsPerPeriods,
        ),
      ),
    ).whenComplete(() => setState((){}));
  }

  void _routeToGoalCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalCreation(
          goals: widget.profile['goals'],
        ),
      ),
    ).whenComplete(() => setState((){}));
  }
}
