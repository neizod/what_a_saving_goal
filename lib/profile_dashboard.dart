import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'transaction_summary.dart';
import 'profile_creation.dart';
import 'transaction_creation.dart';
import 'goal_information.dart';
import 'goal_creation.dart';
import 'misc.dart';


class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key, required this.profiles, required this.profile}) : super(key: key);
  final List profiles;
  final Map profile;

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}


class _ProfileDashboardState extends State<ProfileDashboard> {
  final DatabaseHandler _database = DatabaseHandler();
  final TextEditingController _reminderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ภาพรวมบัญชี'),
        actions: [
          IconButton(
            onPressed: () {
              _routeToProfileCreation(this.context);
            }, //Todo Add remove user function
            icon: const Icon(Icons.manage_accounts_rounded),
            tooltip: "จัดการแก้ไขบัญชี",)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _profileNameHeader(context),
            _transactionSummaryHeader(context),
            //_showTransactionGuage(),
            _recentTransactionHeadline(context),
            _recentTransactionsListView(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _transactionSummaryButton(context),
                _transactionCreationButton(context),
              ],
            ),
            Divider(height: 3),
            _goalHeadline(context),
            _activeGoalsListView(context),
            _goalCreationButton(context),
            Divider(height: 3),
            _reminderHeadline(context),
            _reminderNote(context),
            _reminderEditingButton(context),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _profileNameHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        '${widget.profile['name']}',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _transactionSummaryHeader(BuildContext context) {
    int current = widget.profile['transactions'].fold(0, (acc, x) => acc + x['amount'] as int);
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'ยอดเงินปัจจุบัน: ${makeCurrencyString(current)} บาท',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _recentTransactionHeadline(context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'รายรับรายจ่ายล่าสุด',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _recentTransactionsListView(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(24),
      itemCount: min(3, widget.profile['transactions'].length), // TODO
      itemBuilder: _transactionItem,
      separatorBuilder: (context, index) => const Divider(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _transactionItem(BuildContext context, int tailIndex) {
    int index = widget.profile['transactions'].length - 1 - tailIndex;
    Map transaction = widget.profile['transactions'][index];
    return InkWell(    
      splashColor: Theme.of(context).primaryColor.withAlpha(60),
      onTap: () => _routeToTransactionCreation(context, edited: true, index: index),
      child: Container(
        margin: EdgeInsets.all(1),
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(transaction['name']),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: _transactionAmountText(transaction['amount']),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 40,
              child: Text("บาท"),
            ),
          ],
        ),
      )
    );
  }

  Text _transactionAmountText(int amount) {
    // TODO final formatter = NumberFormat('###.00');
    if (amount > 0) {
      return Text('+${makeCurrencyString(amount)}', style: TextStyle(color: Colors.green[900]));
    }
    return Text('-${makeCurrencyString(amount.abs())}', style: TextStyle(color: Colors.red[500]));
  }

  Widget _transactionSummaryButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('ประวัติ'),
        onPressed: () => _routeToTransactionSummary(context),
      ),
    );
  }

  Widget _transactionCreationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('บันทึกรายรับรายจ่าย'),
        onPressed: () => _routeToTransactionCreation(context),
      ),
    );
  }

  Widget _goalHeadline(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'เป้าหมายปัจจุบัน',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _activeGoalsListView(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(24), // TODO tb 8, lr 24
      itemCount: widget.profile['goals'].length,
      itemBuilder: _goalItem,
      separatorBuilder: (context, index) => const Divider(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
        center: Text('${makeCurrencyString(paidCurrentPeriod)}/${makeCurrencyString(goal['perPeriod'])} บาท'),
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

  Widget _reminderHeadline(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'บันทึกช่วยจำ',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _reminderNote(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        widget.profile['note'],
      ),
    );
  }

  Widget _reminderEditingButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('แก้ไขบันทึก'),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _reminderEditingDialog(context),
        ).then((save) => save ? updateProfileNote(context) : null),
      ),
    );
  }

  Widget _reminderEditingDialog(BuildContext context) {
    _reminderController.text = widget.profile['note'];
    return AlertDialog(
      title: Text('แก้ไขบันทึก'),
      content: TextField(
        controller: _reminderController,
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 5,
        maxLength: 255,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('บันทึก'),
        ),
      ],
    );
  }

  void updateProfileNote(BuildContext context) {
    _database.updateProfileNote(
      widget.profile,
      note: _reminderController.text,
    ).whenComplete(() => setState((){}));
  }

  void _routeToTransactionSummary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSummary(
          transactions: widget.profile['transactions'],
        ),
      ),
    );
  }

  void _routeToTransactionCreation(BuildContext context, {bool edited=false, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionCreation(
          transactions: widget.profile['transactions'],
          edited: edited,
          transactionIndex: index,
        ),
      ),
    ).whenComplete(() => setState((){}));
  }

  void _routeToGoalInformation(BuildContext context, int index,
                               List periods, List paidsPerPeriods) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInformation(
          goals: widget.profile['goals'],
          goalIndex: index,
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

  void _routeToProfileCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileCreation(
          profiles: widget.profiles,
          profile: widget.profile,
        ),
      ),
    ).whenComplete(() => setState((){}));
  }
}
