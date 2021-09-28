import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class SeaoilPreferences {
  dynamic putLocalStorage(key, val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var valString = jsonEncode(val);
    var _res = prefs.setString("$key", valString);
    return _res;
  }

  dynamic getLocalStorage(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String jsonString = prefs.getString("$key") as String;
    var _res = jsonDecode(jsonString);
    return _res;
  }
}

class SharedPrefsKeys {
  static String accessToken = "Seaoil_setaccessToken";
}
