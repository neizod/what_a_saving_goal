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

  /*
  String _profileGoal() {
    if (indexProfile == -1) {
      throw Exception('must select profile');
    }
    return 'p$indexProfile-goals';
  }
  */

  String _profileGoals(int i) {
    return 'p$i-goals';
  }

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('data');
    // await box.clear();
    await ensureProfiles();
    await ensureGoals();
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

  Future<List<String>> listProfiles() async {
    return await box.get('profiles');
  }

  Future<List<String>> listGoals() async {
    return await box.get('goals');  // use current profile
  }

  Future<String> getProfile() async {
    List<String> profiles = await listProfiles();
    return profiles[indexProfile];
  }
}
