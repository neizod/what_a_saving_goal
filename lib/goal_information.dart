import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'constants.dart';
import 'database_handler.dart';
import 'paid_creation.dart';
import 'misc.dart';


class GoalInformation extends StatefulWidget {
  const GoalInformation({Key? key, required this.goals, required this.goalIndex, required this.periods, required this.paidsPerPeriods}): super(key: key);
  final List goals;
  final int goalIndex;
  final List periods;
  final List paidsPerPeriods;

  @override
  State<GoalInformation> createState() => _GoalInformationState();
}


class _GoalInformationState extends State<GoalInformation> {
  final DatabaseHandler _database = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => deleteTransactionAlert(
              alertTitle: 'ลบเป้าหมาย "${widget.goals[widget.goalIndex]['name']}"', 
              alertInformation: 'คุณต้องการลบ "${widget.goals[widget.goalIndex]['name']}" ออกจากการบันทึกเป้าหมายใช่หรือไม่'), 
            icon: Icon(Icons.delete_forever_rounded))
        ],
        title: Text('รายละเอียดเป้าหมาย')
      ),
      floatingActionButton: _quickPayButton(context),
      body: Container(
        child: Column(
          children: [
            _goalBasicInformation(context),
            _goalProgress(context),
            Divider(height: 20),
            _periodsHeadline(context),
            _periodsListView(context),
          ],
        ),
      ),
    );
  }

  Widget _goalBasicInformation(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        widget.goals[widget.goalIndex]['name'],
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _goalProgress(BuildContext context) {
    int total = widget.goals[widget.goalIndex]['paids'].fold(0, (acc, x) => acc + x['amount'] as int);
    String totalFormatted = makeCurrencyString(total);
    String goalFormatted = makeCurrencyString(widget.goals[widget.goalIndex]['price']);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LinearPercentIndicator(
        lineHeight: 40,
        percent: min(1, total/widget.goals[widget.goalIndex]['price']),
        center: Text('$totalFormatted/$goalFormatted บาท'),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.green[400],
        backgroundColor: Colors.red[400],
      ),
    );
  }

  Widget _periodsHeadline(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'ประวัติการออมแบ่งตามเป้าหมายย่อย',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _periodsListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.paidsPerPeriods.length,
        itemBuilder: _periodItem,
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Widget _periodItem(BuildContext context, int revIndex) {
    int index = widget.periods.length - revIndex;
    List paidsPerPeriods = widget.paidsPerPeriods[index];
    int sumPeriod = paidsPerPeriods.fold(0, (acc, x) => acc + x['amount'] as int);
    if ((index == 0 || revIndex == 0) && sumPeriod == 0) {
      return SizedBox();
    }
    return Opacity(
    opacity: (index == widget.periods.length-Constants.periodsAhead-1) ? 1 : 0.3,
    child: ExpansionTile(
      title: Row(
        children: [
          Expanded(child: Text(makePeriodTitle(index, widget.periods),)),
          Expanded(child: _periodProgress(paidsPerPeriods, widget.goals[widget.goalIndex]['perPeriod'])),
        ],
      ),
      subtitle: Text(makePeriodRange(index, widget.periods)),
      children: List.generate(
        paidsPerPeriods.length,
        (index) => _paidItem(context, paidsPerPeriods[index]),
      ),
    ),
    );
  }

  Widget _paidItem(BuildContext context, Map paid) {
    return ListTile(
      title: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(60),
        onTap: () => _routeToPaidCreation(context, paid: paid),
        // onTap: () => _routeToEditPaid(context, index),    // TODO enable this
        child: Row(
          children: [
            Expanded(child: Text('${fullDateFormatter.format(paid['date'])}')),
            Expanded(child: Text('${makeCurrencyString(paid['amount'])} บาท', textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }

  Widget _periodProgress(List paidsPerPeriod, int perPeriod){
    int sumPeriod = paidsPerPeriod.fold(0, (acc, x) => acc + x['amount'] as int);
    String sumPeriodFormatted = makeCurrencyString(sumPeriod, floating: false);
    String perPeriodFormatted = makeCurrencyString(perPeriod, floating: false);
    return LinearPercentIndicator(
      lineHeight: 24,
      center: Text('$sumPeriodFormatted / $perPeriodFormatted บาท'),
      progressColor: Colors.green[400],
      backgroundColor: Colors.red[400],
      percent: min(1, sumPeriod/perPeriod),
      animation: true,
    );
  }

  Widget _quickPayButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add_rounded),
      onPressed: () => _routeToPaidCreation(context),
    );
  }

  void _routeToPaidCreation(BuildContext context, {Map? paid}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaidCreation(
          goal: widget.goals[widget.goalIndex],
          paid: paid,
        ),
      ),
    ).whenComplete(() => setState(() {
      widget.paidsPerPeriods.clear();
      widget.paidsPerPeriods.addAll(listPaidsPerPeriods(widget.goals[widget.goalIndex], widget.periods));
    }));
  }
  
void deleteTransactionAlert({String alertTitle='Delete Heading', String alertInformation='Init information'}){
    bool delete=false;
    showDialog(
      context: context, 
      builder: (BuildContext context) => 
        AlertDialog(
        title: Text(alertTitle),
        content: Text(alertInformation),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              }, 
            child: const Text("ยกเลิก")
          ),
          TextButton(onPressed: (){
            widget.goals.removeAt(widget.goalIndex);
            delete=true;
            _database.writeDatabase().whenComplete(() => Navigator.pop(context));
          }, 
          child: const Text("ตกลง")
          )
        ],
      )
    ).whenComplete(() {
      if(delete) Navigator.pop(context);
    });
  }

}
