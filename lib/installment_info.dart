import 'package:flutter/material.dart';

class InstallmentInfo extends StatelessWidget{
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
              Text('งวดที่ 1: 3 กรกฎาคม - 10 กรกฎาคม',
              style: Theme.of(context).textTheme.headline4,
              ),
            ],
            ),
          ),
        ),
    );
  }
  
}