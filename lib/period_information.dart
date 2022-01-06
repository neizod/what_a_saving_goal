import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'models/paid_history.dart';
import 'database_handler.dart';
import 'misc.dart';


class PeriodInformation extends StatefulWidget{
  const PeriodInformation({Key? key, required this.goal, required this.periods,
                           required this.paidsPerPeriods, required this.index}) : super(key: key);
  final Map goal;
  final List periods;
  final List paidsPerPeriods;
  final int index;

  @override
  State<PeriodInformation> createState() => _PeriodInformationState();
}


class _PeriodInformationState extends State<PeriodInformation>{
  final DatabaseHandler _database = DatabaseHandler();

  final paidStatementController = TextEditingController();
  List<historyPaid> paidHistory = [];

  @override
  void dispose(){
    paidStatementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int paid = widget.paidsPerPeriods[widget.index].fold(0, (acc, x) => acc + x['amount'] as int);
    return Scaffold(
      appBar: AppBar(
        title: Text(makePeriodTitle(widget.index, widget.periods)),
      ),
      body: Center(
        child: Container(
          //padding: EdgeInsets.all(20),
          child: Column(
            children: [

              // _showDateRange
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  makePeriodRange(widget.index, widget.periods),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),

              // _showPeriodProgress
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(bottom: 20),
                child: LinearPercentIndicator(
                  lineHeight: 30,
                  animation: true,
                  center: Text('${paid}/${widget.goal['perPeriod']} บาท'),
                  percent: min(1, paid/widget.goal['perPeriod']),
                  progressColor: Colors.green[400],
                  backgroundColor: Colors.red[400],
                ),
              ),

              // _showHistoryHeader
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'ประวัติการออมเงินประจำงวด',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),

              // _showPaidHistory
              Expanded(
                child: Column(
                  children: _buildPaidHistory()
                  ),
              ),

              FloatingActionButton.extended( // haha no
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("กรุณาระบุจำนวนเงิน"),
                        content: TextField(
                          controller: paidStatementController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: (){
                              /*
                              //Add this statment to database
                              print(paidStatementController.text);
                              DateTime nowDate = DateTime.now();
                              historyPaid transection = historyPaid(dateToString(nowDate), int.parse(paidStatementController.text));
                              paidHistory.add(transection);
                              //widget.goal['paids'][widget.periodIndex] += int.parse(paidStatementController.text);
                              //paid = widget.goal['paids'][widget.periodIndex];
                              print('${paidHistory.first.paidDate} ${paidHistory.first.money}');
                              setState(() {
                                Navigator.of(context).pop();
                              });
                              */
                            },
                            child: Text("ตกลง"),
                          ),
                        ],
                      );
                    }
                  );
                },
                label: Text("ชำระเงิน")
              ),

            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPaidHistory(){
    List paids = widget.paidsPerPeriods[widget.index];
    return List.generate(
      paids.length,
      (index) => Row(
        children: [
          Container(
            width: 200,
            child: Text("${paids[index]['date']}")
          ),
          Expanded(
            child: Container(
              child: Text("${paids[index]['amount']} บาท")
            ),
          ),
        ],
      ),
    );
  }

  // TODO use locale
  String dateToString(DateTime datetime){
    String datetimeString = '${datetime.day}-${datetime.month}-${datetime.year}';
    return datetimeString;
  }

}
