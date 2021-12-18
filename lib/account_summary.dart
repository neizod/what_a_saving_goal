import 'package:flutter/material.dart';
import 'package:what_a_saving_goal/add_cash.dart';
import 'package:what_a_saving_goal/database_handler.dart';

class AccountSummary extends StatefulWidget{
  const AccountSummary({Key? key}): super(key: key);

  @override
  _AccountSummary createState() => _AccountSummary();
}

class _AccountSummary extends State<AccountSummary>{
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
        )
      )
    );
  }
}



