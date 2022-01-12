import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'database_handler.dart';
import 'transaction_creation.dart';
import 'misc.dart';


class TransactionSummary extends StatefulWidget {
  const TransactionSummary({Key? key, required this.transactions}) : super(key: key);
  final List transactions;

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}


class _TransactionSummaryState extends State<TransactionSummary> {
  final DatabaseHandler _database = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ภาพรวมบัญชี'),
        /*
        actions: [
          IconButton(
            onPressed: () {
              _routeToProfileCreation(this.context);
            }, //Todo Add remove user function
            icon: const Icon(Icons.manage_accounts_rounded),
            tooltip: "จัดการแก้ไขบัญชี",)
        ],
        */
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _transactionSummaryHeader(context),
            _recentTransactionHeadline(context),
            _recentTransactionsListView(context),
            _transactionCreationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _transactionSummaryHeader(BuildContext context) {
    int current = widget.transactions.fold(0, (acc, x) => acc + x['amount'] as int);
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'ยอดเงินปัจจุบัน: ${makeCurrency(current)} บาท',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  /*
  Widget _showTransactionGuage() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        children: [
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
    );
  }
  */

  Widget _recentTransactionHeadline(context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        'รายรับรายจ่ายล่าสุด',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _recentTransactionsListView(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(24),
      itemCount: widget.transactions.length,
      itemBuilder: _transactionItem,
      separatorBuilder: (context, index) => const Divider(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _transactionItem(BuildContext context, int tailIndex) {
    int index = widget.transactions.length - 1 - tailIndex;
    Map transaction = widget.transactions[index];
    return Container(
      margin: EdgeInsets.all(1),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(transaction['name']),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: _transactionAmountText(transaction['amount']),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 40,
            child: Text("บาท"),
          ),
        ],
      ),
    );
  }

  Text _transactionAmountText(int amount) {
    if (amount > 0) {
      return Text('+${makeCurrency(amount)}', style: TextStyle(color: Colors.green[900]));
    }
    return Text('-${makeCurrency(amount.abs())}', style: TextStyle(color: Colors.red[500]));
  }

  Widget _transactionCreationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text('บันทึกรายรับรายจ่าย'),
        onPressed: () => _routeToTransactionCreation(context),
      ),
    );
  }

  void _routeToTransactionCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionCreation(
          transactions: widget.transactions,
        ),
      ),
    ).whenComplete(() => setState((){}));
  }
}
