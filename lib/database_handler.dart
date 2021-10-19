import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DatabaseHandler {
  static final DatabaseHandler _singleton = DatabaseHandler._internal();
  int indexProfile = -1;
  int indexGoal = -1;
  var box;

  factory DatabaseHandler() {
    return _singleton;
  }

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

  Future<void> populateExampleData() async {
    await box.clear();
    box.put('profiles', [
      'นางสาว ตั้งใจ เก็บเงิน',
      'นาย ประหยัด มัธยัสถ์'
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
      },
      {
        'name': 'เกษียณ',
        'price': 3000000,
      }
    ]);
  }

  Future<List<String>> listProfiles() async {
    return await box.get('profiles');
  }

  Future<List> listProfileGoals() async {
    return await box.get(_profileGoals(indexProfile));
  }

  Future<String> getProfile() async {
    List<String> profiles = await listProfiles();
    return profiles[indexProfile];
  }

  Future<Map> getProfileGoal() async {
    List goals = await listProfileGoals();
    return goals[indexGoal];
  }
}
