import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:what_a_saving_goal/misc.dart';

DateTime? _dateTime = DateTime.now();


class PaymentButton extends StatefulWidget{
  @override
  _PaymentButton createState() => _PaymentButton();
}


class _PaymentButton extends State<PaymentButton>{
  bool _income = true;
  bool _outcome = false;

  void _handleTap(int index){
    setState(() {
      if (index == 0) {
        _income = true;
        _outcome = false;
      } else {
        _outcome = true;
        _income = false;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Row(
      
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              _handleTap(0);
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _income ? Colors.black : Colors.white ,
                border: Border.all(),
              ),
              child: Text("รายรับ",
                style: TextStyle(
                  color: _income ? Colors.white : Colors.black),
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
              _handleTap(1);
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _outcome ? Colors.black : Colors.white ,
                border: Border.all(),
              ),
              child: Text("รายจ่าย",
                style: TextStyle(
                  color: _outcome ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class CategoryButton extends StatefulWidget{
  @override
  _CategoryButton createState() => _CategoryButton();
}


class _CategoryButton extends State<CategoryButton>{
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
          child: Text("${_dateTime?.day}-${_dateTime?.month}-${_dateTime?.year}"),
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
                  _dateTime = date;
                });
              });
          },
          icon: Icon(Icons.calendar_today)
        ),
      ],
    );
  }
}

class TransactionForm extends StatefulWidget{
  @override
  _TransactionForm createState() => _TransactionForm();
}

class _TransactionForm extends State<TransactionForm>{
  final NumberFormat numFormat = NumberFormat('#,##0.00');
  final NumberFormat numSanitizedFormat = NumberFormat('en_US');
  final TextEditingController priceController = TextEditingController(text: '0.00');
  final TextEditingController descController = TextEditingController();
  final TextEditingController regDateController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _dateTime = DateTime.now();
    regDateController.text = (_dateTime == null) ? '' : makeShortDate(_dateTime!);
  }

  @override
  void dispose(){
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      
      children: <Widget> [
        Focus(
          onFocusChange: (hasFocus){
            if(!hasFocus){
              debugPrint('on unFocus');
              String price = priceController.value.text;
              if (price == '') price = '0.0';
              final formattedPrice = numFormat.format(double.parse(price));
              debugPrint('Formatted $formattedPrice');
              priceController.value = TextEditingValue(
                text: formattedPrice,
                selection: TextSelection.collapsed(offset: formattedPrice.length)
              );
            }
          },
          child: TextFormField(
            textAlign: TextAlign.right,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),],
            controller: priceController,
            decoration: const InputDecoration(
              suffix: Text('\u0E3F'),
              labelText: "จำนวนเงิน",
            ),
            style: const TextStyle(
              fontSize: 25,
              color: Colors.green,
            ),
            validator: refuse([empty('กรุณาระบุจำนวนเงิน')]),
            keyboardType: TextInputType.number,
            onTap: () {
              var textFieldNum = priceController.value.text;
              var numSanitized = numSanitizedFormat.parse(textFieldNum);
              debugPrint('Formatted $numSanitized');
              priceController.value = TextEditingValue(
                text: numSanitized == 0 ? '' : '$numSanitized',
                selection: TextSelection.collapsed(offset: numSanitized == 0 ? 0 : '$numSanitized'.length)
              );
            },
            onFieldSubmitted: (price) {
              if (price == '') price = '0';
              final formattedPrice = numFormat.format(double.parse(price));
              debugPrint('Formatted $formattedPrice');
              priceController.value = TextEditingValue(
                text: formattedPrice,
                selection: TextSelection.collapsed(offset: formattedPrice.length)
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextFormField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: 'บันทึกช่วยจำ',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0
                ) 
              ),
            ),
            maxLines: 3,
          ),
        ),
        TextFormField(
          controller: regDateController,
          decoration: InputDecoration(
            labelText: "วันที่จดบันทึก",
            ),
          onTap: pickDate(),
          readOnly: true,
          ),
        ],
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
        regDateController.text = makeShortDate(date!);
        }
      );
    };
  }
}

class TransactionCreation extends StatelessWidget {
  TransactionCreation({Key? key, required this.transactions}) : super(key: key);
  final List transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายรับรายจ่าย'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: PaymentButton(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TransactionForm(),
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
                  //Todo: Implement add data to database function
                },
                label: Text('เพิ่มบันทึก',
                  style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
