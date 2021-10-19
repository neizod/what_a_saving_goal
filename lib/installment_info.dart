import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InstallmentInfo extends StatelessWidget{
  static const routeName = "/goalInfo/installmentInfo";
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดเป้าหมาย'),
        ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget> [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text('งวดที่ 1: 3 กรกฎาคม - 10 กรกฎาคม',
                  style: Theme.of(context).textTheme.headline5,
                  ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: LinearPercentIndicator(
                  lineHeight: 30,
                  animation: true,
                  center: Text("300/500 บาท"),
                  percent: 0.5,
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
              Container(
                child: Column(
                  children: [],
                  ),
              ),
            ],
            ),
          ),
        ),
    );
  }
  
}