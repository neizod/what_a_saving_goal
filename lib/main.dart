import 'package:flutter/material.dart';
import 'package:what_a_saving_goal/login.dart';
import 'package:what_a_saving_goal/add_cash.dart';
import 'add_goal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Saving Goal Home Page'),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _current_balance = 435000;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child:  Text(
              'ยอดเงินปัจจุบัน: $_current_balance บาท',
              style: Theme.of(context).textTheme.headline5,
              ),
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            ),
            const SizedBox(height: 20.0),
            Container(
              child: Row(              
                children: <Widget> [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.red,
                      width: 10,
                      height: 30,
                      child: Center(child:Text('29999')),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.green,
                      width: 10,
                      height: 30,
                      child: Center(child:Text('50000')),
                      ),
                    ),
                  ],
              ),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
            const SizedBox(height: 20.0),
            Container(
            child: Column(
                children: _buildSpendHistory(5),
              ),
            ),
            const SizedBox(height: 20.0),
            FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddCash()));
              },
              label: Text('บันทึกรายรับรายจ่าย',
                style: Theme.of(context).textTheme.headline5,
              ),
              heroTag: null,
            ),
            const SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('เป้าหมายรายสัปดาห์',
                style: Theme.of(context).textTheme.headline5,),
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 0, 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('ซื้อมือถือ'),
                        ),
                      Expanded(
                        flex: 1,
                        child: Text('แถบ progress'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddGoal()));
              },
              label: Text('เพิ่มเป้าหมาย',
                style: Theme.of(context).textTheme.headline5,   
              ),
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }

  List<Container> _buildSpendHistory(int count){
    List<Container> spends = List.generate(
      count,
       (index) => Container(
          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('ค่าน้ำมันรถ'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text('500'),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 40,
                child: Text("บาท"),
              ),
            ],
          )
        ),
    );
  return spends;
  }
}
