import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/paid_history.dart';


class DatabaseHandler {
  static final DatabaseHandler _singleton = DatabaseHandler._internal();
  factory DatabaseHandler() => _singleton;
  DatabaseHandler._internal();

  //int profileIndex = -1;
  //int goalIndex = -1;
  late final Box _box;

  String _profileGoals(int? profileIndex) {
    if (profileIndex == null) {
      throw Exception('profile not found');
    }
    return 'p${profileIndex}-goals';
  }

  String _profileGoalPaids(int? profileIndex, int? goalIndex) {
    if (profileIndex == null || goalIndex == null) {
      throw Exception('profile/goal not found');
    }
    return 'p${profileIndex}g${goalIndex}-paids';
  }

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('data');
    await ensureProfiles();
    await ensureGoals();
    await ensurePaids();
    await populateExampleData();  // XXX
  }

  Future<void> ensureProfiles() async {
    if (!_box.containsKey('profiles')) {
      await _box.put('profiles', []);
    }
  }

  Future<void> ensureGoals() async {
    var profiles = await listProfiles();
    for (var i = 0; i < profiles.length; i++) {
      if (!_box.containsKey(_profileGoals(i))) {
        await _box.put(_profileGoals(i), []);
      }
    }
  }

  Future<void> ensurePaids() async {
    var profiles = await listProfiles();
    for (var i = 0; i < profiles.length; i++) {
      var goals = await listProfileGoals(i);
      for (var j = 0; j < goals.length; j++) {
        if (!_box.containsKey(_profileGoalPaids(i, j))) {
          await _box.put(_profileGoalPaids(i, j), []);
        }
      }
    }
  }

  Future<void> populateExampleData() async {
    await _box.clear();
    _box.put('profiles', [
      {
        'name': 'นางสาว ตั้งใจ เก็บเงิน',
        'current': 52196,
      },
      {
        'name': 'นาย ประหยัด มัธยัสถ์',
        'current': 777,
      },
    ]);
    _box.put('p0-goals', [
      {
        'name': 'ไมโครเวฟ',
        'price': 2000,
        'numPeriod': 20,
        'perPeriod': 100,
        'periodType': 'day',
        'startDate': DateTime(2021, 12, 30),
        'endDate': DateTime(2022, 01, 25),
      },
      {
        'name': 'มอเตอร์ไซค์',
        'price': 30000,
        'numPeriod': 6,
        'perPeriod': 5000,
        'periodType': 'quarter',
        'startDate': DateTime(2022, 01, 01),
        'endDate': DateTime(2023, 07, 01),
      },
      {
        'name': 'คอมพิวเตอร์',
        'price': 50000,
        'numPeriod': 20,
        'perPeriod': 2500,
        'periodType': 'week',
        'startDate': DateTime(2021, 12, 10),
        'endDate': DateTime(2022, 06, 01),
      },
    ]);
    _box.put('p0g0-paids', [
      { 'amount': 400, 'date': DateTime(2021, 12, 15) },
      { 'amount': 200, 'date': DateTime(2021, 12, 30) },
      { 'amount': 300, 'date': DateTime(2021, 12, 31) },
      { 'amount': 300, 'date': DateTime(2022, 01, 01) },
      { 'amount': 100, 'date': DateTime(2022, 01, 03) },
    ]);
    _box.put('p0g1-paids', [
      { 'amount': 1500, 'date': DateTime(2022, 01, 01) },
      { 'amount': 9999, 'date': DateTime(2025, 01, 01) },
    ]);
    _box.put('p0g2-paids', [
      { 'amount': 1500, 'date': DateTime(2021, 12, 22) },
      { 'amount': 3000, 'date': DateTime(2021, 12, 28) },
      { 'amount': 1000, 'date': DateTime(2022, 01, 01) },
      { 'amount':  750, 'date': DateTime(2022, 01, 03) },
    ]);
    _box.put('p1-goals', [
      {
        'name': 'งานแต่ง',
        'price': 300000,
        'numPeriod': 3,
        'perPeriod': 100000,
        'periodType': 'year',
        'startDate': DateTime(2010, 01, 01),
        'endDate': DateTime(2040, 01, 01),
      },
      {
        'name': 'เกษียณ',
        'price': 3000000,
        'numPeriod': 400,
        'perPeriod': 7500,
        'periodType': 'month',
        'startDate': DateTime(2020, 01, 01),
        'endDate': DateTime(2050, 01, 01),
      }
    ]);
    _box.put('p1g0-paids', []);
    _box.put('p1g1-paids', [
      { 'amount': 3500, 'date': DateTime(2021, 05, 03) },
      { 'amount': 3500, 'date': DateTime(2021, 06, 03) },
      { 'amount': 3500, 'date': DateTime(2021, 07, 03) },
      { 'amount': 3500, 'date': DateTime(2021, 08, 03) },
      { 'amount': 3500, 'date': DateTime(2021, 09, 03) },
      { 'amount': 4000, 'date': DateTime(2021, 10, 03) },
      { 'amount': 4000, 'date': DateTime(2021, 11, 03) },
      { 'amount': 4000, 'date': DateTime(2021, 12, 03) },
      { 'amount': 5000, 'date': DateTime(2022, 01, 03) },
    ]);
  }

  Future<List> listProfiles() async {
    return await _box.get('profiles');
  }

  Future<List> listProfileGoals(int profileIndex) async {
    return await _box.get(_profileGoals(profileIndex));
  }

  Future<List> listProfileGoalPaids(int profileIndex, int goalIndex) async {
    return await _box.get(_profileGoalPaids(profileIndex, goalIndex));
  }

  Future<Map> getProfile(int profileIndex) async {
    List profiles = await listProfiles();
    return profiles[profileIndex];
  }

  Future<Map> getProfileGoal(int profileIndex, int goalIndex) async {
    List goals = await listProfileGoals(profileIndex);
    return goals[goalIndex];
  }

  Future<void> addProfile({name: String, current: int}) async {
    List profiles = await listProfiles();
    profiles.add(Map<String, Object>.from({
      'name': name,
      'current': current,
    }));
    await _box.put('profiles', profiles);
    await ensureGoals();
  }

  // TODO rename
  Future<void> addGoal(int profileIndex,
                      {name: String, price: int,
                       numPeriod: int, perPeriod:int, periodType: String,
                       startDate: DateTime, endDate: DateTime}) async {
    List goals = await listProfileGoals(profileIndex);
    goals.add(Map<String, Object>.from({
      'name': name,
      'price': price,
      'numPeriod': numPeriod,
      'perPeriod': perPeriod,
      'periodType': periodType,
      'startDate': startDate,
      'endDate': endDate,
      // TODO isComplete: true/false,
    }));
    await _box.put(_profileGoals(profileIndex), goals);
    await ensurePaids();
  }

  /*
  Future<void> addGoalPaidEntry() async {
    List goals = await listProfileGoals();
    goals[goalIndex]['paids'].add(0);
    await _box.put(_profileGoals(profileIndex), goals);
  }

  Future<void> payGoalLatestPeriod(int amount) async {
    List goals = await listProfileGoals();
    int length = goals[goalIndex]['paids'].length;
    goals[goalIndex]['paids'][length-1] += amount;
    await _box.put(_profileGoals(profileIndex), goals);
  }
  */
}
