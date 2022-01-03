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
    return 'p$i-goals';
  }

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('data');
    await ensureProfiles();
    await ensureGoals();
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
        'period': 4,
        'price_per_period': 500,
        'paids': [300,500,500,400],
      },
      {
        'name': 'มอเตอร์ไซค์',
        'price': 30000,
        'period': 10,
        'price_per_period': 3000,
        'paids': [0],
      },
      {
        'name': 'คอมพิวเตอร์',
        'price': 50000,
        'period': 20,
        'price_per_period': 2500,
        'paids': [1200,2500,2500],
      },
    ]);
    box.put('p1-goals', [
      {
        'name': 'งานแต่ง',
        'price': 300000,
        'period': 30,
        'price_per_period': 10000,
        'paids': [0],
      },
      {
        'name': 'เกษียณ',
        'price': 3000000,
        'period': 400,
        'price_per_period': 7500,
        'paids': [3000, 3000, 3000, 3000, 3000, 3000, 3000, 3000, 3500, 3500, 3500],
      }
    ]);
  }

  Future<List> listProfiles() async {
    return await box.get('profiles');
  }

  Future<List> listProfileGoals() async {
    return await box.get(_profileGoals(indexProfile));
  }

  Future<Map> getProfile() async {
    List profiles = await listProfiles();
    return profiles[indexProfile];
  }

  Future<Map> getProfileGoal() async {
    List goals = await listProfileGoals();
    return goals[indexGoal];
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
                        num_period: int, per_period:int,
                        start_date: String, end_date: String}) async {
    List goals = await listProfileGoals();
    Map<int, List<historyPaid>> paids_history = {};
    List<int> paids = List<int>.generate(num_period, (index) => 0);
    for (int i=0; i<num_period; i++) {
      paids_history[i] = [];
    }
    goals.add(Map<String, Object>.from({
      'name': name,
      'price': price,
      'num_period': num_period,
      'per_period': per_period,
      'start_date': start_date,
      'end_date': end_date,
      'paids': paids,
      'paids_history': paids_history,
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
