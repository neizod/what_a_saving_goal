import 'package:flutter/material.dart';

import 'transaction_creation.dart';
import 'database_handler.dart';


class TransactionSummary extends StatefulWidget{
  const TransactionSummary({Key? key}): super(key: key);

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}


class _TransactionSummaryState extends State<TransactionSummary>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("สรุป"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "สัปดาห์",),
                Tab(text: "เดือน",),
                Tab(text: "ปี",),
              ]
            ),
          ),
        body: const TabBarView(
          children: [
            Text("Tab1"),
            Text("Tab2"),
            Text("Tab3"),
            ],
          ),
        ),
      ),
    );
  }
}
