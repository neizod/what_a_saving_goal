import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'misc.dart';
import 'models/paid_history.dart';


class DatabaseHandler {
  static final DatabaseHandler _singleton = DatabaseHandler._internal();
  factory DatabaseHandler() => _singleton;
  DatabaseHandler._internal();

  late final Box _box;
  final String _boxKey = 'godObject';

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('data');
    if (_box.length == 0) {
      _box.put(_boxKey, []);
    }
    await populateExampleData();  // XXX
  }

  Future<List> fetchDatabase() async {
    return await _box.get(_boxKey, defaultValue: []);
  }

  Future<void> writeDatabase() async {
    await _box.put(_boxKey, await fetchDatabase());
  }

  Future<void> populateExampleData() async {
    await _box.clear();
    _box.put(_boxKey, [
      {
        'name': 'นางสาว ตั้งใจ เก็บเงิน',
        'current': 52196,
        'transactions': [
          {
            'name': 'เงินเดือน',
            'amount': 20000,
            'date': DateTime(2022, 01, 01),
          },
          {
            'name': 'ค่าน้ำมันรถ',
            'amount': -1000,
            'date': DateTime(2022, 01, 03),
          },
          {
            'name': 'อาหารเย็น',
            'amount': -500,
            'date': DateTime(2022, 01, 04),
          },
        ],
        'goals': [
          {
            'name': 'ไมโครเวฟ',
            'price': 2000,
            'numPeriod': 20,
            'perPeriod': 100,
            'periodType': 'day',
            'startDate': DateTime(2021, 12, 30),
            'endDate': DateTime(2022, 01, 25),
            'paids': [
              { 'amount': 400, 'date': DateTime(2021, 12, 15) },
              { 'amount': 200, 'date': DateTime(2021, 12, 30) },
              { 'amount': 300, 'date': DateTime(2021, 12, 31) },
              { 'amount': 300, 'date': DateTime(2022, 01, 01) },
              { 'amount': 100, 'date': DateTime(2022, 01, 03) },
            ],
          },
          {
            'name': 'มอเตอร์ไซค์',
            'price': 30000,
            'numPeriod': 6,
            'perPeriod': 5000,
            'periodType': 'quarter',
            'startDate': DateTime(2022, 01, 01),
            'endDate': DateTime(2023, 07, 01),
            'paids': [
              { 'amount': 1500, 'date': DateTime(2022, 01, 01) },
              { 'amount': 9999, 'date': DateTime(2025, 01, 01) },
            ],
          },
          {
            'name': 'คอมพิวเตอร์',
            'price': 50000,
            'numPeriod': 20,
            'perPeriod': 2500,
            'periodType': 'week',
            'startDate': DateTime(2021, 12, 10),
            'endDate': DateTime(2022, 06, 01),
            'paids': [
              { 'amount': 1500, 'date': DateTime(2021, 12, 22) },
              { 'amount': 3000, 'date': DateTime(2021, 12, 28) },
              { 'amount': 1000, 'date': DateTime(2022, 01, 01) },
              { 'amount':  750, 'date': DateTime(2022, 01, 03) },
            ],
          },
        ],
      },
      {
        'name': 'นาย ประหยัด มัธยัสถ์',
        'current': 777,
        'transactions': [
          {
            'name': 'ถูกหวย',
            'amount': 777,
            'date': DateTime(2007, 07, 07),
          },
        ],
        'goals': [
          {
            'name': 'งานแต่ง',
            'price': 300000,
            'numPeriod': 3,
            'perPeriod': 100000,
            'periodType': 'year',
            'startDate': DateTime(2010, 01, 01),
            'endDate': DateTime(2040, 01, 01),
            'paids': [],
          },
          {
            'name': 'เกษียณ',
            'price': 3000000,
            'numPeriod': 400,
            'perPeriod': 7500,
            'periodType': 'month',
            'startDate': DateTime(2020, 01, 01),
            'endDate': DateTime(2050, 01, 01),
            'paids': [
              { 'amount': 3500, 'date': DateTime(2021, 05, 03) },
              { 'amount': 3500, 'date': DateTime(2021, 06, 03) },
              { 'amount': 3500, 'date': DateTime(2021, 07, 03) },
              { 'amount': 3500, 'date': DateTime(2021, 08, 03) },
              { 'amount': 3500, 'date': DateTime(2021, 09, 03) },
              { 'amount': 4000, 'date': DateTime(2021, 10, 03) },
              { 'amount': 4000, 'date': DateTime(2021, 11, 03) },
              { 'amount': 4000, 'date': DateTime(2021, 12, 03) },
              { 'amount': 5000, 'date': DateTime(2022, 01, 03) },
            ],
          },
        ],
      },
    ]);
  }

  // TODO XXX NOTE: it does NOT enforce the type, we MUST parse it ourselve!
  Future<void> addProfile(List profiles, {name: String, current: int}) async {
    current = makeCurrencyInt(current);
    Map firstEntry = {
      'name': 'ยอดยกมา',
      'amount': current,
      'date': DateTime.now(),
    };
    profiles.add(Map<String, Object>.from({
      'name': name,
      'current': current, // TODO remove and just use sum transactions ???
      'transactions': [firstEntry],
      'goals': [],
    }));
    await writeDatabase();
  }

  Future<void> addGoal(List goals,
                      {name: String, price: int,
                       numPeriod: int, perPeriod:int, periodType: String,
                       startDate: DateTime, endDate: DateTime}) async {
    goals.add(Map<String, Object>.from({
      'name': name,
      'price': price,
      'numPeriod': numPeriod,
      'perPeriod': perPeriod,
      'periodType': periodType,
      'startDate': startDate,
      'endDate': endDate,
      'paids': [],
      // TODO isComplete: true/false,
    }));
    await writeDatabase();
  }
}
