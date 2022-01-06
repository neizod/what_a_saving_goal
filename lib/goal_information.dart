import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'period_information.dart';
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
      body: Container(
        child: Column(
          children: [

            // summary
            Container(
              child: Column(
                children: [
                  _showGoalBasicInformation(),
                  _showTotalProgress(),
                ],
              ),
            ),

            /*
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('ประวัติการออมแบ่งตามเป้าหมายย่อย'),
            ),
            */

            Expanded(
              child: SingleChildScrollView( // TODO haha no, just use listview
                child: Column(
                  children: List.generate(widget.paidsPerPeriods.length, _periodItem),
                ),
              ),
            ),

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

  Widget _showGoalBasicInformation() {
    return Text('TODO');
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

  Widget _showTotalProgress() {
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

  Widget _periodItem(int revIndex) {
    int index = widget.periods.length - revIndex;
    return GestureDetector(
      onTap: _routeToPeriodInformation(revIndex),
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              //width: 70,
              // padding: EdgeInsets.only(right: 15),
              child: Text(makePeriodTitle(index, widget.periods)),
            ),
            Expanded(
              child: _buildSavingGuage(widget.paidsPerPeriods[index], widget.goal['perPeriod'])
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSavingGuage(List<Map> paidsPerPeriod, int perPeriod){
    int sumPeriod = paidsPerPeriod.fold(0, (acc, x) => acc + x['amount'] as int);
    return LinearPercentIndicator(
      lineHeight: 30,
      center: Text('${sumPeriod} / ${perPeriod}'),
      progressColor: Colors.green[400],
      backgroundColor: Colors.red[400],
      percent: min(1, sumPeriod/perPeriod),
      animation: true,
    );
  }

  void Function() _routeToPeriodInformation(int revIndex) {
    return () => Navigator.push(
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
}
