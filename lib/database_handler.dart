import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/paid_history.dart';


class DatabaseHandler {
  static final DatabaseHandler _singleton = DatabaseHandler._internal();
  int indexProfile = -1;
  int indexGoal = -1;
  var box;

  factory DatabaseHandler() => _singleton;
  DatabaseHandler._internal();

  String _profileGoals(int i) {
    if (i == -1) {
      throw Exception('profile not found');
    }
    return 'p${i}-goals';
  }

  String _profileGoalPaids(int i, int j) {
    if (i == -1 || j == -1) {
      throw Exception('profile/goal not found');
    }
    return 'p${i}g${j}-paids';
  }

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('data');
    await ensureProfiles();
    await ensureGoals();
    await ensurePaids();
    await populateExampleData();  // XXX
  }

  Future<void> ensureProfiles() async {
    if (!box.containsKey('profiles')) {
      await box.put('profiles', []);
    }
  }

  Future<void> ensureGoals() async {
    var profiles = await listProfiles();
    for (var i = 0; i < profiles.length; i++) {
      if (!box.containsKey(_profileGoals(i))) {
        await box.put(_profileGoals(i), []);
      }
    }
  }

  Future<void> ensurePaids() async {
    var profiles = await listProfiles();
    for (var i = 0; i < profiles.length; i++) {
      var goals = await listProfileGoals(i);
      for (var j = 0; j < goals.length; j++) {
        if (!box.containsKey(_profileGoalPaids(i, j))) {
          await box.put(_profileGoalPaids(i, j), []);
        }
      }
    }
  }

  Future<void> focusProfile(int index) async {
    indexProfile = index;
  }

  Future<void> unfocusProfile() async {
    unfocusGoal();
    indexProfile = -1;
  }

  Future<void> focusGoal(int index) async {
    indexGoal = index;
  }

  Future<void> unfocusGoal() async {
    indexGoal = -1;
  }

  Future<void> populateExampleData() async {
    await box.clear();
    box.put('profiles', [
      {
        'name': 'นางสาว ตั้งใจ เก็บเงิน',
        'current': 52196,
      },
      {
        'name': 'นาย ประหยัด มัธยัสถ์',
        'current': 777,
      },
    ]);
    box.put('p0-goals', [
      {
        'name': 'ไมโครเวฟ',
        'price': 2000,
        'numPeriod': 4,
        'perPeriod': 500,
        'periodType': 'week',
        'startDate': DateTime(2021, 10, 01),
        'endDate': DateTime(2022, 05, 20),
      },
      {
        'name': 'มอเตอร์ไซค์',
        'price': 30000,
        'numPeriod': 10,
        'perPeriod': 3000,
        'periodType': 'month',
        'startDate': DateTime(2022, 01, 01),
        'endDate': DateTime(2023, 01, 01),
      },
      {
        'name': 'คอมพิวเตอร์',
        'price': 50000,
        'numPeriod': 20,
        'perPeriod': 2500,
        'periodType': 'month',
        'startDate': DateTime(2021, 06, 01),
        'endDate': DateTime(2023, 06, 01),
      },
    ]);
    box.put('p0g0-paids', [300,500,500,400]);
    box.put('p0g1-paids', [0]);
    box.put('p0g2-paids', [1200,2500,2500]);
    box.put('p1-goals', [
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
    box.put('p1g0-paids', [0]);
    box.put('p1g1-paids', [3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3500, 3500, 3500]);
  }

  Future<List> listProfiles() async {
    return await box.get('profiles');
  }

  Future<List> listProfileGoals([int i = -1]) async {
    if (i == -1) {
      i = indexProfile;
    }
    return await box.get(_profileGoals(i));
  }

  Future<List> listProfileGoalPaids([int i = -1, int j = -1]) async {
    if (i == -1) {
      i = indexProfile;
    }
    if (j == -1) {
      j = indexGoal;
    }
    return await box.get(_profileGoalPaids(i, j));
  }

  Future<Map> getProfile([int i = -1]) async {
    List profiles = await listProfiles();
    if (i == -1) {
      i = indexProfile;
    }
    return profiles[i];
  }

  Future<Map> getProfileGoal([int i = -1, int j = -1]) async {
    if (i == -1) {
      i = indexProfile;
    }
    if (j == -1) {
      j = indexGoal;
    }
    List goals = await listProfileGoals(i);
    return goals[j];
  }

  Future<void> addProfile({name: String, current: int}) async {
    List profiles = await listProfiles();
    profiles.add(Map<String, Object>.from({
      'name': name,
      'current': current,
    }));
    await box.put('profiles', profiles);
    await ensureGoals();
  }

  Future<void> addGoal({name: String, price: int,
                        numPeriod: int, perPeriod:int, periodType: String,
                        startDate: DateTime, endDate: DateTime}) async {
    List goals = await listProfileGoals();
    goals.add(Map<String, Object>.from({
      'name': name,
      'price': price,
      'numPeriod': numPeriod,
      'perPeriod': perPeriod,
      'periodType': periodType,
      'startDate': startDate,
      'endDate': endDate,
    }));
    await box.put(_profileGoals(indexProfile), goals);
  }

  Future<void> addGoalPaidEntry() async {
    List goals = await listProfileGoals();
    goals[indexGoal]['paids'].add(0);
    await box.put(_profileGoals(indexProfile), goals);
  }

  Future<void> payGoalLatestPeriod(int amount) async {
    List goals = await listProfileGoals();
    int length = goals[indexGoal]['paids'].length;
    goals[indexGoal]['paids'][length-1] += amount;
    await box.put(_profileGoals(indexProfile), goals);
  }
}
