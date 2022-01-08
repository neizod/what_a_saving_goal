import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
//import 'period_information.dart';
import 'misc.dart';


class GoalInformation extends StatefulWidget {
  const GoalInformation({Key? key, required this.goal, required this.periods, required this.paidsPerPeriods}): super(key: key);
  final Map goal;
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
        title: Text('เป้าหมาย: ${widget.goal['name']}')
      ),
      floatingActionButton: _quickPayButton(context),
      body: Container(
        child: Column(
          children: [
            _goalBasicInformation(context),
            _goalProgress(context),
            /*
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('ประวัติการออมแบ่งตามเป้าหมายย่อย'),
            ),
            */
            _periodsListView(context),
          ],
        ),
      ),
    );
  }

  Widget _goalBasicInformation(BuildContext context) {
    return Text('');  // TODO
    /*
    Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text('TODO'),  //TODO
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
    */
  }

  Widget _goalProgress(BuildContext context) {
    int total = widget.goal['paids'].fold(0, (acc, x) => acc + x['amount'] as int);
    return Container(
      margin: EdgeInsets.all(20),
      child: LinearPercentIndicator(
        lineHeight: 40,
        percent: min(1, total/widget.goal['price']),
        center: Text('${total}/${widget.goal['price']}'),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.green[400],
        backgroundColor: Colors.red[400],
      ),
    );
  }

  Widget _periodsListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
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
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(child: Text(makePeriodTitle(index, widget.periods))),
          Expanded(child: _periodProgress(paidsPerPeriods, widget.goal['perPeriod'])),
        // TODO find way to merge them Text('${paid}/${widget.goal['perPeriod']} บาท'),
        ],
      ),
      subtitle: Text(makePeriodRange(index, widget.periods)),
      children: List.generate(
        paidsPerPeriods.length,
        (index) => ListTile(
          title: InkWell(
            splashColor: Theme.of(context).primaryColor.withAlpha(60),
            onTap: (){},
            // onTap: () => _routeToEditPaid(context, index),    // TODO enable this
            child: Row(
              children: [
                Expanded(child: Text('${formatter.format(paidsPerPeriods[index]['date'])}')),
                Expanded(child: Text('${paidsPerPeriods[index]['amount']} บาท', textAlign: TextAlign.right)),
              ],
            ),
          ),
        ),
      ),
    );

    /*
    return GestureDetector(
      onTap: () => _routeToPeriodInformation(context, revIndex),
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                //width: 70,
                // padding: EdgeInsets.only(right: 15),
                child: Text(makePeriodTitle(index, widget.periods)),
              ),
            ),
            Expanded(
              child: _periodProgress(widget.paidsPerPeriods[index], widget.goal['perPeriod'])
            ),
          ],
        ),
      ),
    );
    */
  }

  Widget _periodProgress(List paidsPerPeriod, int perPeriod){
    int sumPeriod = paidsPerPeriod.fold(0, (acc, x) => acc + x['amount'] as int);
    return LinearPercentIndicator(
      lineHeight: 24,
      center: Text('${sumPeriod} / ${perPeriod} บาท'),
      progressColor: Colors.green[400],
      backgroundColor: Colors.red[400],
      percent: min(1, sumPeriod/perPeriod),
      animation: true,
    );
  }

  Widget _quickPayButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add_rounded),
      onPressed: () {

        // TODO don't use dialog, but create new page ???
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('amount'),
              actions: [
                TextButton(
                  child: Text('ตกลง'),
                  onPressed: () {
                    widget.goal['paids'].add({
                      'amount': 42,
                      'date': DateTime.now(),
                    });

                    widget.goal['paids'].sort(
                      (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime)
                    );
                    // TODO save
                    // TODO update calc variables

                    // what ??? setState((){});

                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('ยกเลิก'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );

      },
    );
  }

  /*
  void _routeToPeriodInformation(BuildContext context, int revIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PeriodInformation(
          goal: widget.goal,
          periods: widget.periods,
          paidsPerPeriods: widget.paidsPerPeriods,
          index: widget.periods.length - revIndex,
        ),
      ),
    ).whenComplete((){ // .then((???){
      // TODO recalculate periods
    });
  }
  */

}
