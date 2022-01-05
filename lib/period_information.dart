import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'models/paid_history.dart';
import 'database_handler.dart';


class PeriodInformation extends StatefulWidget{
  const PeriodInformation({Key? key, required this.title, required this.installmentIndex, required this.goalIndex}): super(key: key);
  final String title;
  final int installmentIndex;
  final int goalIndex;

  @override
  State<PeriodInformation> createState() => _PeriodInformationState();
}


class _PeriodInformationState extends State<PeriodInformation>{
  final DatabaseHandler _database = DatabaseHandler();
  final paidStatementController = TextEditingController();
  List _goals = [];
  int installmentPrice = 100;
  int paid = 50;
  int installment = 0;
  List<historyPaid> paidHistory = [];
  DateTime now_date = DateTime.now();

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){
      installment = widget.installmentIndex+1;
      paid = _goals[widget.goalIndex]['paids'][widget.installmentIndex];
      installmentPrice = _goals[widget.goalIndex]['price_per_period'];
      // print("Goal Index: ${widget.installmentIndex}");
      paidHistory = _goals[widget.goalIndex]['paids_history'][widget.installmentIndex];
    }));
  }

  Future<void> getData() async {
    _goals = await _database.listProfileGoals();
  }

  @override
  void dispose(){
    paidStatementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("On init function ${paid}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget> [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text('งวดที่ ${installment}: 3 กรกฎาคม - 10 กรกฎาคม',
                  style: Theme.of(context).textTheme.headline5,
                  ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: LinearPercentIndicator(
                  lineHeight: 30,
                  animation: true,
                  center: Text("${paid}/${installmentPrice} บาท"),
                  percent: paid/installmentPrice,
                  progressColor: Colors.green[400],
                  backgroundColor: Colors.red[400],
                  ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('ประวัติการออมเงินประจำงวด',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Expanded(
                child: Column(
                  children: _buildPaidHistory(context)
                  ),
              ),
              FloatingActionButton.extended(
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
                              //Add this statment to database
                              print(paidStatementController.text);
                              DateTime nowDate = DateTime.now();
                              historyPaid transection = historyPaid(dateToString(nowDate), int.parse(paidStatementController.text));
                              paidHistory.add(transection);
                              _goals[widget.goalIndex]['paids'][widget.installmentIndex]+=int.parse(paidStatementController.text);
                              paid = _goals[widget.goalIndex]['paids'][widget.installmentIndex];
                              print('${paidHistory.first.paidDate} ${paidHistory.first.money}');
                              setState(() {
                                Navigator.of(context).pop();
                              });
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

  List<Widget> _buildPaidHistory(BuildContext context){
    int count = paidHistory.length;
    List<Row> paid_hist = List.generate(
      count,
      (index) => Row(
        children: [
          Container(
            width: 200,
            child: Text("${paidHistory[index].paidDate}")
          ),
          Expanded(
            child: Container(
              child: Text("${paidHistory[index].money} บาท")
            )
          ),
        ],
      ),
    );
    return paid_hist;
  }

  String dateToString(DateTime datetime){
    String datetimeString = '${datetime.day}-${datetime.month}-${datetime.year}';
    return datetimeString;
  }

}
