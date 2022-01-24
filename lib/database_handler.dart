import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'misc.dart';


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
  }

  Future<List> fetchDatabase() async {
    return await _box.get(_boxKey, defaultValue: []);
  }

  Future<void> writeDatabase() async {
    await _box.put(_boxKey, await fetchDatabase());
  }

  Future<void> clearAllData() async {
    await _box.clear();
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
            'amount': 2000000,
            'date': DateTime(2022, 01, 01),
          },
          {
            'name': 'ค่าน้ำมันรถ',
            'amount': -100000,
            'date': DateTime(2022, 01, 03),
          },
          {
            'name': 'อาหารเย็น',
            'amount': -50000,
            'date': DateTime(2022, 01, 04),
          },
          {
            'name': 'อุปกรณ์สำนักงาน',
            'amount': -32800,
            'date': DateTime(2022, 01, 08),
          },
          {
            'name': 'ปุ๋ย',
            'amount': -40000,
            'date': DateTime(2022, 01, 09),
          },
          {
            'name': 'เมล็ดพืช',
            'amount': -30000,
            'date': DateTime(2022, 01, 09),
          },
        ],
        'goals': [
          {
            'name': 'ไมโครเวฟ',
            'price': 200000,
            'numPeriod': 20,
            'perPeriod': 10000,
            'periodType': 'day',
            'startDate': DateTime(2021, 12, 30),
            'endDate': DateTime(2022, 01, 25),
            'paids': [
              { 'amount': 40000, 'date': DateTime(2021, 12, 15) },
              { 'amount': 20000, 'date': DateTime(2021, 12, 30) },
              { 'amount': 30000, 'date': DateTime(2021, 12, 31) },
              { 'amount': 30000, 'date': DateTime(2022, 01, 01) },
              { 'amount': 10000, 'date': DateTime(2022, 01, 03) },
            ],
          },
          {
            'name': 'มอเตอร์ไซค์',
            'price': 3000000,
            'numPeriod': 6,
            'perPeriod': 500000,
            'periodType': 'quarter',
            'startDate': DateTime(2022, 01, 01),
            'endDate': DateTime(2023, 07, 01),
            'paids': [
              { 'amount': 150000, 'date': DateTime(2022, 01, 01) },
              { 'amount':  20000, 'date': DateTime(2022, 01, 09) },
              { 'amount':  50000, 'date': DateTime(2025, 01, 01) },
            ],
          },
          {
            'name': 'คอมพิวเตอร์',
            'price': 5000000,
            'numPeriod': 20,
            'perPeriod': 250000,
            'periodType': 'week',
            'startDate': DateTime(2021, 12, 10),
            'endDate': DateTime(2022, 06, 01),
            'paids': [
              { 'amount': 150000, 'date': DateTime(2021, 12, 22) },
              { 'amount': 300000, 'date': DateTime(2021, 12, 28) },
              { 'amount': 100000, 'date': DateTime(2022, 01, 01) },
              { 'amount':  75000, 'date': DateTime(2022, 01, 03) },
            ],
          },
        ],
      },
      {
        'name': 'นาย ประหยัด มัธยัสถ์',
        'current': 77777,
        'transactions': [
          {
            'name': 'ปันผล',
            'amount': 77777,
            'date': DateTime(2007, 07, 07),
          },
        ],
        'goals': [
          {
            'name': 'งานแต่ง',
            'price': 30000000,
            'numPeriod': 3,
            'perPeriod': 10000000,
            'periodType': 'year',
            'startDate': DateTime(2010, 01, 01),
            'endDate': DateTime(2040, 01, 01),
            'paids': [],
          },
          {
            'name': 'เกษียณ',
            'price': 300000000,
            'numPeriod': 400,
            'perPeriod': 750000,
            'periodType': 'month',
            'startDate': DateTime(2020, 01, 01),
            'endDate': DateTime(2050, 01, 01),
            'paids': [
              { 'amount': 350000, 'date': DateTime(2021, 05, 03) },
              { 'amount': 350000, 'date': DateTime(2021, 06, 03) },
              { 'amount': 350000, 'date': DateTime(2021, 07, 03) },
              { 'amount': 350000, 'date': DateTime(2021, 08, 03) },
              { 'amount': 350000, 'date': DateTime(2021, 09, 03) },
              { 'amount': 400000, 'date': DateTime(2021, 10, 03) },
              { 'amount': 400000, 'date': DateTime(2021, 11, 03) },
              { 'amount': 400000, 'date': DateTime(2021, 12, 03) },
              { 'amount': 500000, 'date': DateTime(2022, 01, 03) },
            ],
          },
        ],
      },
    ]);
  }

  Future<void> createProfile(List profiles, {String? name, int? current}) async {
    Map firstEntry = {
      'name': 'ยอดยกมา',
      'amount': current,
      'date': DateTime.now(),
    };
    profiles.add({
      'name': name,
      'transactions': [firstEntry],
      'goals': [],
    });
    await writeDatabase();
  }

  Future<void> updateProfile(Map profile, {String? name}) async {
    profile['name'] = name;
    await writeDatabase();
  }

  Future<void> deleteProfile(List profiles, Map profile) async {
    profiles.remove(profile);
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
