import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:what_a_saving_goal/database_handler.dart';

class InstallmentInfo extends StatefulWidget{
  const InstallmentInfo({Key? key, required this.title, required this.installmentIndex, required this.goalIndex}): super(key: key);
  final String title;
  final int installmentIndex;
  final int goalIndex;
  
  @override
  _InstallmentInfo createState() => _InstallmentInfo();

}

class _InstallmentInfo extends State<InstallmentInfo>{
  final DatabaseHandler _database = DatabaseHandler();
  final paidStatementController = TextEditingController();
  List _goals = [];
  int installmentPrice = 100;
  int paid = 50;
  int installment = 0;
  

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() => setState((){
      installment = widget.installmentIndex+1;
      paid = _goals[widget.goalIndex]['paids'][widget.installmentIndex];
      installmentPrice = _goals[widget.goalIndex]['price_per_period'];
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
                  children: [
                    
                  ],
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
                              // Navigator.of(context).pop();
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
  
}