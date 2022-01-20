import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'database_handler.dart';
import 'misc.dart';

class CategoryButton extends StatefulWidget {
  @override
  _CategoryButton createState() => _CategoryButton();
}


class _CategoryButton extends State<CategoryButton> {
  List<String> _categories = ['cat1','cat2','cat3','cat4'];
  List<bool> _selection = List.generate(4, (index) => false);
  String tag = "";

  void _handleTap(int index){
    setState(() {
      for (int i = 0; i< _selection.length; i++) {
        if (i == index) {
          _selection[i] = true;
          tag = _categories[i];
        } else {
          _selection[i] = false;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context){
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: 3,
        childAspectRatio: 10/2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 2,
        children: List.generate(_categories.length,
          (index) => GestureDetector(
            onTap: () {
              _handleTap(index);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _selection[index] ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.black),
              ),
              child: Text(_categories[index],
                style: TextStyle(
                  color: _selection[index] ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*
class DateTimeButton extends StatefulWidget{
  @override
  _DateTimeButton createState() => _DateTimeButton();
}


class _DateTimeButton extends State<DateTimeButton>{
  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget> [
        Container(
          width: 100,
          child: Text("วันที่"),
        ),
        Expanded(
          child: Text("${_date?.day}-${_date?.month}-${_date?.year}"),
        ),
        IconButton(
          onPressed: (){
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2122),
              ).then((date) {
                setState(() {
                  _date = date;
                });
              });
          },
          icon: Icon(Icons.calendar_today)
        ),
      ],
    );
  }
}
*/


class TransactionForm extends StatefulWidget{
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController(text: '0.00');
  final TextEditingController regDateController = TextEditingController();

  bool _edited=false;
  bool _income=true;

  DateTime? _date;

  DateTime getDate() => _date ?? DateTime.now();
  String getName() => descController.text;
  int getPrice() => makeCurrencyInt(priceController.text);
  bool isIncome() => _income;
  

  @override
  _TransactionForm createState() => _TransactionForm();
}


class _TransactionForm extends State<TransactionForm>{
  final NumberFormat numFormat = NumberFormat('#,##0.00');
  final NumberFormat numSanitizedFormat = NumberFormat('en_US');

  @override
  void dispose(){
    widget.priceController.dispose();
    widget.descController.dispose();
    widget.regDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget> [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                
                onTap: (){
                  if(!widget._edited) _handleTap(true);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: widget._income ? Colors.black : Colors.white ,
                    border: Border.all(),
                  ),
                  child: Text("รายรับ",
                    style: TextStyle(
                      color: widget._income ? Colors.white : Colors.black),
                    ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if(!widget._edited) _handleTap(false);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: widget._income ? Colors.white : Colors.black ,
                    border: Border.all(),
                  ),
                  child: Text("รายจ่าย",
                    style: TextStyle(
                      color: widget._income ? Colors.black : Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        Focus(
          onFocusChange: (hasFocus){
            if(!hasFocus){
              debugPrint('on unFocus');
              String price = widget.priceController.value.text;
              if (price == '') price = '0.0';
              final formattedPrice = numFormat.format(double.parse(price));
              debugPrint('Formatted $formattedPrice');
              widget.priceController.value = TextEditingValue(
                text: formattedPrice,
                selection: TextSelection.collapsed(offset: formattedPrice.length)
              );
            }
          },
          child: TextFormField(
            textAlign: TextAlign.right,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),],
            controller: widget.priceController,
            decoration: const InputDecoration(
              suffix: Text('\u0E3F'),
              labelText: "จำนวนเงิน",
            ),
            style: TextStyle(
              fontSize: 25,
              color: (widget._income) ? Colors.green : Colors.red,
            ),
            validator: refuse([empty('กรุณาระบุจำนวนเงิน')]),
            keyboardType: TextInputType.number,
            onTap: () {
              var textFieldNum = widget.priceController.value.text;
              var numSanitized = makeCurrencyInt(textFieldNum)/100;
              debugPrint('Formatted ${numSanitized}');
              widget.priceController.value = TextEditingValue(
                text: numSanitized == 0 ? '' : '$numSanitized',
                selection: TextSelection.collapsed(offset: numSanitized == 0 ? 0 : '$numSanitized'.length)
              );
            },
            onFieldSubmitted: (price) {
              if (price == '') price = '0';
              final formattedPrice = numFormat.format(double.parse(price));
              debugPrint('Formatted $formattedPrice');
              widget.priceController.value = TextEditingValue(
                text: formattedPrice,
                selection: TextSelection.collapsed(offset: formattedPrice.length)
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextFormField(
            controller: widget.descController,
            decoration: const InputDecoration(
              labelText: 'บันทึกช่วยจำ',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0
                ),
              ),
            ),
            maxLines: 3,
          ),
        ),
        TextFormField(
          controller: widget.regDateController,
          decoration: InputDecoration(
            labelText: "วันที่จดบันทึก",
            ),
          onTap: pickDate(),
          readOnly: true,
          ),
        ],
      );
  }

  void _handleTap(bool index){
    setState(() {
        (index) ? widget._income = true : widget._income = false;
      }
    );
  }

  void Function() pickDate() {
    return (){
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2120),
      ).then((date) {
        widget.regDateController.text = makeShortDate(date!);
      });
    };
  }

}


class TransactionCreation extends StatefulWidget{
  TransactionCreation({Key? key, required this.transactions, required this.edited, this.transactionIndex}) : super(key: key);
  
  DatabaseHandler _database = DatabaseHandler();

  final List transactions;
  final bool edited;
  final int? transactionIndex;

  @override
  State<TransactionCreation> createState() => _TransactionCreation();
}

class _TransactionCreation extends State<TransactionCreation> {
  
  final DatabaseHandler _database = DatabaseHandler();
  final TransactionForm _transactionForm = TransactionForm();

  var transaction;

  @override
  void initState() {
    if(widget.edited && widget.transactionIndex!=null){
      transaction = widget.transactions[widget.transactionIndex!];
      int amount = transaction['amount'];
      _transactionForm._edited = true;
      _transactionForm._income = (amount > 0) ? true : false;
      if(amount<0) amount*=-1;
      _transactionForm.descController.text = transaction['name'];
      _transactionForm.priceController.text = makeCurrencyString(amount);
      debugPrint(makeShortDate(transaction['date']));
      _transactionForm.regDateController.text = makeShortDate(transaction['date']);
    }
    else{
      _transactionForm.regDateController.text = makeShortDate(DateTime.now());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          (widget.edited) ? IconButton(
            onPressed: () => deleteTransactionAlert(
              alertTitle: 'ลบรายการ "${transaction['name']}"', 
              alertInformation: 'คุณต้องการลบ "${transaction['name']}" ออกจากการบันทึกใช่หรือไม่'),
            icon: const Icon(Icons.delete_forever_rounded),
          )
          : const SizedBox()
        ],
        title: (widget.edited) ? Text('แก้ไขรายรับรายจ่าย') : Text('เพิ่มรายรับรายจ่าย'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: _transactionForm,
            ),
            // Container(
            //   height: 40,
            //   child: AppBar(
            //     title: Text('ประเภท'),
            //     automaticallyImplyLeading: false,
            //     actions: [
            //       IconButton(
            //         onPressed: (){},
            //         icon: Icon(Icons.add_circle_outline),
            //       )
            //     ],
            //   ),
            // ),
            // CategoryButton(),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.extended(
                onPressed: (){
                  // TODO form validate
                  int sign = _transactionForm._income ? 1 : -1 ;
                  if(widget.edited){
                    widget.transactions[widget.transactionIndex!] = {
                      'name': _transactionForm.getName(),
                      'amount': sign * _transactionForm.getPrice(),
                      'date': _transactionForm.getDate(),
                    };
                    _database.writeDatabase().whenComplete(() => Navigator.pop(context));
                  }
                  else{
                    widget.transactions.add({
                      'name': _transactionForm.getName(),
                      'amount': sign * _transactionForm.getPrice(),
                      'date': _transactionForm.getDate(),
                    });
                    _database.writeDatabase().whenComplete(() => Navigator.pop(context));
                  }

                  //Todo: Implement add data to database function
                },
                label: Text((widget.edited)? 'แก้ไข' : 'เพิ่มบันทึก',
                  // style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void deleteTransactionAlert({String alertTitle='Delete Heading', String alertInformation='Init information'}){
    bool delete=false;
    showDialog(
      context: context, 
      builder: (BuildContext context) => 
        AlertDialog(
        title: Text(alertTitle),
        content: Text(alertInformation),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              }, 
            child: const Text("ยกเลิก")
          ),
          TextButton(onPressed: (){
            widget.transactions.removeAt(widget.transactionIndex!);
            delete=true;
            _database.writeDatabase().whenComplete(() => Navigator.pop(context));
          }, 
          child: const Text("ตกลง")
          )
        ],
      )
    ).whenComplete(() {
      if(delete) Navigator.pop(context);
    });
  }
}
