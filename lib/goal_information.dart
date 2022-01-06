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

  /*
  late final List _periods;
  late final List _paidsPerPeriods;
  */
  int _sumTotal = 0;

  @override
  void initState() {
    super.initState();
    //DateTime date = DateTime.now();
    //_periods = listPeriods(widget.goal['startDate'], date, widget.goal['periodType']);
    //_paidsPerPeriods = listPaidsPerPeriods(widget.goal['startDate'], date, widget.goal['periodType'], widget.goal['paids']);  // TODO passing only widget.goal
    //_periods;
    /*
    _paidsPerPeriods = listSumPerPeriods(
    */
    //_sumTotal = widget.paidsPerPeriods.fold(0, (acc, x) => acc + x['amount'] as int);
    // TODO _sumTotal = sum of sum (2d list)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เป้าหมาย: ${widget.goal['name']}')),
      body: Container(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              child: Column(
                children: [

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

                  Container(
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 40,
                      lineHeight: 40,
                      percent: min(1, _sumTotal/widget.goal['price']),
                      center: Text('${_sumTotal}/${widget.goal['price']}'),
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

  List<GestureDetector> _buildSavingHistory(BuildContext context){
    int count = widget.paidsPerPeriods.length;
    List<GestureDetector> saves = List.generate(
      count,
      (index) => GestureDetector(
        onTap: () {

          /*
          => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PeriodInformation(
              goal: widget.goal,
              period: _periods[index],
              //periodIndex: index, //count - index - 1,
            )).whenComplete((){ // .then((???){
              // TODO recalculate periods

            }),
          );
          */

        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            children: [
              Container(
                width: 70,
                // padding: EdgeInsets.only(right: 15),
                child: Text('งวดที่ ${count-index-1}'),
              ),
              Expanded(
                child: _buildSavingGuage(widget.paidsPerPeriods[count-index-1], widget.goal['perPeriod'])
                ),
            ],
            ),
          ),
        )
      );
    return saves;
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
}
